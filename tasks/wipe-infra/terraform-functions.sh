#!/usr/bin/env bash


function delete-infrastructure() {

  local TERRAFORM_SCRIPTS_DIR=$1
  local TERRAFORM_STATE_INPUT_DIR=$2
  local TERRAFORM_STATE_OUTPUT_DIR=$3

  echo "=============================================================================================="
  echo "Executing Terraform Destroy ...."
  echo "=============================================================================================="

  echo "=============================================================================================="
  echo "Executing Terraform Plan ..."
  echo "=============================================================================================="

  terraform init ${TERRAFORM_SCRIPTS_DIR}

  terraform destroy -force \
    -var "subscription_id=${AZURE_SUBSCRIPTION_ID}" \
    -var "client_id=${AZURE_CLIENT_ID}" \
    -var "client_secret=${AZURE_CLIENT_SECRET}" \
    -var "tenant_id=${AZURE_TENANT_ID}" \
    -var "location=${AZURE_REGION}" \
    -var "azure_terraform_vnet_name=dontcare" \
    -var "azure_terraform_vnet_cidr=dontcare" \
    -var "azure_terraform_subnet_infra_name=dontcare" \
    -var "azure_terraform_subnet_infra_cidr=dontcare" \
    -var "azure_terraform_subnet_ert_name=dontcare" \
    -var "azure_terraform_subnet_ert_cidr=dontcare" \
    -var "azure_terraform_subnet_services1_name=dontcare" \
    -var "azure_terraform_subnet_services1_cidr=dontcare" \
    -var "azure_terraform_subnet_dynamic_services_name=dontcare" \
    -var "azure_terraform_subnet_dynamic_services_cidr=dontcare" \
    -var "azure_multi_resgroup_network=dontcare" \
    -var "azure_multi_resgroup_pcf=dontcare" \
    -var "azure_pcf_terraform_storage_account_name=dontcare" \
    -var "azure_pcf_terraform_container_name=dontcare" \
    -state ${TERRAFORM_STATE_INPUT_DIR}/terraform.tfstate \
    -state-out ${TERRAFORM_STATE_OUTPUT_DIR}/terraform.tfstate \
    ${TERRAFORM_SCRIPTS_DIR}

}