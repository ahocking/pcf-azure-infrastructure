///////////======================//////////////
//// Addresses      =============//////////////
///////////======================//////////////

resource "azurerm_public_ip" "tcp-lb-public-ip" {
  name                         = "tcp-lb-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${var.azure_multi_resgroup_network}"
  public_ip_address_allocation = "static"
}

resource "azurerm_public_ip" "web-lb-public-ip" {
  name                         = "web-lb-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${var.azure_multi_resgroup_network}"
  public_ip_address_allocation = "static"
}

resource "azurerm_public_ip" "opsman-public-ip" {
  name                         = "opsman-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${var.azure_multi_resgroup_network}"
  public_ip_address_allocation = "static"
}

resource "azurerm_public_ip" "ssh-proxy-lb-public-ip" {
  name                         = "ssh-proxy-lb-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${var.azure_multi_resgroup_network}"
  public_ip_address_allocation = "static"
}


resource "azurerm_public_ip" "jb-lb-public-ip" {
  name                         = "jb-lb-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${var.azure_multi_resgroup_network}"
  public_ip_address_allocation = "static"
}
