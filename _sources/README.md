# Operate First Blueprint

This section contains documentation of the Operate First Blueprint, covering the topics of architecture (including logical diagrams and documents of decisions taken) and the process to create deployments (including schema and physical diagrams).

Architectural Decisions
-----------------------

[Architectural decisions](https://adr.github.io/) are design decisions with some level of architectural significance. At Operate First, we track architectural decisions using lightweight architectural decision records. More information on the format we follow is available at https://adr.github.io/madr/.

* [ADR-0000](adr/0000-use-markdown-architectural-decision-records.md) - Use Markdown Architectural Decision Records
* [ADR-0001](adr/0001-use-gpl3-as-license.md) - Use GNU GPL as license
* [ADR-0003](adr/0003-feature-selection-policy.md) - Users of an Operate First deployment might need different features than provided by upstream project's release
* [ADR-0004](adr/0004-argocd-apps-of-apps-structure.md) - ArgoCD Apps of Apps Structure
* [ADR-0005](adr/0005-support-multi-environments-in-repos.md) - Repositories Supporting Multiple Environment Deployments
* [ADR-0006](adr/0006-monitoring-structure.md) - Application Monitoring using Prometheus
* [ADR-0007](adr/0007-alerting-setup.md) - Alerting Setup for Monitoring
* [ADR-0008](adr/0008-secrets-management.md) - GitOPS and Secrets Management
* [ADR-0009](adr/0009-cluster-resources.md) - Declarative Definitions for Cluster Scoped Resources
* [ADR-0010](adr/0010-common-auth-for-applications.md) - Common Authentication for Applications
* [ADR-0011](adr/0011-operators.md) - Managing Operators
* [ADR-0012](adr/0012-moc-infra-cluster-deployment-methods.md) - MOC Infra Cluster Deployment Methods
* [ADR-0013](adr/0013-multicluster-environments.md) - Multi-Cluster Environments
* [ADR-0014](adr/0014-enforcing-resource-quotas.md) - Enforcing of Resource Quotas
* [ADR-0015](adr/0015-cluster-resources-amendment.md) - Declarative Definitions for Cluster Scoped Resources - Addendum
* [ADR-0016](adr/0016-pr-review.md) - Reviewing Pull Requests
* [ADR-0017](adr/0017-authentication-for-platform.md) - Authentication for all platform environments
* [ADR-0018](adr/0018-migration-to-keycloak.md) - Authentication migration to Keycloak
* [ADR-0019](adr/0019-org-management.md) - Maintaining GitHub organization as a code
* [ADR-0020](adr/0020-service-catalog.md) - Provide a service catalog
* [ADR-0021](adr/0021-sre-cloud-support.md) - Operate First Community Cloud support process
* [ADR-0022](adr/0022-rules-for-entity-mapping-in-service-catalog.md) - Rules for entity mapping in Service Catalog

Continuous Delivery
-------------------

At Operate First, continuous delivery is a tool that uses source-to-image and Docker builds to containerize your application and provide you with an image to utilize in your deployment. Click [here](https://www.operate-first.cloud/blueprints/continuous-delivery/docs/continuous_delivery.md) to learn more about our vision of the continuous delivery concept.
