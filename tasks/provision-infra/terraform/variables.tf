///////////////////////////////////////////////
//////// Pivotal Customer[0] //////////////////
//////// Set Azure Variables //////////////////
///////////////////////////////////////////////

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "location" {}

variable "azure_multi_resgroup_network" {}
variable "azure_multi_resgroup_pcf" {}

variable "azure_terraform_vnet_name" {}
variable "azure_terraform_vnet_cidr" {}

variable "azure_terraform_subnet_infra_name" {}
variable "azure_terraform_subnet_infra_cidr" {}

variable "azure_terraform_subnet_ert_name" {}
variable "azure_terraform_subnet_ert_cidr" {}

variable "azure_terraform_subnet_services1_name" {}
variable "azure_terraform_subnet_services1_cidr" {}

variable "azure_terraform_subnet_dynamic_services_name" {}
variable "azure_terraform_subnet_dynamic_services_cidr" {}

// these variables support the terraform container required by the create-infrastructure job in pcf-pipelines/install-pcf/azure/pipeline.yml
variable "azure_pcf_terraform_storage_account_name" {}
variable "azure_pcf_terraform_container_name" {}

variable "pcf_ert_domain" {}

variable "priv_ip_mysql_lb" {}
