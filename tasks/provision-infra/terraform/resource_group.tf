///////////////////////////////////////////////
//////// Pivotal Customer0 ////////////////////
//////// Set Azure Res Group //////////////////
///////////////////////////////////////////////

resource "azurerm_resource_group" "pcf_resource_group" {
  name     = "${var.azure_multi_resgroup_pcf}"
  location = "${var.location}"
}
