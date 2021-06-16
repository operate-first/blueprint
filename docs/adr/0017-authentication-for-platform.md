# Authentication for all platform environments

* Status: accepted
* Deciders: durandom
* Date: 2021-04-26

Technical Story:

## Context and Problem Statement

The Operate First environments will span multiple data centers and multiple regions.
A central authentication system helps identfiying users and system operators without maintaining seperate user registries.
This ADR is related to platform systems, such as OpenShift, ArgoCD or ACM - for application workloads refer to [0010-common-auth-for-applications](0010-common-auth-for-applications.md).
Authentication is also essential for auditing. User management of the applications should be unified so the same user can access all the systems with a single set of credentials.
The username should be unique, but also utilized across systems.
The accepted solution should provide [SSO](https://en.wikipedia.org/wiki/Single_sign-on), so the user can cary over the identity across different systems.

## Decision Drivers

1. For the same user a single user identity is provided to all applications.
2. All users are able to authenticate using the same credentials
3. Identity provider is responsible for user privacy
4. Ease of acquiring an account
5. Publishing data in legal boundaries without worrying about [PII](https://en.wikipedia.org/wiki/Personal_data)

## Considered Options

1. University Authentication
2. Google
3. GitHub

## Decision Outcome

Chosen option: _"3. GitHub"_, because most users already have a GitHub account.

### Positive Consequences

* The only link to direct user personal data is the GitHub account name
* Users have to take care of setting privacy options in GitHub
* Gitops actions, such as commits, are directly attributable to system accounts

### Negative Consequences

* Reaching out to users via mail is harder, because we don't maintain a directory of mail addresses

## Pros and Cons of the Options

### University Authentication

* Good, because we also target university research and students usually have a university login
* Bad, because universities have a strict privacy setup and must not leak any student data

### Google

* Good, because we have email addresses to reach out to users
* Bad, because we store email addresses in logs

### GitHub

* Good, because users already have a GitHub account - our platform for gitops
* Good, because users take care of setting privacy
* Bad, because we don't have email addresses to reach out to users

## Links

* Related ADR: [0010-common-auth-for-applications](0010-common-auth-for-applications.md)
* [GitHub Privacy Statement](https://docs.github.com/en/github/site-policy/github-privacy-statement)
