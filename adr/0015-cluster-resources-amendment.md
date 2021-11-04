# Declarative Definitions for Cluster Scoped Resources

- Status: accepted
- Deciders: larsks, HumairAK, tumido

Technical Story: [issue-1][1]

## Context and Problem Statement

In [ADR-0009][2] we laid out a directory structure of organizing cluster scoped resources. For the most part this has worked out relatively well. However, one thing that was not factored into this structure were the possibilities of name conflicts. Consider the following scenario:

Suppose we have:
1) A resource of kind Project named example-project with an apiversion: project.openshift.io/v1
2) A resource of kind Project named example-project with an apiversion: config.openshift.io/v1

Note that their API group differs, but everything else is the same. Both of these resources can exist simultaneously on a live cluster. However, these cannot co-exist in our github repo at `operate-first/apps/cluster-scope`, if we are to use the structuring as defined in [ADR-0015][2]. This is because, using the current structure, they would both need to be stored under `operate-first/apps/cluster-scope/base/projects/example-project/project.yaml`.

## Considered Options

The general consensus has been to keep the current structure and amend it to factor in the API Group. Some suggestions are:

1. Use the following schema: `cluster-scope/base/<API_GROUP>-<KIND_PLURAL>/<METADATA_NAME>/<KIND_SINGULAR>.yaml`
  This would factor in the API group as part of the name, and would not require additional nesting of directories
2. Use the following schema: `cluster-scoped-resources/base/<API_GROUP>/<KIND_PLURAL>/<METADATA_NAME>/<KIND_SINGULAR>.yaml`
  This would require additional nesting of directories, but this method has been observed in other tooling (i.e. how must-gather does their organization)

Both solutions will require a `kustomization.yaml` at the base directory so that each resource may be included within an overlay without modifying the default `kustomize build` behavior.

There will also be an exception made for `resourcequotas` in that they will be added alongside `namespace` manifests in the `namespaces` directory. This is because the `resourcequotas` are namespaced resources that are heavily coupled to their respective namespace.

## Preferred option

We will opt for the second option. The first option may introduce yet another custom way to organize manifests, while the second one seems like a tried and tested method. In the case of the core API group (i.e. where resources like [namespaces][3] belong), they will be stored at the `cluster-scope/base` path (e.g. `cluster/scope/base/namespaces/...`).

To better illustrate this, an example of how this layout would look like can be found below:

```text
.
├── config.openshift.io
│   ├── oauths
│   │   └── cluster
│   │       ├── kustomization.yaml
│   │       └── oauth.yaml
│   └── projects
│       └── cluster
│           ├── kustomization.yaml
│           └── project.yaml
[...]
```

Here the two resources included are of kind `oauths` and `projects` (their plural forms), they belong to the API group `config.openshift.io` and their singular name is used as the base resource filename.

Each resource's manifest is also accompanied by a `kustomization.yaml` file. As an example the file `config.openshift.io/oauths/cluster/kustomization.yaml` would look like:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- oauth.yaml
```

An example of how this resource may be included in an overlay:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- ../../../base/config.openshift.io/oauths/cluster
```

Where the `kustomization.yaml` is stored in `cluster-scope/overlays/$ENVIRONMENT/$CLUSTER/kustomization.yaml`.

[1]: https://github.com/operate-first/blueprint/blob/main/docs/adr/0009-cluster-resources.md
[2]: https://github.com/operate-first/blueprint/blob/main/docs/adr/0009-cluster-resources.md
[3]: https://docs.openshift.com/container-platform/4.6/rest_api/metadata_apis/namespace-core-v1.html#namespace-core-v1
