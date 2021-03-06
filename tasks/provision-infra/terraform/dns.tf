///////////////////////////////////////////////
//////// Pivotal Customer[0] //////////////////
//////// Set Azure DNS references /////////////
///////////////////////////////////////////////

resource "azurerm_dns_zone" "env_dns_zone" {
  name                = "${var.pcf_ert_domain}"
  resource_group_name = "${var.azure_multi_resgroup_network}"
}

resource "azurerm_dns_a_record" "ops_manager_dns" {
  name                = "opsman"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${var.azure_multi_resgroup_network}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.opsman-public-ip.ip_address}"]
}

resource "azurerm_dns_a_record" "apps" {
  name                = "*.cfapps"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${var.azure_multi_resgroup_network}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.web-lb-public-ip.ip_address}"]
}

resource "azurerm_dns_a_record" "sys" {
  name                = "*.sys"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${var.azure_multi_resgroup_network}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.web-lb-public-ip.ip_address}"]
}

resource "azurerm_dns_a_record" "mysql" {
  name                = "mysql-proxy-lb.sys"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${var.azure_multi_resgroup_network}"
  ttl                 = "60"
  records             = ["${var.priv_ip_mysql_lb}"]
}

resource "azurerm_dns_a_record" "ssh-proxy" {
  name                = "ssh.sys"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${var.azure_multi_resgroup_network}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.ssh-proxy-lb-public-ip.ip_address}"]
}

resource "azurerm_dns_a_record" "tcp" {
  name                = "tcp"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${var.azure_multi_resgroup_network}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.tcp-lb-public-ip.ip_address}"]
}

resource "azurerm_dns_a_record" "jumpbox" {
  name                = "jumpbox"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${var.azure_multi_resgroup_network}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.jb-lb-public-ip.ip_address}"]
}
