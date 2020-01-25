resource "azurerm_subnet" "us-hub-infra" {
  name                 = "${var.prefix}-Subnet-CentralUS-Hub-Infra"
  resource_group_name  = "${azurerm_resource_group.central-us.name}"
  virtual_network_name = "${azurerm_virtual_network.central-us-hub.name}"
  address_prefix       = "192.0.1.0/24"

  lifecycle { 
     ignore_changes = ["route_table_id"]
 }
}

resource "azurerm_subnet_network_security_group_association" "us-hub-infra" {
  subnet_id                 = "${azurerm_subnet.us-hub-infra.id}"
  network_security_group_id = "${azurerm_network_security_group.central-us.id}"
}