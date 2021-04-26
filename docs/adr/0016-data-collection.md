# Data collection

* Status: accepted
* Deciders: durandom
* Date: 2021-04-26

Technical Story: 

## Context and Problem Statement

The Operate First environments will create a vast amount of operational data from platform systems and user workloads.
We want to publish the data under a license agreement that is similar to an open source license agreement.
We still have to operate in the boundaries of law and therefore cannot publish data that would (break the law)[https://www.youtube.com/watch?v=L397TWLwrUU].

## Decision Drivers 

1. Access to data and the environment should be as open as possible
2. The amount of data collocated should be as broad as possible
3. The data should not go through a cleaning or scrubbing process

## Considered Options

1. Remove all (PII)[https://en.wikipedia.org/wiki/Personal_data] from the data
2. Don't collect any PII
3. Collect PII

## Decision Outcome

Chosen option: _""_, because 

### Positive Consequences <!-- optional -->

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, …]
* …

### Negative Consequences <!-- optional -->

* [e.g., compromising quality attribute, follow-up decisions required, …]
* …

## Pros and Cons of the Options <!-- optional -->

### Remove all PII

* Good, because we can collect the broadest range of data
* Bad, because data generation changes and the scrubbing process has to be maintained
* Bad, because if we fail to clean perfectly we open up for lawsuits 

### Don't collect any PII

Since we can only configure the collection for platform systems and have no direct control over the workloads of users of the environement, the collection for workload logs should be opt-in.

* Good, because we can publish the data without worrying about scrubbing
* Bad, because the configuration of data collection has to be tuned to not collect PII

### Collect PII

* Good, because we can collect the broadest range of data
* Bad, because we have to restrict access to the data

## Links

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* … <!-- numbers of links can vary -->

<!-- markdownlint-disable-file MD013 -->
