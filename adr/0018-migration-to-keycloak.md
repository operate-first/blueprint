# Authentication migration to Keycloak

* Status: deprecated, no-longer-relevant
* Deciders: goern
* Date: 2023-04-25

Technical Story: https://github.com/orgs/operate-first/projects/24

## Context and Problem Statement

The Operate First Cloud environment spans multiple data centers and multiple regions.
A central authentication system helps identifying users and system operators without maintaining multiple isolated user registries.
This ADR builds upon and extends [0010-common-auth-for-applications](0010-common-auth-for-applications.md) and [0017-authentication-for-platform](0017-authentication-for-platform.md)
and decides on technical aspects and implementation.

## Decision Drivers

Previous ADRs decided input conditions such as:

* GitHub is the ultimate identity provider.
* Applications running within the platform should be able to leverage common authentication as a client.

This ADR answers on how to achieve following:

1. Fully declarative - new clusters can be integrated with SSO via a PR.
2. Provide seamless migration and transition for users.
3. Centralized and single SSO instance.

## Considered Options

1. Authenticate OpenShift against GitHub directly and provide app authentication via Keycloak
2. Authenticate OpenShift against GitHub directly and provide app authentication via Dex against OpenShift
3. Authenticate OpenShift and apps against Keycloak
4. Authenticate OpenShift and apps against Keycloak and migrate OpenShift groups to Keycloak Groups
5. Authenticate OpenShift against Keycloak and provide app authentication via Dex against OpenShift

## Decision Outcome

Chosen option: _"5. Authenticate OpenShift against Keycloak and provide app authentication via Dex against OpenShift"_, because it's a fully declarative solution that is fully supported and available today.

This ADR should be revisited after Keycloak becomes capable of importing/providing OpenShift Groups data ([Keycloak RFE 18532][1]). Then option _3. Authenticate OpenShift and apps against Keycloak_ should be preferred.

### Authenticating Openshift clusters

Each cluster will connect to a centralized Keycloak instance. This centralized Keycloak is coupled with a GitHub application which facilitates authentication:

![](https://chart.googleapis.com/chart?cht=gv&chl=digraph{"Openshift+cluster+0"->Keycloak[type=s];"Openshift+cluster+1"->Keycloak[type=s];"Openshift+cluster+N"->Keycloak[type=s];Keycloak->Github[type=s]})

### Authenticating application within Operate First

This doesn't change and remains the same as described in [ADR 0010](0010-common-auth-for-applications.md).

### Positive Consequences

* When adding a new clusters, all SSO configuration happens via Git
* When adding a new application, all SSO configuration happens via Git
* Single, centralized Keycloak instance available to all clusters

### Negative Consequences

* Per cluster Dex deployment to allow application authentication due to the fact that Keycloack can't import OpenShift groups.

## Pros and Cons of the Options

### Authenticate OpenShift against GitHub directly and provide app authentication via Keycloak

* Good, because authentication is decentralized and each cluster handles authentication separately.
* Bad, because authentication is decentralized and there's no single registry of all Operate First users.
* Bad, since each cluster requires manual changes in GitHub application used as auth provider.
* Bad, because Keycloak is not able to import OpenShift user groups and surface them in OICD claims. Blocked by [Keycloak RFE 18532][1].

### Authenticate OpenShift against GitHub directly and provide app authentication via Dex against OpenShift

* Good, because authentication is decentralized and each cluster handles authentication separately.
* Bad, because authentication is decentralized and there's no single registry of all Operate First users.
* Bad, since each cluster requires manual changes in GitHub application used as auth provider.
* Bad, because we have to maintain a per cluster Dex deployment to provide applications with identity from OpenShift.

### Authenticate OpenShift and apps against Keycloak

* Good, onboarding new clusters is fully declarative.
* Good, because authentication is centralized and only one system is the ultimate source of truth for all accounts.
* Bad, because two separate Keycloak realms are required.
* Bad, because Keycloak is not able to import OpenShift user groups and surface them in OICD claims. Blocked by [Keycloak RFE 18532][1].

### Authenticate OpenShift and apps against Keycloak and migrate OpenShift groups to Keycloak Groups

* Good, onboarding new clusters is fully declarative.
* Good, because authentication is centralized and only one system is the ultimate source of truth for all accounts.
* Bad, because two separate Keycloak realms are required.
* Bad, because Keycloak Operator doesn't provide a declarative management for user groups.

### Authenticate OpenShift against Keycloak and provide app authentication via Dex against OpenShift

* Good, onboarding new clusters is fully declarative.
* Good, because authentication is centralized and only one system is the ultimate source of truth for all accounts.
* Bad, because we have to maintain a per cluster Dex deployment to provide applications with identity from OpenShift.

## Links

* [Keycloak RFE 18532][1]


[1]: https://issues.redhat.com/browse/KEYCLOAK-18532
