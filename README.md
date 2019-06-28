# Concourse pipeline for stembuild
A collection to tasks that implement stembuild cli.

## About
This is a [Concourse](https://concourse-ci.org) pipeline with tasks to create a Windows stemcell for Cloud Foundry, using the [stembuild cli](https://github.com/cloudfoundry-incubator/stembuild/). The stemcell can be used with Pivotal Application Service for Windows (PASW) and the windows cluster feature of Pivotal Container Service (PKS) as well.

### Pre-reqs
The Concourse worker that runs these tasks needs to have access to `https://github.com` and `https://network.pivotal.io`. If your workers aren't allowed public access, you can modify the pipeline to "feed" the assets that are normally downloaded.

The stembuild cli expects the VM to be in a specific state. To get there, follow the documentation for [creating vsphere stemcell with stembuild](https://docs.pivotal.io/pivotalcf/2-6/windows/create-vsphere-stemcell-automatically.html) through Step 3. Once you have the cloned VM and it is powered on, use this pipeline to convert the VM to a stemcell.

## Getting Started
1. You'll need 2 files from this repo, `pipeline.yml` and `vars.yml`. You can either clone the repo `git clone https://github.com/pivotal/stembuild-concourse` or just grab the raw content.

1. The pipeline has options of where things can be stored. Specifically S3 compatible, Google Cloud, or Azure store. The default is S3 compatible. If you would like to use a different store just comment/uncomment things in `pipeline.yml`.

1. The `vars.yml` file will feed variables to the pipeline. Fill in the values appropriatly.
  #### Vcenter certificate
  The CA certs for vcenter are not optional. You can retrieve the cert by following [this vmware doc](https://pubs.vmware.com/vsphere-6-5/index.jsp?topic=%2Fcom.vmware.vcli.getstart.doc%2FGUID-9AF8E0A7-1A64-4839-AB97-2F18D8ECB9FE.html). 

1. Using the [fly cli](https://concourse-ci.org/fly.html), [login](https://concourse-ci.org/fly.html#fly-login) to concourse, and [set](https://concourse-ci.org/setting-pipelines.html#fly-set-pipeline) the pipeline with variables filled.

  #### Powershell Set Pipeline
  ```
  fly -t <MY-TARGET> set-pipeline `
    --pipeline create-windows-stemcell `
    --config .\pipeline.yml `
    --load-vars-from .\vars.yml
  ```

  #### Bash Set Pipeline
  ```bash
  fly -t <MY-TARGET> set-pipeline \
    --pipeline create-windows-stemcell \
    --config ./pipeline.yml \
    --load-vars-from ./vars.yml
  ```

1. Looking at the [prerequisites](https://docs.pivotal.io/pivotalcf/2-6/windows/create-vsphere-stemcell-automatically.html#prerequisites) for running stembuild, you'll notice that LGPO needs to be downloaded and put in the same working folder. The pipeline has provisions for holding the zip using either S3 compatible, Google Cloud, or Azure store. Place the downloaded zip in the chosen store and the pipeline will manage the rest.

1. Start the construct task to see the magic happen.

1. Once both tasks have successfully run, the stemcell file will be uploaded to the chosen `stemcell-store` store. The pipeline has provisions for storing the stemcell using either S3 compatible, Google Cloud, or Azure store. You can use this store to trigger another Concourse pipeline that deploys to Cloud Foundry, or manually upload the stemcell into the library and deploy.

## Keeping Stemcells Patched
Every month Microsoft releases patches (updates) for it's operating systems. Known as patch Tuesday. The stembuild team tests the cli against these new patches each month and releases a new *minor* version of the tool.

As a best practice, try to follow this pattern:
1. Update the base stemcell VM on patch tuesday.
1. Once all updates are finished, shutdown and Clone the base VM. Name the clone to reflect the stembuild version, ie: 2019.3.41.
1. When the new minor version of the cli is released, start* this pipeline to create the stemcell.

Details about monthly stemcell upgrade can be found in the [creating vsphere stemcell with stembuild](https://docs.pivotal.io/pivotalcf/2-6/windows/create-vsphere-stemcell-automatically.html#upgrade-stemcell) documentation.

*If you would like to make the pipeline run automatically when a new release it posted, add `trigger: true` to `get: stembuild-release` in the construct job.
