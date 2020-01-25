resource "azurerm_subnet" "us-hub-firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = "${azurerm_resource_group.central-us.name}"
  virtual_network_name = "${azurerm_virtual_network.central-us-hub.name}"
  address_prefix       = "192.0.0.0/24"
  
  lifecycle { 
     ignore_changes = ["route_table_id"]
 }
}

resource "azurerm_public_ip" "us-hub-firewall" {
  name                = "${var.prefix}-CentralUS-Firewall-Public-IP"
  location            = "Central US"
  resource_group_name = "${azurerm_resource_group.central-us.name}"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "central-us" {
  name                = "${var.prefix}-CentralUS-Firewall"
  location            = "${azurerm_resource_group.central-us.location}"
  resource_group_name = "${azurerm_resource_group.central-us.name}"

  ip_configuration {
    name                 = "${var.prefix}-CentralUS-Firewall-IP-Config"
    subnet_id            = "${azurerm_subnet.us-hub-firewall.id}"
    public_ip_address_id = "${azurerm_public_ip.us-hub-firewall.id}"
  }
}

resource "azurerm_route_table" "us-ca" {
  name                          = "${var.prefix}-CentralUS-Firewall-UDR"
  location                      = "${azurerm_resource_group.central-us.location}"
  resource_group_name           = "${azurerm_resource_group.central-us.name}"
  disable_bgp_route_propagation = true

  route {
    name                   = "${var.prefix}-CentralUS-Hub-Firewall-CA"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${azurerm_firewall.central-ca.ip_configuration[0].private_ip_address}"
  }
  
  route {
    name                   = "${var.prefix}-CentralUS-Hub-UDR-US"
    address_prefix         = "192.0.1.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${azurerm_network_interface.us-nat.ip_configuration[0].private_ip_address}"
  }

  route {
    name                   = "${var.prefix}-CentralUS-Hub-Firewall-Internet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }
}

resource "azurerm_subnet_route_table_association" "us-hub-firewall" {
  subnet_id      = "${azurerm_subnet.us-hub-firewall.id}"
  route_table_id = "${azurerm_route_table.us-ca.id}"
}

resource "azurerm_firewall_network_rule_collection" "central-us" {
  name                = "${var.prefix}-central-us-firewall-rules"
  azure_firewall_name = "${azurerm_firewall.central-us.name}"
  resource_group_name = "${azurerm_resource_group.central-us.name}"
  priority            = 100
  action              = "Allow"

  rule {
    name = "${var.prefix}-CentralUS-Firewall-Rules-AllowAll"

    source_addresses = [
      "*"
    ]

    destination_ports = [
      "1-65535"
    ]

    destination_addresses = [
      "*",
    ]

    protocols = [
      "Any"
    ]
  }
}