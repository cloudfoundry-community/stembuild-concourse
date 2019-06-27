# stembuild-concourse
This is a [Concourse](https://concourse-ci.org) pipeline with tasks to create a Windows stemcell for Cloud Foundry (and Pivotal Application Service). The tasks use the stembuild cli.

## Note
The stemcell that is output from this pipeline can be used with Pivotal Application Service for Windows (PASW) and the windows cluster feature of Pivotal Container Service (PKS).

The Concourse worker that runs these tasks needs to have access to `https://github.com` and `https://network.pivotal.io`. If your workers aren't allowed public access, you can madify the pipeline to "feed" the assets that are normally downloaded.

## Keeping Stemcells Patched
Every month Microsoft releases patches (updates) for it's operating systems. Known as patch Tuesday. The stembuild team tests the cli against these new patches every month and releases a new minor version of the tool. Issues and found and fixed before releasing. Updating the base VM after patch tuesday and cloning it is a best practice. Then let this pipeline fire when a new minor version of the cli is release to create the patched stemcell. This trigger is already built in to the pipeline.

Details about monthly stemcell upgrade can be found in the [creating vsphere stemcell with stembuild](https://docs.pivotal.io/pivotalcf/2-6/windows/create-vsphere-stemcell-automatically.html#upgrade-stemcell) documentation. 

## Getting Started
The stembuild cli expects the VM to be in a specific state. To get there, follow the documentation for [creating vsphere stemcell with stembuild](https://docs.pivotal.io/pivotalcf/2-6/windows/create-vsphere-stemcell-automatically.html) through Step 3. Once you have the cloned VM and it is powered on, use this pipeline to convert the VM to a stemcell.

To set up the pipeline in Concourse...

1. Clone this repo `git clone https://github.com/pivotal/stembuild-concourse`

1. The pipeline has options of where things can be stored. Specifically S3 compatible, Google Cloud, or Azure store. The default is S3 compatible. If you would like to use a different store just comment/uncomment things in pipeline.yml

1. The vars.yml file will feed variables to the pipeline. Fill in the values appropriatly.

1. Using the [fly cli](https://concourse-ci.org/fly.html), [login](https://concourse-ci.org/fly.html#fly-login) to concourse, and [set](https://concourse-ci.org/setting-pipelines.html#fly-set-pipeline) the pipeline with variables filled.

  ### Powershell Set Pipeline
  ```
  fly -t <MY-TARGET> set-pipeline `
    --pipeline create-windows-stemcell `
    --config .\pipeline.yml `
    --load-vars-from .\vars.yml
  ```

  ### Bash Set Pipeline
  ```bash
  fly -t <MY-TARGET> set-pipeline \
    --pipeline create-windows-stemcell \
    --config ./pipeline.yml \
    --load-vars-from ./vars.yml
  ```

1. [TODO] Copy in LGPO

1. [TODO] Set up git repo with tasks

1. You're ready to see the magic happen!
