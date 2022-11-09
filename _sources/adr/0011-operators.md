# Managing Operators

- Status: accepted
- Deciders: tumido, HumairAK, 4n4nd, anishasthana, larsks, martinpovolny
- Date: 2021-01-27

Technical Story: [issue-1](https://github.com/operate-first/apps/issues/126), [pr-1](https://github.com/operate-first/apps/pull/131), [pr-2](https://github.com/operate-first/apps/pull/153)

## Context and Problem Statement

A `cluster-scope` application definition introduced by [ADR 0010][] is a bit vague for use cases like deploying operators. Operator Lifecycle Manager (OLM) defines a resource overlap where a single resource kind can be used in different contexts. For example, Subscription resource can subscribe to a specific operator which can be either cluster-scoped or namespace-scoped. This may go against the distinction introduced in [ADR 0010][]. This document provides guidance on how each of the resource kinds for OLM should be treated in each context and usage variant we aim to support.

## Decision Drivers

- The definition of a `cluster-scope` application at [ADR 0010][] does not provide enough guidance for OLM.
- Various OLM resources can be used in a way which effects the whole cluster or in a way that limits the effects to a single namespace.
- Various OLM resources have permission restrictions or behave as a singletons within a namespace.
- Some operators are not deployed via OLM, yet they behave as operators across all namespaces. Placement of those manifests is also disputed.
- How should we handle meta-operators which operate across all namespaces and deploy other operators that operate across all namespaces?

## Considered Options

1. Deploy all operator-related resources within `cluster-scope` application.
2. Require all namespaced resources to be deployed within individual applications, outside of `cluster-scope`.
3. Find balance between 1. and 2. Deploy resources which have effect on a cluster level within `cluster-scope` app (also the namespace-scoped ones). The rest is deployed in individual applications.

## Decision Outcome

Chosen option: _"3. Find balance between 1. and 2."_, because it is desired to keep track of all resources which may effect other users and other namespaces i.e. operators provisioned to manage all cluster namespaces.

Proposed decision defines strict rules for given resources. These rules are subject to future updates if needed, but the repositories and applications are required to consistently enforce them:

### Operator Lifecycle Manager compatible operators

[Operator Lifecycle Manager][] defines following resource kinds:

- Cluster service version
- Catalog source
- Subscription
- Install plan
- Operator groups

These are the set of guidelines we want to enforce on them:

#### Cluster service version

This resource is not meant to be deployed manually and is expected to be provided from a _Catalog source_. If there's really a need to deploy a custom _Cluster service version_, the resource has to live within the `cluster-scope` application.

#### Catalog source

It is uncommon for a _Catalog source_ to be declared manually. Operators are expected to be provisioned from the default catalogs and it is advised to publish the desired operator to a community catalog rather than deploying a custom _Catalog source_. If it is necessary to deploy an additional `CatalogSource` resource, this resource must be deployed to the `openshift-marketplace` namespace and therefore must be declared within the `cluster-scope` application.

#### Subscription

A `Subscription` resource is a namespace-scoped resource. It is effectively responsible for the operator deployment. Therefore we recognise 2 possible scenarios and use cases for this resource:

1. A namespaced operator with a single namespace visibility:

   The `Subscription` resource can be hosted along with application manifests in an application repository. This application has to be deployed to the same namespace as specified for the subscription.

2. An operator with all namespaces visibility:

   For operators with global effect, we expect the `Subscription` resource to be hosted in `cluster-scope` application only.

Deciding which namespace the OLM resources should reside for global operators will be done on a case-by-case basis. In general, the rule of thumb is to put them in `openshift-operators`, however we take note that there may be various exceptions to this rule (e.g. ClusterLogging, OpenShift Metering, etc.).

The `Subscription` resource manifest is expected to be deployed to the same namespace where the corresponding `OperatorGroup` is located.

#### Install plan

Operators are not expected to deploy a custom _Install plan_. We expect every plan to be provided by the _Cluster service version_ resource belonging to the given operator.

#### Operator groups

An `OperatorGroup` resource is a namespace-scoped resource. However we require this resource to be placed in the `cluster-scope` application only, this is due to the following reasons:

1. This resource is a singleton in namespace context. There can't be multiple instances of the said resource in the same namespace, even if the name differs.
2. When deployed it generates `ClusterRole` and `ClusterRoleBinding` and aggregation rules.
3. It can specify all namespaces visibility for an operator.
4. By default project admins do not have create/edit rights to `OperatorGroup`s (due to points 2 and 3), so only cluster-admins can manage _Operator groups_.

There are a number [of possible conflicts](https://github.com/operator-framework/operator-lifecycle-manager/blob/master/doc/design/operatorgroups.md#what-can-go-wrong) that are a direct consequence of an `OperatorGroup` deployment. These resources need to be treated carefully and therefore it is required for them to be placed and maintained at `cluster-scope` application level.

Centralized `Operator Group` management ensures we won't be deploying the same namespaced operator while we already have another instance with all namespace visibility, etc.

According to the upstream documentation on [`OperatorGroup` target namespace selection][] we enforce and support only these options for target namespace specification in _Operator groups_ specification:

1. A global, cluster-wide operator with visibility to all namespaces, that means the `.spec` section of the manifest is blank.
2. A single namespace operator. Resource manifest specifies `.spec.targetNamespaces: [ SINGLE_MEMBER_NAMESPACE ]`. This namespace has to be deployed via `cluster-scope` application as well.

The `OperatorGroup` resource manifest is expected to be deployed to the same namespace where the corresponding `Subscription` is located.

### Direct operator deployment

Some operators are not deployed via the OLM. That means, their manifests require manual deployment of `CustomResourceDefinition`s, `ClusterRole`s etc. We require this kind of resources to be deployed via `cluster-scope` application.

In contrast to that, all the other resources required for a non-OLM operator deployment, like `Deployment`, `Route` etc. are treated as any other namespace scoped application and all the manifests required for deployment are expected to be located as a separate application in the `operate-first/apps` repository as a root folder.

### Meta-operators

This is a special kind of operator. A meta-operator in this context is understood to be any operator allowing deployment of other operators at cluster scope. Our intention is to limit the possibilities of such operator to be able to interfere with our cluster management in `cluster-scope` application. We expect meta-operators to provide options to either:

- Limit their permissions via operator configuration, so they are not able to deploy resources requiring cluster-admin permissions.
- Limit the create/edit access permission to the custom resources they create, in order to limit normal project users or project admins from escalating their privileges.

If it is not possible to deploy a meta-operator in a way that respects one of the 2 conditions, it is expected from the operator requester to raise this issue upstream. Until this is fixed we expect the operator to be installed manually via [Direct operator deployment](#direct-operator-deployment), not via OLM framework, therefore allowing us to manually control the custom resource access permissions for regular users or the operator service account `ClusterRole`.

### Positive Consequences

- Clear guidance on each and individual resource regarding operators, which may appear confusing without such rules.
- Allows operator to be treated like normal applications in case they are deployed manually. This will not clutter the `cluster-scope` applicaton anymore.
- Enforces restrictions that prevent user privilege escalation via meta-operators.

### Negative Consequences

- Complex set of rules all cluster-admins have to follow and fully understand.

## Pros and Cons of the Options

### Deploy all operator-related resources within `cluster-scope` application

- Good, because it is very easy to implement.
- Good, because it makes the rules very clear for the users - If you want an operator, it needs to live here every time.
- Bad, because it is impossible to achieve for meta-operators like ODH.
- Bad, because it is hard to maintain, since some (especially namespaced) operators may be owned by different teams.
- Bad, because the amount of resources deployed by the `cluster-scope` application may increase drastically.
- Bad, because it doesn't solve meta-operators access - their custom resources can be used to deploy operators on cluster scope anyways.

### Require all namespaced resources to be deployed within individual applications, outside of `cluster-scope`

- Good, because it is very easy to implement.
- Good, because it doesn't require complex rules to follow for the users.
- Bad, because it is impossible to achieve for meta-operators like ODH.
- Bad, because some namespace-scoped resources are required to be unique to the said namespace.
- Bad, because some namespace-scoped resources can grant access to an operator at cluster scope level.

### Find balance between 1. and 2.

- Good, because we can weight each resource kind separately and decide based on the context and use case.
- Good, because it allows us keep the `cluster-scope` application at a reasonable size.
- Good, because it gives enough control to individual application/project owners when they want to deploy namespaced operators.
- Bad, because it requires complex rules and full understanding of the resources by the systems integrators who want to provision an operator.

## Links

- Adds further detail to a specific usecase for [ADR 0010][]
- [Operator Lifecycle Manager][] concepts
- [`OperatorGroup` design document](https://github.com/operator-framework/operator-lifecycle-manager/blob/master/doc/design/operatorgroups.md)
- [`OperatorGroup` target namespace selection][]

[`operatorgroup` target namespace selection]: https://docs.openshift.com/container-platform/4.6/operators/understanding/olm/olm-understanding-operatorgroups.html#olm-operatorgroups-target-namespace_olm-understanding-operatorgroups
[adr 0010]: 0010-common-auth-for-applications.md
[operator lifecycle manager]: https://docs.openshift.com/container-platform/4.6/operators/understanding/olm/olm-understanding-olm.html
