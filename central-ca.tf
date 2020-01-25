resource "azurerm_resource_group" "central-ca" {
  name     = "${var.prefix}-CentralCA"
  location = "Canada Central"
}

resource "azurerm_network_security_group" "central-ca" {
  name                = "${var.prefix}-CentralCA-SecurityGroup"
  location            = "${azurerm_resource_group.central-ca.location}"
  resource_group_name = "${azurerm_resource_group.central-ca.name}"

  security_rule {
    name                       = "AllowSSHIn"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowICMPIn"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "ICMP"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSHOut"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowICMPOut"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "ICMP"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}