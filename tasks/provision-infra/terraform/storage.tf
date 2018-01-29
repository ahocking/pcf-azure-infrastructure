///////////////////////////////////////////////
//////// Pivotal Customer[0] //////////////////
//////// Set Azure Storage Accts //////////////
///////////////////////////////////////////////

resource "azurerm_storage_account" "pcf_terraform_storage_account" {
  name                     = "${var.azure_pcf_terraform_storage_account_name}"
  depends_on               = ["azurerm_resource_group.pcf_resource_group"]
  resource_group_name      = "${azurerm_resource_group.pcf_resource_group.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "pcf_terraform_storage_container" {
  name                  = "${var.azure_pcf_terraform_container_name}"
  depends_on            = ["azurerm_storage_account.pcf_terraform_storage_account"]
  resource_group_name   = "${azurerm_resource_group.pcf_resource_group.name}"
  storage_account_name  = "${azurerm_storage_account.pcf_terraform_storage_account.name}"
  container_access_type = "private"
}
