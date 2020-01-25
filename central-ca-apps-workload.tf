resource "azurerm_subnet" "ca-apps-workload" {
  name                 = "${var.prefix}-Subnet-CentralCA-Apps-Workload"
  resource_group_name  = "${azurerm_resource_group.central-ca.name}"
  virtual_network_name = "${azurerm_virtual_network.central-ca-apps.name}"
  address_prefix       = "10.2.1.0/24"

  lifecycle { 
     ignore_changes = ["route_table_id"]
 }
}

resource "azurerm_subnet_network_security_group_association" "ca-apps-workload" {
  subnet_id                 = "${azurerm_subnet.ca-apps-workload.id}"
  network_security_group_id = "${azurerm_network_security_group.central-ca.id}"
}

resource "azurerm_subnet_route_table_association" "ca-apps-workload" {
  subnet_id      = "${azurerm_subnet.ca-apps-workload.id}"
  route_table_id = "${azurerm_route_table.ca-hub.id}"
}