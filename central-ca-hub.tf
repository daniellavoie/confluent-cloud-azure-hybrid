resource "azurerm_virtual_network" "central-ca-hub" {
  name                = "${var.prefix}-Vnet-CentralCA-Hub"
  location            = "${azurerm_resource_group.central-ca.location}"
  resource_group_name = "${azurerm_resource_group.central-ca.name}"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_virtual_network_peering" "ca-us" {
  name                         = "${var.prefix}-CentralCA-GlobalPeering"
  resource_group_name          = "${azurerm_resource_group.central-ca.name}"
  virtual_network_name         = "${azurerm_virtual_network.central-ca-hub.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.central-us-hub.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

resource "azurerm_route_table" "ca-hub" {
  name                          = "${var.prefix}-CentralCA-Hub-UDR"
  location                      = "${azurerm_resource_group.central-ca.location}"
  resource_group_name           = "${azurerm_resource_group.central-ca.name}"
  disable_bgp_route_propagation = true

  route {
    name                   = "${var.prefix}-CentralCA-Hub-UDR-CA"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${azurerm_firewall.central-ca.ip_configuration[0].private_ip_address}"
  }

  route {
    name                   = "${var.prefix}-CentralCA-Hub-UDR-US"
    address_prefix         = "192.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${azurerm_firewall.central-ca.ip_configuration[0].private_ip_address}"
  }
}