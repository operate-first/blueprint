# Operate First Community Cloud support process

* Status: deprecated, no-longer-relevant
* Deciders: goern
* Date: 2023-04-25

Technical Story: https://github.com/open-services-group/scrum/issues/4

## Context and Problem Statement

In general, the individual or team that onboards a service often assumes the sole role of operating that service indefinitely. There are various issues associated with this:

* Other members of the SRE team are unable to offer sufficient support for the service, support here can refer to:
  * Operational support (improvements, incidents, fixes, patches, upgrades, etc.)
  * Responding to end user questions via GitHub, Slack, Mailing List pertaining to the service
* Siloed knowledge results in fewer team members being able to perform PR reviews pertaining to the service
* Documentation for the app/service suffers, since now only one person is able to write/understand them
* The one (or few) engineers responsible for maintaining the service have to devote large portions of their engineer time to operate the service, as opposed to building out new features in Operate First

The proposed solution is to apply an SRE On Call procedure in such a way as to alleviate the aforementioned concerns.

## Decision Drivers

* All SRE members in Operate First should have the opportunity to be On Call rotation
* On Call rotation should be able to scale with work and not take up large portions of an engineer's sprint
* On Call person should have sufficient support to perform on call duties
* Not aiming for 24/7 on call coverage
* Need to maintain and improve [documentation][docs] used for on call duties

## Considered Options

The only options to consider are the duration each engineer spends on call, i.e. the frequency of rotations:

1) On call rotations happen every week
2) On call rotations happen every day

## Decision Outcome

Selected option 2) as option 1) could result in a major portion of an engineer's sprint time being spent on call and thus does not scale well.

## Process

### On Call List

Maintain an On Call list of engineers to perform site reliability in the Operate First Cloud. Official list can be maintained [here][on-call-list].

### Schedule

Scheduled rotations happen every working day. When an engineer is on call, they are expected to perform the following on call duties:

### On Call Duties

When on call, perform the following duties:

* Respond to all end-user questions/comments/concerns regarding operations in:
  * Operate First Slack #support, #operations, #general
  * Operate First Mailing list
  * Operate First Operations Repos (i.e, `apps`, `operations`)
* Check status and notifications in the Operate First OCP console
* Be first responder to any issues, incidents, and other operational issues for services managed by SRE team
* Follow documentations to resolve any issues, if no documentation and/or runbook exists, ensure they are updated once the issues are resolved
* Document your topic work in the [on-call-log]
* If the on call engineer does not know how to resolve an issue, and no documentation exist, the onus is on the on call engineer to reach out to the rest of the SRE team for assistance.
* In the event on call engineer is assisted by another engineer, it is still the on call engineer's responsibility to ensure the resolution steps are fully documented in the form of a runbook, for the next on call engineer.
  * This is essential in helping break down knowledge silos.
* Handover (via call or chat)
  * Inform the next on call engineer [on-call-log]
  * Move checkbox
  * If the current on call engineer is the last one on the list, shuffle the list in the [on-call-log] manually

### Off Call Duties

The only requirement for off call engineers is to offer sufficient support for on call engineers when:

* an on call engineer does not know how to resolve an issue
* there are no documents on how to resolve an issue

[on-call-list]: https://github.com/operate-first/apps/blob/master/slack-first/overlays/moc/smaug/config.yaml#L4
[on-call-log]: https://hackmd.io/SHcaWaXLS56Fo2Wr9cRfxg
[docs]: https://www.operate-first.cloud/apps/CONTRIBUTING.html
