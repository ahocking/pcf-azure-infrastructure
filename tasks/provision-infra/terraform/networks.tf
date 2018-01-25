///////////////////////////////////////////////
//////// Pivotal Customer[0] //////////////////
//////// Build VNET and Subnets ///////////////
///////////////////////////////////////////////

resource "azurerm_virtual_network" "pcf_virtual_network" {
  name                = "${var.azure_terraform_vnet_name}"
  resource_group_name = "${var.azure_multi_resgroup_network}"
  address_space       = ["${var.azure_terraform_vnet_cidr}"]
  location            = "${var.location}"
}

resource "azurerm_subnet" "infra_subnet" {
  name                = "${var.azure_terraform_subnet_infra_name}"
  resource_group_name = "${var.azure_multi_resgroup_network}"
  virtual_network_name = "${azurerm_virtual_network.pcf_virtual_network.name}"
  address_prefix       = "${var.azure_terraform_subnet_infra_cidr}"
}

resource "azurerm_subnet" "ert_subnet" {
  name                = "${var.azure_terraform_subnet_ert_name}"
  resource_group_name = "${var.azure_multi_resgroup_network}"
  virtual_network_name = "${azurerm_virtual_network.pcf_virtual_network.name}"
  address_prefix       = "${var.azure_terraform_subnet_ert_cidr}"
}

resource "azurerm_subnet" "services_subnet" {
  name                = "${var.azure_terraform_subnet_services1_name}"
  resource_group_name = "${var.azure_multi_resgroup_network}"
  virtual_network_name = "${azurerm_virtual_network.pcf_virtual_network.name}"
  address_prefix       = "${var.azure_terraform_subnet_services1_cidr}"
}

resource "azurerm_subnet" "dynamic_services_subnet" {
  name                = "${var.azure_terraform_subnet_dynamic_services_name}"
  resource_group_name = "${var.azure_multi_resgroup_network}"
  virtual_network_name = "${azurerm_virtual_network.pcf_virtual_network.name}"
  address_prefix       = "${var.azure_terraform_subnet_dynamic_services_cidr}"
}
