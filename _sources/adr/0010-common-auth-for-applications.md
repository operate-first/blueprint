# Common Authentication for Applications

- Status: accepted
- Deciders: tumido, HumairAK, anishasthana, 4n4nd
- Date: 2021-01-19

Technical Story: [issue-1](https://github.com/open-infrastructure-labs/ops-issues/issues/10), [issue-2](https://github.com/operate-first/apps/issues/65), [issue-3](https://github.com/operate-first/apps/issues/48), [issue-4](https://github.com/operate-first/apps/issues/47), [issue-5](https://github.com/operate-first/apps/issues/39), [issue-6](https://github.com/operate-first/apps/issues/37)

## Context and Problem Statement

Applications deployed within Operate First are run on top of OpenShift. Many applications require users to log in in order to be able to enforce RBAC, quotas and sandboxing. It is also essential for auditing. User management of the applications should be unified so the same user can access all the applications with a single set of credentials. The username should be unique, but also utilized across applications. The accepted solution should provide SSO, so the user can cary over the identity across different applications. The identity and authentication should be based on the OpenShift authentication.

## Decision Drivers

- For the same user a single user identity is provided to all applications.
- All users are able to authenticate using the same credentials as they use for the underlying OpenShift platform.
- User identity provided by the SSO allows for similar RBAC settings across different applications.

## Considered Options

1. ArgoCD embedded Dex server
2. Standalone Dex server in a separate namespace
3. Keycloak server via a Keycloak operator
4. OpenShift Oauth server

## Decision Outcome

Chosen option: _"2. Standalone Dex server in a separate namespace"_, because

### Positive Consequences

- Each Operate First application can consume user identity for all SSO authenticated users.
- Applications don't have to care about user management.
- SSO allows us to share the RBAC rules between applications in similar contexts since the user identity structure (LDAP groups, etc.) is the same.

### Negative Consequences

- Introduces a single point of failure for all user authentications.

## Pros and Cons of the Options

### Argo CD embedded Dex server

Lives within the Argo CD deployment. Argo CD implements its own wrapper around Dex configuration and deployment, which may prove to be difficult to adjust to application specific usage.

Dex server can provide OpenID identity, can connect to variety OpenID Connect identity sources connectors (Openshift, Github, Google, SSO providers, etc.) and since it's confined to its own namespace it allows for easier SRE as well as future expansion with client database for identity carry over between applications.

- Good, because it is already prepared and available and proved to work with ArgoCD.
- Good, because it is a lightweight bridge solution to existing OpenID Connect providers.
- Bad, because it's not isolated to a separate namespace and doesn't allow full control over the Dex configuration.
- Bad, because the deployed Dex server version depends on what Dex version is packaged for ArgoCD by ArgoCD configurator wrapper.

### Standalone Dex server in a separate namespace

This option allows us to keep all the benefits of a Dex server without compromising ArgoCD stability/reliability.

- Good, because configuration is fully in our control as well as Dex version used.
- Good, because of the isolation, can be scaled and restricted by quotas.
- Good, because it is a lightweight bride solution to existing OpenID connect providers.

### Standalone Dex server via an operator

This option allows us to keep all the benefits of a Dex server without compromising Argo CD stability/reliability. It also simplifies management duties, since it can be managed declaratively via custom resources.

- Good, because configuration is fully in our control as well as Dex version used
- Good, because of the isolation, can be scaled and restricted by quotas
- Good, because it is a lightweight bride solution to existing OpenID connect providers
- Good, because it is easy to configure via custom resources.
- Bad, because there are only 2 community implementation, no official one.
- Bad, because neither of the currently available Dex operator implementations are maintained.

In the end, this would be the preferred solution, if there was a reliable implementation available.

### Keycloak server via an operator

Keycloak is a heavy duty identity provided and access management. It can be installed via a Kubernetes operator and can be managed declaratively via custom resources. It can do all the identity provider bridging provided by Dex as well as many more like provide identity on its own, manage LDAP etc.

- Good, because it is easy to configure via custom resources.
- Bad, because it is heavy weight, resource intensive solution, requiring external database and other components which may prove to be difficult to use in edge/dev cluster setting.

### OpenShift Oauth server directly

Use OpenShift Oauth directly. This option provides means to authenticate against OpenShift, however OpenShift itself doesn't provide OpenID identity and relies on external sources.

- Good, because it is already available in the platform and no setup is needed.
- Bad, because we are lacking the essential - there's no identity provided. Only authentication.
- Bad, because applications usually require identity to be provided no matter if user is authenticated.

## Links

- [Keycloak vs. Dex](https://medium.com/@sct10876/keycloak-vs-dex-71f7fab29919)

<!-- markdownlint-disable-file MD013 -->
