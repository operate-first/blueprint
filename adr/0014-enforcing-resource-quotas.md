# Enforcing of Resource Quotas

Technical Story: [1][1], [2][2]

## Context and Problem Statement
Currently clusters being managed by Operate-First are not enforcing quotas on compute and storage resources. This means that anyone can use their `namespace` to use hog as many resources as they wish. We should use Kubernetes' [ResourceQuotas][3] to address this concern. Decisions for declaring quotas for resource `requests` and `limits` should be guided by monitoring current trends and usage via available dashboards. We will also need to add default [LimitRanges][4] so current workloads are not prevented from creating resources.

## Considered Options

The only option is to use [ResourceQuotas][3], what is subject to debate is how we organize/advertise these quotas in git.

### 1. Tiered & Custom Resource quotas

We identify a tier of standard `ResourceQuotas` that we distribute to each namespace. We will adhere to this tiered system as much as possible, but acknowledge the need for custom quotas, and allow for such exceptions on a need basis. `ResourceQuotas` can be included as `Kustomize` components

### Pros:
- User friendly. It's a lot easier to tell a new-comer to pick from a set of options then to specify specific requirements.
- Consistency. Tiers ensure that all new-comers are treated the same and any custom request is treated more carefully.
- Easy to propagate changes. For example, should we decide to update all `small` tier `ResourceQuotas`, we need only update one manifest in git.

### Cons:
- May result in waste of compute resources since we're trying to fit various use cases into a small set of tiered options.
- Could get convoluted if custom `ResourceQuotas` manifests start drastically outnumbering the standard options.

### 2. Only Resource quotas

No tier option, every namespace has a resource quota customized for their needs.

### Pros:
- Less likely to waste resources if tuned correctly for each namespace.
- There's no confusion over when to use a tiered option or custom (since there's only custom option)

### Cons:
- Adds additional overhead to the on-boarding process, as now we require new-comers to assess their exact resource needs to fully benefit from this option.
- More resources to track and manage.
- Each admin can have their own view of what exact quota is necessary for a given project and this can lead to uncertainty and different quota based on who is serving the onboarding ticket.

## Preferred option
Option 1 is preferred, due to the flexibility it offers. If it comes to the point where everyone is opting for `custom` quotas anyway, we can simply abandon the tier option.

## Outcomes

[1]: https://github.com/operate-first/apps/issues/438
[2]: https://github.com/operate-first/apps/pull/439
[3]: https://kubernetes.io/docs/concepts/policy/resource-quotas/
[4]: https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/
