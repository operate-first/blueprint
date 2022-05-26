# Provide a service catalog

* Status: accepted
* Deciders: tumido, durandom, HumairAK, SamoKopecky
* Date: 2022-05-26

Technical Story: https://github.com/operate-first/support/issues/560, https://github.com/operate-first/support/issues/556

## Context and Problem Statement

As a transparent and open Community cloud we need a simple yet complete way of displaying services that are available on our platform, their current status, support path etc.

## Decision Drivers

* Service catalog is configurable declaratively
* Tool can be deployed on Kubernetes
* Learning curve is shallow for service providers, so adding/updating/maintaining entries in the Service catalog is not a burden.

## Considered Options

* Red Hat's Service Dashboard
* Implement a new solution
* Backstage
* Kronicle
* Third party paid service

## Decision Outcome

Chosen option: "Backstage", because we don't want to reimplement the tooling, we want something opensource and Backstage is now a CNCF project.

### Positive Consequences

* There's a ready tool to be used that satisfy our needs.
* It is possible to define the service catalog declaratively via config file
* Partial Kuberentes support
* It is the most mature tool of all available ones

### Negative Consequences

* Not fully Kuberentes native
  * To enable plugins we are required to make code changes and rebuild the container
  * Service definition is not a custom resource
* Authentication may be required
* Doesn't feature Kubernetes operator - services are not defined as custom resources
* Not a mature project - especially on Kubernetes.

## Pros and Cons of the Options

### Red Hat service dashboard

https://gitlab.cee.redhat.com/service/status-board/

* Good, because it's Kubernetes native
* Good, because it's multicluster by design
* Bad, because it's not opensource
* Bad, because it's tightly connected to Red Hat's internal infrastructure

### Implement a new solution

* Good, because can be fully Kubernetes native
* Good, because can match our needs precisely
* Bad, because it would be a considerable time and people investment
* Bad, because we would end up reinventing the wheel yet again

### Kronicle

https://kronicle.tech/

* Good, because it's Kubernetes native
* Good, because it's presumably easy to configure
* Bad, because UX feels clunky and not easily consumable for ens user
* Bad, because maturity of this project feels very low

### Third party paid service

* Good, because it is a feature complete solution, polished and integrated experience
* Bad, because it's not hosted within the Operate First Community cloud
* Bad, because it's not open sourced
* Bad, because this goes against principles of operating a community cloud

<!-- markdownlint-disable-file MD013 -->
