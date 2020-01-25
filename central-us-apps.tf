resource "azurerm_virtual_network" "central-us-apps" {
  name                = "${var.prefix}-Vnet-CentralUS-Apps"
  location            = "${azurerm_resource_group.central-us.location}"
  resource_group_name = "${azurerm_resource_group.central-us.name}"
  address_space       = ["192.2.0.0/16"]
}

resource "azurerm_virtual_network_peering" "us-apps-hub" {
  name                         = "${var.prefix}-CentralUS-Peering-Apps-Hub"
  resource_group_name          = "${azurerm_resource_group.central-us.name}"
  virtual_network_name         = "${azurerm_virtual_network.central-us-apps.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.central-us-hub.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "us-hub-apps" {
  name                         = "${var.prefix}-CentralUS-Peering-Hub-Apps"
  resource_group_name          = "${azurerm_resource_group.central-us.name}"
  virtual_network_name         = "${azurerm_virtual_network.central-us-hub.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.central-us-apps.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}