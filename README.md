# Provision PCF Infrastructure for a Multi-ResourceGroup Azure Deployment
Based on the current reference architecture for PCF on Azure:
https://docs.pivotal.io/pivotalcf/1-12/refarch/azure/azure_ref_arch.html

### To use the local script version:
#### Requirements:
* Azure cli https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
* Terraform https://www.terraform.io/downloads.html
* jq 1.5 https://stedolan.github.io/jq/download/

#### Steps
1. Log in to Azure
1. Run `azure-prepare-env.sh`
1. Populate `params.yml` from `params.template.yml` and `creds.yml` from `creds.template.yml` (see docs in yml files for guidance)
1. Run `provision-infra-local.sh`

### To use the pipeline version:
#### Requirements:
* Azure cli https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
* Concourse and fly cli http://concourse.ci/downloads.html

#### Steps
1. Log in to Azure
1. Run `azure-prepare-env.sh`
1. Populate `params.yml` from `params.template.yml` and `creds.yml` from `creds.template.yml` (see docs in yml files for guidance)
1. fly the pipeline: `fly -t <env> set-pipeline -p provision-infra -c pipeline.yml -l params.yml -l creds.yml`
1. run the `boostrap-terraform` job in concourse
1. run the `provision-infra` job in concourse

The `azure-prepare-env.sh` script will perform the actions required for a multi resource group
 deployment of PCF according to the documentation listed below:
 
https://docs.pivotal.io/pivotalcf/1-12/customizing/azure-prepare-env.html

https://docs.pivotal.io/pivotalcf/1-12/refarch/azure/azure_ref_arch.html#multi-resgroup-notes

Before you run the `azure-prepare-env.sh` script, login to Azure using 2-factor auth:

```
az cloud set --name AzureCloud
az login
  To sign in, use a web browser to open the page https://aka.ms/devicelogin and enter the code XXXXXXXX to authenticate.
```


