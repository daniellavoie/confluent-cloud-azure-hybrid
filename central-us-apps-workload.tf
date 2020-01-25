resource "azurerm_subnet" "us-apps-workload" {
  name                 = "${var.prefix}-Subnet-CentralUS-Apps-Workload"
  resource_group_name  = "${azurerm_resource_group.central-us.name}"
  virtual_network_name = "${azurerm_virtual_network.central-us-apps.name}"
  address_prefix       = "192.2.1.0/24"

  lifecycle { 
     ignore_changes = ["route_table_id"]
 }
}

resource "azurerm_subnet_network_security_group_association" "us-apps-workload" {
  subnet_id                 = "${azurerm_subnet.us-apps-workload.id}"
  network_security_group_id = "${azurerm_network_security_group.central-us.id}"
}

resource "azurerm_subnet_route_table_association" "us-apps-workload" {
  subnet_id      = "${azurerm_subnet.us-apps-workload.id}"
  route_table_id = "${azurerm_route_table.us-hub.id}"
}