# Operate First Blueprint

This repository containers documentation of the Operate First Blueprint, it covers topics like architecture (incl.
logical diagrams, documents of decisions taken), deployment (schema or physical diagrams).

Architectural decisions
-----------------------

We keep track of architectural decisions using a lightweigh architectural decision records. More information on the
used format is available at https://adr.github.io/madr/. General information about architectural decision records
is available at https://adr.github.io/ .

Architectural decisions

* [ADR-0000](docs/adr/0000-use-markdown-architectural-decision-records.md) - Use Markdown Architectural Decision Records
* [ADR-0001](docs/adr/0001-use-gpl3-as-license.md) - Use GNU GPL as license
* [ART-0003](docs/adr/0003-feature-selection-policy.md) - Users of an Operate First deployment might need different features than provided by upstream project's release
* [ART-0004](docs/adr/0004-argocd-apps-of-apps-structure.md) - ArgoCD Apps of Apps Structure
* [ART-0005](docs/adr/0005-support-multi-environments-in-repos.md) - Repositories supporting multiple environment deployments
