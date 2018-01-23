#!/usr/bin/env bash

set -e

az login --service-principal -u ${AZURE_CLIENT_ID} -p ${AZURE_CLIENT_SECRET} --tenant ${AZURE_TENANT_ID}
az account set --subscription ${AZURE_SUBSCRIPTION_ID}

echo "=============================================================================================="
echo "Executing Terraform Plan ..."
echo "=============================================================================================="

terraform init "terraform"

terraform plan \
  -var "subscription_id=${AZURE_SUBSCRIPTION_ID}" \
  -var "client_id=${AZURE_CLIENT_ID}" \
  -var "client_secret=${AZURE_CLIENT_SECRET}" \
  -var "tenant_id=${AZURE_TENANT_ID}" \
  -var "location=${AZURE_REGION}" \
  -var "env_name=${AZURE_TERRAFORM_PREFIX}" \
  -var "env_short_name=${ENV_SHORT_NAME}" \
  -var "azure_terraform_vnet_cidr=${AZURE_TERRAFORM_VNET_CIDR}" \
  -var "azure_terraform_subnet_infra_cidr=${AZURE_TERRAFORM_SUBNET_INFRA_CIDR}" \
  -var "azure_terraform_subnet_ert_cidr=${AZURE_TERRAFORM_SUBNET_ERT_CIDR}" \
  -var "azure_terraform_subnet_services1_cidr=${AZURE_TERRAFORM_SUBNET_SERVICES1_CIDR}" \
  -var "azure_terraform_subnet_dynamic_services_cidr=${AZURE_TERRAFORM_SUBNET_DYNAMIC_SERVICES_CIDR}" \
  -var "ert_subnet_id=${ERT_SUBNET}" \
  -var "pcf_ert_domain=${PCF_ERT_DOMAIN}" \
  -var "ops_manager_image_uri=${PCF_OPSMAN_IMAGE_URI}" \
  -var "vm_admin_username=${AZURE_VM_ADMIN}" \
  -var "vm_admin_public_key=${PCF_SSH_KEY_PUB}" \
  -var "azure_multi_resgroup_network=${AZURE_MULTI_RESGROUP_NETWORK}" \
  -var "azure_multi_resgroup_pcf=${AZURE_MULTI_RESGROUP_PCF}" \
  -var "priv_ip_opsman_vm=${AZURE_TERRAFORM_OPSMAN_PRIV_IP}" \
  -var "azure_account_name=${AZURE_ACCOUNT_NAME}" \
  -var "azure_buildpacks_container=${AZURE_BUILDPACKS_CONTAINER}" \
  -var "azure_droplets_container=${AZURE_DROPLETS_CONTAINER}" \
  -var "azure_packages_container=${AZURE_PACKAGES_CONTAINER}" \
  -var "azure_resources_container=${AZURE_RESOURCES_CONTAINER}" \
  -var "om_disk_size_in_gb=${PCF_OPSMAN_DISK_SIZE_IN_GB}" \
  -out terraform.tfplan \
  -state terraform.tfstate \
  "terraform"

echo "=============================================================================================="
echo "Executing Terraform Apply ..."
echo "=============================================================================================="

terraform apply \
  -state-out terraform.tfstate \
  terraform.tfplan
