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

export AZURE_MULTI_RESGROUP_NETWORK=${azure_multi_resgroup_network}
export AZURE_MULTI_RESGROUP_PCF=${azure_multi_resgroup_pcf}
export AZURE_TERRAFORM_VNET_NAME=${azure_terraform_vnet_name}
export AZURE_TERRAFORM_VNET_CIDR=${azure_terraform_vnet_cidr}
export AZURE_TERRAFORM_SUBNET_INFRA_NAME=${azure_terraform_subnet_infra_name}
export AZURE_TERRAFORM_SUBNET_INFRA_CIDR=${azure_terraform_subnet_infra_cidr}
export AZURE_TERRAFORM_SUBNET_ERT_NAME=${azure_terraform_subnet_ert_name}
export AZURE_TERRAFORM_SUBNET_ERT_CIDR=${azure_terraform_subnet_ert_cidr}
export AZURE_TERRAFORM_SUBNET_SERVICES1_NAME=${azure_terraform_subnet_services1_name}
export AZURE_TERRAFORM_SUBNET_SERVICES1_CIDR=${azure_terraform_subnet_services1_cidr}
export AZURE_TERRAFORM_SUBNET_DYNAMIC_SERVICES_NAME=${azure_terraform_subnet_dynamic_services_name}
export AZURE_TERRAFORM_SUBNET_DYNAMIC_SERVICES_CIDR=${azure_terraform_subnet_dynamic_services_cidr}
export AZURE_PCF_TERRAFORM_STORAGE_ACCOUNT_NAME=${azure_pcf_terraform_storage_account_name}
export AZURE_PCF_TERRAFORM_CONTAINER_NAME=${azure_pcf_terraform_container_name}

export PCF_ERT_DOMAIN=${pcf_ert_domain}
export PRIV_IP_MYSQL_LB=${priv_ip_mysql_lb}

TERRAFORM_SCRIPTS_DIR="tasks/provision-infra/terraform"
TERRAFORM_STATE_INPUT_DIR="."
TERRAFORM_STATE_OUTPUT_DIR="."

run_terraform ${TERRAFORM_SCRIPTS_DIR} ${TERRAFORM_STATE_INPUT_DIR} ${TERRAFORM_STATE_OUTPUT_DIR}
