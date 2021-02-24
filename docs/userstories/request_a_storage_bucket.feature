Feature: Request a CEPH bucket for my ML project

    Background:
        Given I am a user of MOC-CNV
	* I have access to JupyteHub on MOC-CNV

    Scenario: I add a bucket request to my project

	This scenario is based on [PR111](https://github.com/aicoe-aiops/ocp-ci-analysis/pull/111) pull request.

	When I update manifests/kustomization.yaml with 
	```
	resources:
	- buckets.yaml
	```
	* I update manifests/buckets.yaml with
	```
	apiVersion: objectbucket.io/v1alpha1
	kind: ObjectBucketClaim
	metadata:
	  name: black-flake
	spec:
	  bucketName: black-flake
	  storageClassName: ocs-storagecluster-ceph-rgw
	  additionalConfig:
	    maxObjects: "1000"
	    maxSize: "4G"

	```

	Then a secret will be created for me named `black-flame` with credentials for accessing a new bucket.

