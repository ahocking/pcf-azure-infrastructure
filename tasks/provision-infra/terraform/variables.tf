///////////////////////////////////////////////
//////// Pivotal Customer[0] //////////////////
//////// Set Azure Variables //////////////////
///////////////////////////////////////////////

variable "env_name" {}

variable "env_short_name" {
  description = "Used for creating storage accounts. Must be a-z only, no longer than 10 characters"
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "location" {}

variable "azure_terraform_vnet_cidr" {}
variable "azure_terraform_subnet_infra_cidr" {}
variable "azure_terraform_subnet_ert_cidr" {}
variable "azure_terraform_subnet_services1_cidr" {}
variable "azure_terraform_subnet_dynamic_services_cidr" {}

// these variables support the terraform container required by the create-infrastructure job in pcf-pipelines/install-pcf/azure/pipeline.yml
variable "azure_pcf_terraform_storage_account_name" {}
variable "azure_pcf_terraform_container_name" {}
