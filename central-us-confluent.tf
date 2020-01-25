resource "azurerm_virtual_network" "central-us-confluent" {
  name                = "${var.prefix}-Vnet-CentralUS-Confluent"
  location            = "${azurerm_resource_group.central-us.location}"
  resource_group_name = "${azurerm_resource_group.central-us.name}"
  address_space       = ["192.1.0.0/16"]
}

resource "azurerm_virtual_network_peering" "us-confluent-hub" {
  name                         = "${var.prefix}-CentralUS-Peering-Confluent-Hub"
  resource_group_name          = "${azurerm_resource_group.central-us.name}"
  virtual_network_name         = "${azurerm_virtual_network.central-us-confluent.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.central-us-hub.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "us-hub-confluent" {
  name                         = "${var.prefix}-CentralUS-Peering-Hub-Confluent"
  resource_group_name          = "${azurerm_resource_group.central-us.name}"
  virtual_network_name         = "${azurerm_virtual_network.central-us-hub.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.central-us-confluent.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}