# Repositories Supporting Multiple Environment Deployments

## Context and Problem Statement

With the introduction of the [app of apps](0004-argocd-apps-of-apps-structure.md) ADR we now have a way to separate application
management with infrastructure management. The [argocd-apps](https://github.com/operate-first/argocd-apps) repo now serves
as a central point of managing ArgoCD applications (and in turn our manifests in general) for the operate-first initiative.

As per the [App of Apps ADR doc](0004-argocd-apps-of-apps-structure.md) we would like both the `argocd-apps` repo and
the repos that each application in the `argocd-apps` target to be able to be deployed in multiple environments. Environments
here can mean multiple namespaces on the same cluster, or different clusters all together.

For example, I should be able to create a single `ArgoCD` app, that points to the `argocd-apps` repo and have it create
all the ArgoCD applications that live in this repo, regardless of environment. This is fine if your manifest
repo only has one set of manifest deployment that can be deployed in any environment without needing additional tuning.
This is rarely the case however, and often times you'll have a `common` set of manifests, and then your target environments
will add additional configurations on top of this. This results in multiple subdirectories with different `paths` for
each target environment. This essentially means we can only use `argocd-apps` repo for a specific environment only.


## Considered Options
1) Keep argocd-apps repo environment specific, and use multiple repos as "app-of-apps" repos for each environment
2) Use Kustomize overlays/bases for argocd-apps repo and have different overlays that patch the `path` for each environment

## Decision Outcome
Choose 2) as it accomplishes much of 1) without needing yet more repos and adding bloat to the organization.

The `argocd-apps` repo would follow the following structure:

The example makes these assumptions:
- There are 2 target environments: `environment_1` and `environment_2`
- There are 2 projects (corresponding to teams) `project_1` and `project_2`
- Each project has a number of different ArgoCD applications, labelled `app_#.yaml`, note that `project_1/app_1.yaml` does not need to be the same as `project_2/app_1.yaml`

```
├── base
│   ├── project_1
│   │   ├── app_1.yaml
│   │   └── app_2.yaml
│   └── project_2
│       ├── app_1.yaml
│       └── app_2.yaml
└── overlays
    ├── environment_1
    │   ├── project_1
    │   │   └── patch_app_2.yaml
    │   └── project_2
    │       ├── app_3.yaml
    │       └── patch_app_1.yaml
    │       └── patch_app_2.yaml
    └── environment_2
        ├── project_1
        │   └── patch_app_1.yaml
        └── project_2
            └── .
```

In this sort of a structuring, we can now accommodate various different use cases. The `overlays` folder allows you to update
the `path` structure (or anything really) so that it points a different path in a target repository. This is useful if your
target repository follows this sort of a structure:

```
.
├──base
├──overlays
│   ├── environment_1
│   └── environment_2
```


You could also include an ArgoCD application that *only* deploys to a single environment.

With this method any ArgoCD instance can create their own Application and point to either `environment_1` or
`environment_2` overlay and deploy all the ArgoCD applications (and in turn the manifests they point to).

The following explains the example structure and what it's doing in more detail:
Note that all applications in `base` are auto included in `overlays`.

On `environment_1`
- `project_1` auto picks up `app_1.yaml` in `base` but updates `app_2.yaml` to point to a different path.
- `project_2` updates both `app_1.yaml` and `app_2.yaml` but also includes `app_3.yaml` because it only wants to deploy
`app_3` in `environment_1`, if `project_2` includes `app_3` in `base` then it would be automatically picked up by `environment_2`.

On `environment_2`
- `project_1` auto picks up `app_2.yaml` in `base` but updates `app_1.yaml` to point to a different path.
- `project_2` deploys the `base` apps in this environment without any changes.

### Positive Consequences
- Lots of flexibility in tuning configurations for target environments and accommodating different usecases

### Negative Consequences
- Potentially added complexity in onboarding apps
