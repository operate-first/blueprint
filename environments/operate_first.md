# Operate First Environment

![drawing](operate_first_environment.png)

## Storage

Some network-attached storage. E.g. a Ceph cluster. For experimental purposes, the storage serving layer can change (ceph -> rook, gluster, nfs)

We do not run a registry, but assume that quay.io is used for all released container images. Each OpenShift cluster will have its own persistent internal registry.


## Orchestration / Management Cluster
#### Use case

Run supporting tools to deploy, monitor and orchestrate the various environments. E.g. ArgoCD, external Monitoring, Ticket Management, etc.

#### Hardware

14 VCPU, 64GB RAM, 1 TB storage

## Dev
#### Use case

Spin up experimental minimal OCP clusters to develop in an interactive environment.

#### Hardware

[4 VCPU, 32GB RAM,  50 GB storage] / Dev Cluster

OSP Platform to provide this HW as virtual resources

## Test & Build (CI/CD/CD)
#### Use case

Run automated unit and integration tests. Build various assets, general tekton pipelines

#### Hardware

64 VCPU,  512 GB RAM,  1.5 TB storage

## Stage N
#### Use case

Minimal replica of production environment with running test workloads. N implementations, depending on different platform configurations and different workloads.

#### Hardware

[16 VCPU, 128GB RAM,  500 GB storage] / Stage Cluster

## Production
#### Use case

Long-running stable environment to support end-user workloads.

#### Hardware

128 VCPU,  2 TB RAM,  400 TB storage
