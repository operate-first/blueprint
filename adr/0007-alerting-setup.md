# Alerting Setup for Operate First Monitoring

* Status: accepted
* Deciders: hemajv, 4n4nd, anishasthana, HumairAK, tumido, mhild

Technical Story: [issue-1](https://github.com/operate-first/SRE/issues/14), [issue-2](https://github.com/operate-first/SRE/issues/19), [issue-3](https://github.com/operate-first/blueprint/issues/16)

## Context and Problem Statement

As we have multiple services/applications deployed and monitored in the Operate First environment (ex. Jupyterhub, Argo, Superset, Observatorium, Project Thoth, AICoE CI pipelines etc), we need to implement an incident reporting setup for handling outages/incidents related to these services.

All the services are being monitored by [Prometheus](https://prometheus.io/). Prometheus scrapes and stores time series data identified by metric key/value pairs for each of the available services. These metrics can be used for measuring the service performance and alerting on any possible service degradation such as basic availability, latency, durability and any other applicable SLI/SLOs. These SLI/SLOs for the various services are defined and documented in the [SRE repository](https://github.com/operate-first/SRE/tree/master/sli-slo).

Alerting with Prometheus is separated into two parts. Alerting rules in Prometheus servers send alerts to an [Alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/). The Alertmanager then manages those alerts, including silencing, inhibition, aggregation and sending out notifications via methods such as email, on-call notification systems, and chat platforms.

Whether its a major bug, capacity issues, or an outage, users depending on the services expect an immediate response. Having an efficient incident management process is critical in ensuring that the incidents are always communicated to the users (via on-call notification systems) and handled by the team immediately. An on-call notification system is a system/software that provides an automated means of contacting users and communicating pertinent information during an incident. It also has additional on-call scheduling features that can be used to ensure that the right people on the team are available to address a problem during an incident. There are multiple on-call notification systems such as [PagerDuty](https://www.pagerduty.com/), [JIRA](https://www.atlassian.com/software/jira) etc that can be used for incident reporting, but which of these tools are best suitable for reporting the outages/incidents to our users?

## Decision Drivers <!-- optional -->

* Visibility of incident reporting
  * How can the incidents be tracked and reported in an open and transparent manner for our users?
* Compatibility with Prometheus
  * Is the incident reporting tool compatible with Prometheus i.e. can it handle/receive Prometheus alerts?
* Complexity and cost of incident reporting tool
  * How easy/hard is it to manage and operate the incident reporting tool?
  * Is it a free or paid tool?
  * Is it open source?

## Considered Options

* Option 1:
  * Use [PagerDuty](https://www.pagerduty.com/) which is a popular paid on-call management and incident response platform
* Option 2:
  * Use open source tools like:
    * [Cabot](https://github.com/arachnys/cabot) - Python/Djano based monitoring platform
    * [OpenDuty](https://github.com/openduty/openduty) - Incident escalation tool similar to PagerDuty
    * [Dispatch](https://github.com/Netflix/dispatch) - Incident management tool by Netflix
    * [Response](https://github.com/monzo/response) - Django based incident management tool

  which are free, self-hosted infrastructure that provides some of the best features of PagerDuty, Pingdom etc without their cost and complexity
* Option 3:
  * Use [GitHub Alertmanager receiver](https://github.com/m-lab/alertmanager-github-receiver) which is a Prometheus Alertmanager webhook receiver that creates GitHub issues from alerts

## Decision Outcome
Chosen option: **Option 3**, because:
  * The [GitHub alertmanager receiver](https://github.com/m-lab/alertmanager-github-receiver) can easily be configured and operated to function with Prometheus alerts. It automatically creates issues in GitHub repositories for any active alerts being fired, making it visible for any user to track
  * All communication/updates/concerns related to the incident can be easily handled by adding comments in the issues created by the GitHub receiver
  * Unlike Option 1, there is no additional cost involved
  * There is no requirement for using JIRA/Slack for incident tracking, which are the only supported options in some of the tools listed in Option 2 (such as [Dispatch](https://github.com/Netflix/dispatch) and [Response](https://github.com/monzo/response)) In any case that such a requirement surfaces, we can use GitHub bots for different platforms such as [GitHub for Slack](https://slack.github.com/) and [Google Chat](https://support.google.com/chat/answer/9632291?co=GENIE.Platform%3DAndroid&hl=en) to notify us of the issues immediately
  * It is actively being maintained and supported compared to some of the tools in Option 1 (such as [Cabot](https://github.com/arachnys/cabot) and [OpenDuty](https://github.com/openduty/openduty)) which lack community support
