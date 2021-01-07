# ArgoCD Apps of Apps Structure

## Context and Problem Statement

ArgoCD `Applications` manifests are a [declarative way to manage](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#applications) ArgoCD `Applications` in git. Often times these are manifests that are stored alongside ArgoCD deployment manifests.

This has been fine in the past since we controlled the deployment of ArgoCD and had merge access to the repo where the applications were stored. So if we wanted to onboard a new app, we make a PR with the application manifest and someone on our team would merge it.

But there can be a situation where another team, like cluster-admins or infra, store the ArgoCD deployments in their own repo.

If we applied our current practice, we'd store our app manifests in this external repo. The problem is that we may not have merge access to this repo, and it wouldn't really make much sense for people who manage the infrastructure to also handle PR's that don't pertain directly to cluster management.


## Considered Options

1) Just have All ArgoCD Manifests in one repo and give Operate-First team members access to infra repo so they can review and merge ArgoCD `Applications`.
2) Have separate teams handle Applications for their Projects in their own Repos, in this way tracking Applications is not a concern for Infra/Operate-first, but rather the individual team belonging to an ArgoCD project
3) Have a separate Repo that Operate-First manages, and have a an ArgoCD App of Apps that manages this repo.

## Decision Outcome
Chosen Option `(3)`. Problems with `(1)` have been outlined above. The issues with `(3)` is that there is no way to effectively enforce teams to ensure their App Projects belong to their team's project (this is further described below).

The Proposed Solution is captured by this diagram:

![image](https://user-images.githubusercontent.com/10904967/99705533-d8aac380-2a67-11eb-88e9-b63582271994.png)

The idea here is that all our operate-first/team-1/team-2/.../team-n ArgoCD `Applications` would go in the `opf-argocd-apps` repo. Then we'd have an App of Apps i.e. the `OPF Parent App` that manages all these apps. This way we can add new applications declaratively to ArgoCD without having to make PR's to the `Infra Repo` (e.g. `moc-cnv-sandbox`). Operate-first admins would manage the `opf-argocd-apps` repo. Any other ArgoCD `Applications` that manage cluster resources like `clusterrolebindings` or operator `subscriptions` etc. can remain in the infra repo since that's a concern for cluster admins. We would direct any _user_ that wants to use ArgoCD to manage their apps to add their ArgoCD `Applications` to the `opf-argocd-apps` repo.

### Positive Consequences
- Infrastructure/cluster-admins are not bombarded with PR's for ArgoCD App onboarding
- OperateFirst maintainers can handle the PR's unhindered
- The `opf-argocd-apps` repo can be leveraged by CRC/Quicklab/Other OCP Clusters to quickly setup ArgoCD ODH/Thoth/etc. Applications.

### Negative Consequences
Biggest concern here is that there is no way to automatically enforce that Applications in `opf-argocd-apps` repo _belong_ to the `Operate First` ArgoCD project (see diagram).

_Why is this a problem?_ Because we use ArgoCD projects to restrict what types of resources applications _in that project_ can deploy. For example ArgoCD apps in the `Infra Apps` project in the diagram can deploy: `clusterrolebinding`, `operators`, etc. So while `OPF Parent App` cannot deploy `clusterrolebindings` because it belongs to the `Operate First` ArgoCD project, it could deploy another ArgoCD application that belongs to `Infra apps` and _that ArgoCD app_ could deploy clusterrolebindings.

You can read more about this [issue here](https://github.com/argoproj/argo-cd/issues/3045). The individual there used admission hooks to get around this but I don't think we want to go there just yet. My suggestion is we begin by enforcing this at the PR level, and transition to maybe catching this in CI until there's a proper solution upstream.
