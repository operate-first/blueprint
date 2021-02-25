Feature: Increase PVC size in JupyterHub

    Background:
        Given I am a user of MOC-CNV
        * I have access to JupyteHub on MOC-CNV

    Scenario: I use the default PVC

        This scenario is based on [PR243](https://github.com/operate-first/apps/pull/243) pull request.

        Given I have no custom PVC resource for JupyteHub

        When I update the templates/pvc-template.yaml with .metadata.annotations.hub\.jupyter\.org/username = USERNAME
        * I update the templates/pvc-template.yaml with .metadata.name = jupyterhub-nb-URLENCODED_USERNAME-pvc
        * I update the templates/pvc-template.yaml with .spec.resources.requests.storage = DESIRED_SIZE
        * I encrypt the resource with SOPS
        * I add the PVC resource to https://github.com/operate-first/apps/tree/master/odh/overlays/moc/jupyterhub/pvcs/user-USERNAME-pvc.enc.yaml
        * I list the resource at https://github.com/operate-first/apps/tree/master/odh/overlays/moc/jupyterhub/pvcs/secret-generator.yaml
        * I commit the updated file
        * I restart my JupyterHub server

        Then My PVC resource for JupyterHub is updated to DESIRED_SIZE

    Scenario: I already had a custom PVC defined
        Given I have custom PVC resource for JupyteHub

        When I fetch my PVC resource from https://github.com/operate-first/apps/tree/master/odh/overlays/moc/jupyterhub/pvcs/user-USERNAME-pvc.enc.yaml
        * I update the resource via SOPS with .spec.resources.requests.storage = DESIRED_SIZE
        * I commit the updated file
        * I restart my JupyterHub server

        Then My PVC resource for JupyterHub is updated to DESIRED_SIZE
