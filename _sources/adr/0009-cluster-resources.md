# Declarative Definitions for Cluster Scoped Resources

- Status: accepted
- Deciders: 4n4nd, anishasthana, HumairAK, tumido
- Date: 2021-01-18

Technical Story: [issue-1](https://github.com/operate-first/odh-moc-support/issues/39), [issue-2](https://github.com/open-infrastructure-labs/ops-issues/issues/2), [pr-2](https://github.com/operate-first/apps/pull/104)

## Context and Problem Statement

A full Git-Ops driven approach we decided to take in the previous ADRs makes us face additional challenges when deploying cluster scoped resources. Resources like `Namespace`, `Group`, `Subscription`, `CustomResourceDefinitions` etc. should be defined declaratively. They should be deployable via ArgoCD and allow users to use an optional encryption layer for sensitive properties/objects that may be considered a PII risk (see [`ADR 0008`](0008-secrets-management.md)). Additionally the resulting layout should be flexible enough that migrating a project between clusters and/or extending the project to multiple clusters is simple enough.

## Decision Drivers

- Declarative manifests in git repo.
- Deployable via ArgoCD with cluster admin permissions.
- Common layout that can be adopted by various downstreams and target cluster deployments.
- Provides consistent secret and sensitive data management.
- Simplifies application onboarding to ArgoCD driven deployment as a single PR.
- Allows to collocate cluster scoped resources along with any supplementary namespace scoped resources.

## Considered Options

Narrow scoped requirements and decision drivers leaves us with only a few options to choose from, however the execution of each is of a great importance.

1. A `namespaces` application deployed via ArgoCD
2. A `cluster-scope` application deployed via ArgoCD
3. Deploy cluster scoped resources as part of OpenShift bootstrap repository

## Decision Outcome

Choosen option: **2. A `cluster-scope` application deployed via ArgoCD**. This application will live within the [github.com/operate-first/apps](https://github.com/operate-first/apps) repository. There it can support various downstreams in the same manner we defined in [ADR 0004](0004-argocd-apps-of-apps-structure.md) and [ADR 0005](0005-support-multi-environments-in-repos.md).

Proposed layout of a `cluster-scope` application:

```
cluster-scope
├── base
│   ├── clusterrolebindings
│   ├── crds
│   ├── subscriptions
│   ├── groups
│   ├── ...
│   └── namespaces
│       ├── foo
│       ...
│       └── bar
│           ├── kustomization.yaml
│           └── namespace.yaml
├── components
│   └── project-admin-rbac
│       ├── baz
│       ...
│       └── qux
│           ├── kustomization.yaml
│           └── rbac.yaml
└── overlays
    ├── environment_1
    ...
    ├── environment_2
    │   ├── groups                   # Example encrypted patch
    │   │   ├── baz.enc.yaml
    │   ├── kustomization.yaml
    │   └── secret-generator.yaml
    └── environment_3
        ├── group-user_patch.yaml    # Example plaintext patch
        └── kustomization.yaml
```

General guidelines:

1. Each folder within `base` corresponds to a cluster-scoped resource kind.
2. Folder `components` contains all mix-and-match resources (depends on target environment) kustomize `Components` that are meant to be imported to any other kustomization.
   - An exception: if the resource kind requires using any other `Component` kind, it has to be kept in `base` and selectively picked to an `overlay` from there. Example: `Namespace`s are selected from `base`, because each namespace includes a `rbac` component.
3. A declarative description of each managed environment is located within the `overlays` folder. There, each environment picks from base what resources to deploy and patches it with the environment specific content.

Example: This environment kustomization would result in deployment selected `Namespaces` and `RoleBinding`, since each namespace uses an `rbac` component.

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../../base/namespaces/odh-operator
  - ../../base/namespaces/opf-argo
```

### Positive Consequences

- Environment specific overlay contains a single `kustomization.yaml` file which only contains a list of applied resources - list of namespaces and groups etc. It can also include lightweight patches. That makes it apparent what gets deployed to a given environment on a first sight which makes it easy to review.
- An ArgoCD application can be defined for each environment in `overlays` ensuring a 1 to 1 mapping of `overlay`s to clusters.
- Provides easy mix-and-match capabilities, while maintaining a single source of truth for each resource.
- Only a single ArgoCD application with a resource whitelist allowing deployment of cluster scoped resources is required to exist per target cluster.

### Negative Consequences

- `components` content can't be environment specific. For example you can't apply different values to namespace resource quota while using the same quota component (environment-specific templating of shared `components`). Possibly can be worked around by patches in `overlays`.

## Rejected options

### A `namespaces` application deployed via ArgoCD

An ad-hock implementation for a `namespaces` application invented for initial support for the cluster scoped resources focusing on `Namespace`s and bundling other resources to those. Other resource kinds like operator `Subscription`s are supposed to be stored within the OpenShift bootstrap repository

Proposed layout:

```
namespaces
├── base
│   ├── foo
│   ...
│   └── bar
│       ├── kustomization.yaml
│       ├── namespace.yaml
│       └── rbac.yaml
└── overlays
    ├── environment_1
    ...
    └── environment_2
        ├── kustomization.yaml
        ...
        ├── baz                       # Example additional, environment specific namespace
        │   ├── group.enc.yaml
        │   ├── kustomization.yaml
        │   ├── namespace.yaml
        │   ├── rbac.yaml
        │   └── secret-generator.yaml
        ...
        └── bar                        # Example namespace overlayed from base
            └── kustomization.yaml
```

Each namespace shared between clusters is expected to be hosted in a folder within `base`. All supplementary namespaced resources which requires cluster admin permissions are collocated here as well. Example: `RoleBinding`s for `ClusterRoles`, `Subscription`s for operators etc. If a namespace is environment (cluster) specific, it is expected to live within environment the overlay only.

Disadvantages:

- Too verbose since it requires many files and folders to be created when accommodating minor changes
- Error prone due to its verbosity and copy-paste nature
- Lacking clear direction for other resource kinds than `Namespace` and `Group`s and `Rolebinding`s.
- If a namespace is environment specific and user want to share it to another environment - different cluster, lot of files has to be moved around.

### Deploy cluster scoped resources as part of OpenShift bootstrap repository

Stick with the current implementation for MOC environment and replicate the same setup for others. Requires each environment to provide an OpenShift bootstrap or configuration repository, which can be either referenced as an environment specific ArgoCD app or the resources are applied as part of the cluster scheduling from the bootstrap repository.

Disadvantages:

- Sharing resources between environments is very limited and would require us to remotely reference from other environment repositories.
- Lacking unified sensitive data management.
