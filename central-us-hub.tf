resource "azurerm_virtual_network" "central-us-hub" {
  name                = "${var.prefix}-Vnet-CentralUS-Hub"
  location            = "${azurerm_resource_group.central-us.location}"
  resource_group_name = "${azurerm_resource_group.central-us.name}"
  address_space       = ["192.0.0.0/16"]
}

resource "azurerm_virtual_network_peering" "us-ca" {
  name                         = "${var.prefix}-CentralUS-GlobalPeering"
  resource_group_name          = "${azurerm_resource_group.central-us.name}"
  virtual_network_name         = "${azurerm_virtual_network.central-us-hub.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.central-ca-hub.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

resource "azurerm_route_table" "us-hub" {
  name                          = "${var.prefix}-CentralUS-Hub-UDR"
  location                      = "${azurerm_resource_group.central-us.location}"
  resource_group_name           = "${azurerm_resource_group.central-us.name}"
  disable_bgp_route_propagation = true

  route {
    name                   = "${var.prefix}-CentralUS-Hub-UDR-CA"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${azurerm_firewall.central-us.ip_configuration[0].private_ip_address}"
  }
  
  route {
    name                   = "${var.prefix}-CentralUS-Hub-UDR-Nat"
    address_prefix         = "192.0.1.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${azurerm_network_interface.us-nat.private_ip_address}"
  }
  
  route {
    name                   = "${var.prefix}-CentralUS-Hub-UDR-US"
    address_prefix         = "192.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${azurerm_firewall.central-us.ip_configuration[0].private_ip_address}"
  }
}