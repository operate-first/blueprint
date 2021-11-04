# Maintaining GitHub organization as a code

* Status: accepted
* Deciders: tumido, goern
* Date: 2021-10-01

Technical Story: [operate-first/community#36](https://github.com/operate-first/community/issues/36)

## Context and Problem Statement

Managing GitHub organizations via UI is restricted to few individuals only and does not offer any review mechanisms. The same apply to repository creation, organization membership management and label management. This ADR focuses on bringing transparency into this aspect of housekeeping within a community and aims to provide a way to individual contributors, so they can influence and propose changes themselves.

ADR seeks a way to manage GitHub organization as a code, declaratively via GitOps as a natural extension of the core paradigm of Operate First movement.

## Decision Drivers

Improve transparency, provide auditing and reviews and allow individual contributors to propose changes.

## Considered Options

1. Prow's [Peribolos][1]

## Decision Outcome

Chosen option: _"1. Prow's Peribolos"_, because it's a declarative solution that is widely embraced in upstream communities like Kubernetes.

### Positive Consequences

* Repositories can be created declaratively.
* Even external users can request themselves to be added to the organization via a pull request.
* Teams can be created and maintained declaratively.
* Labels can be centrally managed in a unified way as well as updated per repository bases.
* Solution can be easily automated via post-submit Prow jobs.

### Negative Consequences

* Using a declarative configuration may not be as straightforward as clicking buttons in the UI.
* Some users can still do manual changes to repositories they own, these changes are undone by the automation.

## Links

* [Peribolos][1]
* [How Kubernetes Uses GitOps to Manage GitHub Communities at Scale][2]

[1]: https://github.com/kubernetes/test-infra/tree/master/prow/cmd/peribolos
[2]: https://www.youtube.com/watch?v=te3Xj2zr1Co
