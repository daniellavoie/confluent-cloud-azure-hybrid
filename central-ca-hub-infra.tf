
resource "azurerm_subnet" "ca-hub-infra" {
  name                 = "${var.prefix}-Subnet-CentralCA-Hub-Infra"
  resource_group_name  = "${azurerm_resource_group.central-ca.name}"
  virtual_network_name = "${azurerm_virtual_network.central-ca-hub.name}"
  address_prefix       = "10.0.1.0/24"
  
  lifecycle { 
     ignore_changes = ["route_table_id"]
 }
}

resource "azurerm_subnet_network_security_group_association" "ca-hub-infra" {
  subnet_id                 = "${azurerm_subnet.ca-hub-infra.id}"
  network_security_group_id = "${azurerm_network_security_group.central-ca.id}"
}