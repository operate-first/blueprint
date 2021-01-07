# Application Monitoring in Operate First using Prometheus

* Status: accepted
* Deciders: 4n4nd, anishasthana, hemajv, HumairAK, tumido
* Date: 2021-01-06

Technical Story: [issue-1](https://github.com/operate-first/blueprint/issues/8)
                 [issue-2](https://github.com/operate-first/apps/issues/57)

## Context and Problem Statement

Since there will be multiple services deployed in the Operate First environment
(ex. Jupyterhub, Argo, Superset, etc), we need to be able to monitor them. <br>
To do so we will use [Prometheus](https://prometheus.io/).

How do we structure the Prometheus-Operator/Prometheus Deployments in
Operate First?

## Decision Drivers <!-- optional -->

* Access to cluster-wide permissions
  * The Prometheus instance might not have cluster wide resource access
* Prometheus resource locations
  * Where do we keep the monitoring resources like servicemonitors/podmonitors?
  * Whose responsibility is it to create these monitoring resources?
* Complexity of Prometheus deployments
  * How many instances of Prometheus do we deploy?
  * Which namespaces should these Prometheus instances be deployed in?

## Considered Options

* Option 1:
  * Single Prometheus instance in a dedicated monitoring namespace
  * Servicemonitors/podmonitors can be kept in the monitoring namespace
  * Give Prometheus serviceaccount the roles to access services in other
    namespaces
* Option 2:
  * Each namespace with a service has an instance of Prometheus
  * All servicemonitors/podmonitors will need to be kept in their respective
    service namespaces
  * One main Prometheus will federate metrics from all the instances of Prometheus
* Option 3:
  * Single Prometheus instance in a dedicated monitoring namespace
  * Give Prometheus serviceaccount the clusterrole to access services and other
    monitoring resources cluster wide
  * Servicemonitors/podmonitors can be kept in any namespace


## Decision Outcome

Chosen option: Option 1, because:
  * Set up is less complex than Option 2, only a single Prometheus instance is
    needed
  * No clusterroles are required like Option 3, only roles to access specific
    namespaces are required
