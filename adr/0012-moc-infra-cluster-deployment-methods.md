# Cluster deployment methods for moc-infra cluster

* Status: deprecated, no-longer-relevant
* Deciders: goern
* Date: 2023-04-25

## Context and Problem Statement

This document suggests options for the preferred deployment method for the **moc-infra cluster** at the MOC(Mass Open Cloud). This hub cluster will be the central OpenShift cluster to manage and deploy other clusters on-demand.

The moc-infra cluster is a bare-metal cluster. Deploying an OpenShift Container Platform on bare metal can be achieved by several methods.

## Considered Options

### UPI - User provioned indrastructure

Deploy an OpenShift cluster on infrastructure that you prepare and maintain.

We decided not to take this option under consideration since there is more effort involved in setting up the infrastructure.

### IPI - Installer provisioned infrastructure

Deploy an OpenShift cluster on infrastructure that the installation program provisions and the cluster maintains.

* Good, because the installation is closer to a disconnected environment, and it's a good practice.
* Good, because this method uses an external tool that is available for all.
* Good, because this is a lightweight, comfortable and available tool to the general public.

### Assisted Installer

Discovery ISO that makes it easy to connect discovered hardware.

* Good, because Assisted Installer is a growing Red Hat tool to install a new cluster, getting familiar with it will have future benefits.
* Good, because this tool will be part of ACM deployment of new clusters.
* Good, because it's a good opportunity to provided feedback to the developers.
* Good, because can be easily automated, use API calls.
* Good, because this method allows booting bare-metal nodes from an ISO image.
* Bad, because this is a tech preview tool, not completed product.

## Preferred option

We chose to deploy the cluster using the IPI method because it is a light and easy deployment, available for the public to use, and easy to automate the process for reproducible deployment.

## Outcomes
We deployed our moc-infra management cluster using the IPI installation method.

## References
 - [OpenShift Container Platform installation overview](https://docs.openshift.com/container-platform/4.7/installing/index.html#installation-overview_ocp-installation-overview)
 - [IPI baremetal deployment GitHub repo](https://github.com/openshift-kni/baremetal-deploy)
 - [Assisted Installer GitHub repo](https://github.com/openshift/assisted-installer)
 - [OpenShift Assisted Instller Demo](https://www.openshift.com/blog/using-the-openshift-assisted-installer-service-to-deploy-an-openshift-cluster-on-metal-and-vsphere)
