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
* [ART-0005](docs/adr/0005-support-multi-environments-in-repos.md) - Repositories Supporting Multiple Environment Deployments
* [ART-0006](docs/adr/0006-monitoring-structure.md) - Application Monitoring using Prometheus
* [ART-0007](docs/adr/0007-alerting-setup.md) - Alerting Setup for Monitoring
* [ART-0008](docs/adr/0008-secrets-management.md) - GitOPS and Secrets Management
* [ART-0009](docs/adr/0009-cluster-resources.md) - Declarative Definitions for Cluster Scoped Resources
* [ART-0010](docs/adr/0010-common-auth-for-applications.md) - Common Authentication for Applications
* [ART-0011](docs/adr/0011-operators.md) - Managing Operators
* [ART-0012](docs/adr/0012-moc-infra-cluster-deployment-methods.md) - MOC Infra Cluster Deployment Methods
* [ART-0013](docs/adr/0013-multicluster-environments.md) - Multi-Cluster Environments
* [ART-0014](docs/adr/0014-enforcing-resource-quotas.md) - Enforcing of Resource Quotas
* [ART-0015](docs/adr/0015-cluster-resources-amendment.md) - Enforcing of Resource Quotas
