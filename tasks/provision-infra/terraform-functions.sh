#!/usr/bin/env bash

function run_terraform() {
    local TERRAFORM_SCRIPTS_DIR=$1
    local TERRAFORM_STATE_INPUT_DIR=$2
    local TERRAFORM_STATE_OUTPUT_DIR=$3

    echo "=============================================================================================="
    echo "Executing Terraform Plan ..."
    echo "=============================================================================================="

    terraform init ${TERRAFORM_SCRIPTS_DIR}

    terraform plan \
      -var "subscription_id=${AZURE_SUBSCRIPTION_ID}" \
      -var "client_id=${AZURE_CLIENT_ID}" \
      -var "client_secret=${AZURE_CLIENT_SECRET}" \
      -var "tenant_id=${AZURE_TENANT_ID}" \
      -var "location=${AZURE_REGION}" \
      -var "azure_terraform_vnet_name=${AZURE_TERRAFORM_VNET_NAME}" \
      -var "azure_terraform_vnet_cidr=${AZURE_TERRAFORM_VNET_CIDR}" \
      -var "azure_terraform_subnet_infra_name=${AZURE_TERRAFORM_SUBNET_INFRA_NAME}" \
      -var "azure_terraform_subnet_infra_cidr=${AZURE_TERRAFORM_SUBNET_INFRA_CIDR}" \
      -var "azure_terraform_subnet_ert_name=${AZURE_TERRAFORM_SUBNET_ERT_NAME}" \
      -var "azure_terraform_subnet_ert_cidr=${AZURE_TERRAFORM_SUBNET_ERT_CIDR}" \
      -var "azure_terraform_subnet_services1_name=${AZURE_TERRAFORM_SUBNET_SERVICES1_NAME}" \
      -var "azure_terraform_subnet_services1_cidr=${AZURE_TERRAFORM_SUBNET_SERVICES1_CIDR}" \
      -var "azure_terraform_subnet_dynamic_services_name=${AZURE_TERRAFORM_SUBNET_DYNAMIC_SERVICES_NAME}" \
      -var "azure_terraform_subnet_dynamic_services_cidr=${AZURE_TERRAFORM_SUBNET_DYNAMIC_SERVICES_CIDR}" \
      -var "azure_multi_resgroup_network=${AZURE_MULTI_RESGROUP_NETWORK}" \
      -var "azure_multi_resgroup_pcf=${AZURE_MULTI_RESGROUP_PCF}" \
      -var "azure_pcf_terraform_storage_account_name=${AZURE_PCF_TERRAFORM_STORAGE_ACCOUNT_NAME}" \
      -var "azure_pcf_terraform_container_name=${AZURE_PCF_TERRAFORM_CONTAINER_NAME}" \
      -out terraform.tfplan \
      -state ${TERRAFORM_STATE_INPUT_DIR}/terraform.tfstate \
      ${TERRAFORM_SCRIPTS_DIR}

    echo "=============================================================================================="
    echo "Executing Terraform Apply ..."
    echo "=============================================================================================="

    terraform apply \
      -state-out ${TERRAFORM_STATE_OUTPUT_DIR}/terraform.tfstate \
      terraform.tfplan
}