Feature: As a user of JupyterHub I want to increase size of a PVC in JupyterHub

    Background:
        Given I am a user of MOC-ZERO
        * I have access to JupyteHub on MOC-ZERO

    Scenario: Request PVC size to be updated/enlarged

        This scenario is based on [Issue 243](https://github.com/operate-first/support/issues/86).

        When I open a an issue at [operate-first/support](https://github.com/operate-first/support) using https://github.com/operate-first/support/issues/new?assignees=&labels=user-support&template=pvc_request.md&title= template
        * The issue is resolved by the Ops team

        Then My PVC resource for JupyterHub is updated to DESIRED_SIZE
