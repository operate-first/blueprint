```gherkin
Feature: Add new ImageStream to JupyterHub Spawner UI
    Given I am a user of MOC-CNV
    And I have access to JupyteHub on MOC-CNV
    And there exists an image quay.io/thoth-station/s2i-minimal-notebook
    When I update templates/imagestream-template.yaml with:
        metadata.annotations = {
            opendatahub.io/notebook-image-url: "https://github.com/thoth-station/s2i-minimal-notebook"
            opendatahub.io/notebook-image-name: "Test minimal notebook Image"
            opendatahub.io/notebook-image-desc: "Jupyter notebook image with minimal dependency set to start experimenting with Jupyter environment."

        }
        metadata.name = test-s2i-minimal-notebook
        spec.tags[0].annotations = {
            openshift.io/imported-from: quay.io/thoth-station/s2i-minimal-notebook
        }
        spec.tags[0].from.name = quay.io/thoth-station/s2i-minimal-notebook:v0.0.4
        spec.tags[0].name = v0.0.4
    And I add imagestream-template.yaml to https://github.com/operate-first/apps/tree/master/odh/base/jupyterhub/notebook-images
    And I add imagestream-template.yaml to https://github.com/operate-first/apps/blob/master/odh/base/jupyterhub/notebook-images/kustomization.yaml
    Then the image test-s2i-minimal-notebook should appear in JupyterHub Spawner UI
```
