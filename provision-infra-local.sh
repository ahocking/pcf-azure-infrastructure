#!/usr/bin/env bash

set -eEu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source tasks/provision-infra/terraform-functions.sh
source scripts/parse_yaml.sh

# Pull variables from pipline yaml files
# TODO check for file exists
eval $(parse_yaml params.yml "")
# TODO check for file exists
eval $(parse_yaml creds.yml "")


export AZURE_SUBSCRIPTION_ID=${azure_subscription_id}
export AZURE_TENANT_ID=${azure_tenant_id}
export AZURE_CLIENT_ID=${azure_network_service_principal_client_id}
export AZURE_CLIENT_SECRET=${azure_network_service_principal_client_secret}
export AZURE_REGION=${azure_region}
export AZURE_TERRAFORM_PREFIX=${azure_terraform_prefix}

export AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_SECRET=${azure_pcf_service_principal_client_secret}

#${DIR}/tasks/provision-infra/create-service-principal.sh


TERRAFORM_SCRIPTS_DIR="tasks/provision-infra/terraform"
TERRAFORM_STATE_INPUT_DIR="."
TERRAFORM_STATE_OUTPUT_DIR="."

#run_terraform ${TERRAFORM_SCRIPTS_DIR} ${TERRAFORM_STATE_INPUT_DIR} ${TERRAFORM_STATE_OUTPUT_DIR}
