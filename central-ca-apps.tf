resource "azurerm_virtual_network" "central-ca-apps" {
  name                = "${var.prefix}-Vnet-CentralCA-Apps"
  location            = "${azurerm_resource_group.central-ca.location}"
  resource_group_name = "${azurerm_resource_group.central-ca.name}"
  address_space       = ["10.2.0.0/16"]
}

resource "azurerm_virtual_network_peering" "ca-apps-hub" {
  name                         = "${var.prefix}-CentralCA-Peering-Apps-Hub"
  resource_group_name          = "${azurerm_resource_group.central-ca.name}"
  virtual_network_name         = "${azurerm_virtual_network.central-ca-apps.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.central-ca-hub.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "ca-hub-apps" {
  name                         = "${var.prefix}-CentralCA-Peering-Hub-Apps"
  resource_group_name          = "${azurerm_resource_group.central-ca.name}"
  virtual_network_name         = "${azurerm_virtual_network.central-ca-hub.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.central-ca-apps.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}