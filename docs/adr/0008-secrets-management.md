# GitOPS and Secrets Management

* Status: accepted
* Deciders: HumairAK, hemajv, 4n4nd, anishasthana, tumido, mhild

Technical Story: [issue-1](https://github.com/open-infrastructure-labs/ops-issues/issues/3), [issue-2](https://github.com/operate-first/apps/issues/77)

## Context and Problem Statement

Following a GitOps operating model requires us to describe our running system in Git. Since we operate on OpenShift/K8s, we can do this easily by specifying our entire system via `yaml` manifests and storing them in GitHub. Things get a bit more complicated when trying to reconcile where to store confidential information like `secrets`. We use the word `secrets` here a bit loosely to capture all confidential manifests (e.g. k8s secrets, routes with certs, etc.).

Obviously we cannot store our `secrets` in Git in plaintext, we would like to store them in some encrypted fashion, ideally alongside the other system manifests. Other considerations are as follows:

- There should be freedom to store/organize the `secrets` in any repo, path, and location.
- Encrypted manifests should be compatible with Kustomize.
- Ideally only the specific portions within manifests that are confidential will be encrypted (e.g. specific fields).
- ArgoCD should be able to decrypt these secrets and thus deploy them.
- Other teams can easily encrypt their manifests whilst maintaining ease of consumption by ArgoCD.
- Decryption capabilities are limited to code-owners, operate-first admins, and ArgoCD.

## Considered Options

There exist many different solutions to tackle GitOps with secret management. ArgoCD has a list of recommended tools one can leverage, you may find it [here](https://argoproj.github.io/argo-cd/operator-manual/secret-management/). We considered the following tools:

1) [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) - An operator that can decrypt a secret from a custom resource, this resource is stored in Git.
2) [Hashicorp Vault](https://www.vaultproject.io/) - A server with a backing storage where secrets are stored.
3) [KSOPS](https://github.com/viaduct-ai/kustomize-sops#argo-cd-integration) - A Kustomize plugin that uses [sops](https://github.com/mozilla/sops) to encrypt, the plugin itself adds a decryption generator step to the Kustomize build.
4) Store secrets in a private/internal repo.

## Decision Outcome
Chosen Option `(3)`. Reasons are summarized as follows:

- `Sealed Secrets` only allow you to encrypt k8s `secrets`
- `Hashicorp Vault` a bit too heavy duty for our use case, steep learning curve. Secrets are also stored in a backend storage and not in Git
- We would like to avoid storing manifests in private/internal repos. This is to stay in line with keeping our system's desired state as public as possible.

By using KSOPS we can encrypt specific portions of a manifest that are confidential whilst keeping the rest of the non-confidential information visible. Encrypted manifests can be stored in whichever location as needed. By using an ArgoCD image that has KSOPS installed, we can have ArgoCD also decrypt these manifests.

SOPS allows you to use various methods to encrypt your manifests, we opt to use GPG as it's free to generate and use (other methods include using AWS KMS, GCP KMS, and Azure Key Vault).

We will create a GPG key that we will use to encrypt all our manifests in Git. The secret key will be made available to ArgoCD and other operate-first admins. We offer the public key to other teams should they wish to encrypt their contents and store them in Git. Doing so will allow ArgoCD to decrypt and deploy their manifests. This means that other teams will be able to encrypt, but not decrypt, their manifests in Git. To get around this, SOPS allows you to encrypt the same files with multiple keys, allowing teams to encrypt a file using our Operate-First public key (where they do not have access to the private key) and their own key (for which they also have the private key). This will allow ArgoCD to decrypt their manifests, whilst also allowing teams to retain the ability to decrypt their manifests.

### Positive Consequences
- Can store secrets in Git alongside other manifests.
- Compatible with Kustomize.
- SOPS allows us to configure specific confidential fields we want encrypted inside manifests, while keeping other information public.
- ArgoCD can decrypt manifests.
- GPG key access, and SOPS configurations allow us to control who has encryption/decryption capabilities.

### Negative Consequences
- By using GPG the cost of changing a key becomes expensive. For example, if a key is compromised, we need to update all `.sops.yaml` wherever that key is used and re-encrypt.
- KSOPS is a Kustomize plugin, and thus requires the `--enable_alpha_plugins`, this gives the impression that Kustomize plugins may be deprecated. However based on [this issue](https://github.com/kubernetes-sigs/kustomize/issues/1504), it seems the real purpose is to just `warn the user against accidentally running 3rd party plugins.`
- ArgoCD requires a custom image that includes the KSOPS tooling.
