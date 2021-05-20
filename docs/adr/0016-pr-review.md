# Reviewing Pull Requests

* Status: accepted
* Deciders: tumido, HumairAK, lars, goern, 4n4nd
* Date: 2021-05-20

Technical Story: [#93](https://github.com/operate-first/blueprint/issues/93)

## Context and Problem Statement

Each community has its own `contributing.md` file which outlines how are users expected to contribute to the community. That guide for contributions should also clearly state what will happen once a PR is submitted and how reviews are performed.


## Considered Options

* Using inherited processes from AI-CoE - Prow
* Building upon Prow and modifying and evolving them to operations needs

## Decision Outcome

Chosen option: "Building upon Prow and modifying and evolving them to operations needs"

### Prerequisites

We use Prow to automate review process. That means we use following setup:

1. Each repository contains an `OWNERS` file:
   1. There is always one `OWNERS` file in a repository root folder
   2. If needed, additional `OWNERS` files can be created within nested folders. This file takes precedence for all resources within this folder.
2. `OWNERS` file contains several entries:
   1. `approvers` is a list of GitHub users that are allowed to use the `/approve` chat-ops command. Role of approvers is to gate PRs - they verify that changes in PRs respect our architectural decisions and are in line with the heading of the project. See [upstream docs][4] for better understanding of this role.
   2. `reviewers` is a list of GitHub users that are allowed to use the `/lgtm` chat-ops command. Their role is to ensure changes in PRs are implemented properly and meet our coding standards. See [upstream docs][4] for details.

### Process

1. A PR is submited
2. Prow (represented by a Sesheta bot-account) will pick a selection of reviewers from corresponding `OWNERS` file (based on modified files in the PR).
3. Reviewers assess the code for general code quality, correctness, sane software engineering, and style. They either provide feedback or respond with `/lgtm` chat-ops command.
   1. Once a `/lgtm` command is sent, Prow (Sesheta) will add a `lgtm` label to the PR. This label will get removed if there are any new pushes to the PR.
   2. Additionally Prow will ask users to assign a specific `approver` to the PR if there's no assignment yet.
4. Approvers evaluate architectural aspects of the PR and holistic acceptance criteria, including dependencies with other features, forwards/backwards compatibility, API and flag definitions. They either provide feedback or respond with `/approve` chat-ops command.
   1. Once an `/approve` command is sent, Prow (Sesheta) will add an `approve` label to the PR. This label stays after subsequent pushes to the PR.
5. If a PR is large in nature or introduces a breaking change we exercise an **informal rule**:
   1. PR is put on hold via `/hold`.
   2. We wait for a second reviewer to come by and approve it via `/lgtm` (2 different people have commented with `/lgtm`).
   3. PR is held in review for at least a day to give more people chance to look at it.
6. Prow (Sesheta) waits for conditions to be met to make PR eligible for merge. Required conditions (See [here][2] for details):
   1. Required CI checks need to finish and pass. Which CI checks are required is configured per repository.
   2. Both `approve` and `lgtm` labels are present.
7. Prow merges the pull request.

Additional chat-ops commands to help with PR review process are:

* `/retest` - re-run failed CI checks
* `/cc @username` - request a review from an user
* `/close` - close pull request
* `/label` - add a label to the PR
* `/ok-to-test` - if a PR was submitted by somebody who is not a member of the operate-first GitHub organization, Prow doesn't start CI until this command is used by a member
* `/hold` - prevent PR from being merged

## Links

* [Command help][0]
* [Merge requirements for organizations managed by our Prow][1]
* [Enabled Prow plugins][2]
* [Upstream docs for OWNERS file][3]
* [Upstream review process description][4]

[0]: https://prow.operate-first.cloud/command-help
[1]: https://prow.operate-first.cloud/tide
[2]: https://prow.operate-first.cloud/plugins
[3]: https://www.kubernetes.dev/docs/guide/owners/#owners
[4]: https://www.kubernetes.dev/docs/guide/owners/#code-review-using-owners-files
