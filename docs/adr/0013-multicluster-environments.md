# Cluster deployment methods
Technical Story: [issue-1](https://github.com/operate-first/apps/issues/306)

## Context and Problem Statement
From the onset we have used the terms "environment" and "cluster" interchangeably, and our repository structure has been reflective of that. However, there seems to be a clear need for a distinction in certain contexts between environments like "MOC" and "Quicklab" and specific clusters belonging to those environments. For example, before we used to use "MOC" to refer to the original `cnv` cluster, but we now have two clusters that belong to the MOC environment (`infra` and `zero`). Furthermore, since there is no such thing as one defacto "Quicklab/CRC" cluster, when we design for these environments we have to design for a very generic environment without adding configurations tuned for one specific cluster. In consideration of these different factors, we must design with _Multi-Cluster Environments_ in mind and restructure existing repos accordingly.


## Considered Options

### 1. Organize repos at Cluster level
This would mean ignoring logical grouping of clusters into environments and treating clusters at an individual scope without considering commonalities between them.

### Pros:

Keeps things simple, we don't need to think too hard about what resources should be considered "common" and what clusters should be considered part of the same environment.

### Cons:

Introduces redundant configurations. There's also no clear way to include `dev` environments, as these tend to be associated with ephemeral clusters.

### 2. Organize repos at Environment Level
This would mean grouping clusters as belonging to certain logical environments. An existing example would be `infra` and `zero` clusters belonging to the "MOC" environment.

### Pros:

Having a `common` location for resources/configs for similar cluster groupings can drastically reduce the work required to copy resources over to clusters belonging to the same environment.

### Cons:
Extra consideration needs to be put into how clusters are grouped together going forward, and what resources should be considered `common`.

## Preferred option
Option `2` is the preferred option here, as it's more scalable. Reducing the number of configs associated with each environment is a lot more scalable in the future then the added initial overhead of deciding how clusters ought to be grouped.

## Outcomes
Option 2 is picked and existing repos re-organized with Apps configured for clusters belonging to common environments. In the case for `dev` environments, Apps will be configured to be entirely generic and non-cluster specific.
