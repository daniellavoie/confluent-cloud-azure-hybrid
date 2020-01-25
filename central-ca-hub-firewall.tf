resource "azurerm_subnet" "ca-hub-firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = "${azurerm_resource_group.central-ca.name}"
  virtual_network_name = "${azurerm_virtual_network.central-ca-hub.name}"
  address_prefix       = "10.0.0.0/24"
  
  lifecycle { 
     ignore_changes = ["route_table_id"]
 }
}

resource "azurerm_public_ip" "ca-hub-firewall" {
  name                = "${var.prefix}-CentralCA-Firewall-Public-IP"
  location            = "Canada Central"
  resource_group_name = "${azurerm_resource_group.central-ca.name}"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "central-ca" {
  name                = "${var.prefix}-CentralCA-Firewall"
  location            = "${azurerm_resource_group.central-ca.location}"
  resource_group_name = "${azurerm_resource_group.central-ca.name}"

  ip_configuration {
    name                 = "${var.prefix}-CentralCA-Firewall-IP-Config"
    subnet_id            = "${azurerm_subnet.ca-hub-firewall.id}"
    public_ip_address_id = "${azurerm_public_ip.ca-hub-firewall.id}"
  }
}

resource "azurerm_route_table" "ca-us" {
  name                          = "${var.prefix}-Central-CA-Firewall-UDR"
  location                      = "${azurerm_resource_group.central-ca.location}"
  resource_group_name           = "${azurerm_resource_group.central-ca.name}"
  disable_bgp_route_propagation = true

  route {
    name                   = "${var.prefix}-CentralCA-Hub-Firewall-US"
    address_prefix         = "192.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${azurerm_firewall.central-us.ip_configuration[0].private_ip_address}"
  }

  route {
    name                   = "${var.prefix}-CentralCA-Hub-Firewall-Internet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }
}

resource "azurerm_subnet_route_table_association" "ca-hub-filewall" {
  subnet_id      = "${azurerm_subnet.ca-hub-firewall.id}"
  route_table_id = "${azurerm_route_table.ca-us.id}"
}

resource "azurerm_firewall_network_rule_collection" "central-ca" {
  name                = "${var.prefix}-CentralCA-Firewall-Rules"
  azure_firewall_name = "${azurerm_firewall.central-ca.name}"
  resource_group_name = "${azurerm_resource_group.central-ca.name}"
  priority            = 100
  action              = "Allow"

  rule {
    name = "${var.prefix}-CentralCA-Firewall-Rules-AllowAll"

    source_addresses = [
      "*"
    ]

    destination_ports = [
      "1-65535"
    ]

    destination_addresses = [
      "*"
    ]

    protocols = [
      "Any"
    ]
  }
}