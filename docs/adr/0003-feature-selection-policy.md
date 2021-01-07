# Users of an Operate First deployment might need different features than provided by upstream project's release

* Status: approved
* Date: 2020-Nov-09

## Context and Problem Statement

Open Data Hub has release v0.8.0, some of the Elyra features required by Thoth Station experiments are
not part of this ODH release. This would require to update certain components to the HEAD of main branch of ODH upstream
project.

## Decision Drivers

* Opertational complexity of an environment diverging from an upstream release
* User needs of more current software components

## Considered Options

* stay with upstream release
* deploy specific versions of components

## Decision Outcome

Chosen option: "deploy specific versions of components", because this will give the most efficient deployment to
Operate First operators and users.

### Positive Consequences

* operators can gain a maximum of experience, enabling feedback on component versions that might have not been tested
by the upstream project
* users get the feature set they need to get the most out of an Operate First deployment

### Negative Consequences

* additional deployment/manifest customizations that are not valuable to upstream project, as they are out of scope
for them

<!-- markdownlint-disable-file MD013 -->
