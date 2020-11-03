# Operate First Release Policy

* Status: proposed
* Deciders: durandom
* Date: 2020-Nov-03

Technical Story: As an Open Source project, we want to document the policies and guideline on how we create a new
release.

## Context and Problem Statement

The Operate First project itself consists of many components all having their own release cycles. Op1st users might
decide to updata or customize individual components such as container images used by JupyterHub or ArgoCD.
Nevertheless it is required to create releases of the Operate First project as a whole, so that a stable baseline
is provided to our users.

## Considered Options

* do a monolithic, coordinated release of all components by creating a tag within the relevant repositories
* have a rolling release, and no tags on any repository

## Decision Outcome

Chosen option: we do a monolithic, coordinated release, because it will enable us to have a release at the
project/product level while maintianing freedom of others to update.

### Positive Consequences <!-- optional -->

* users have a clear base line of versions, these versions have been tested with each other and have
  undergone integration testing.
* a release can be referenced from documents, so that operational procedures have a clear relationship with component 
  versions being used
* users can update individual components

### Negative Consequences <!-- optional -->

* A release might not contain the latest versions of components

<!-- markdownlint-disable-file MD013 -->