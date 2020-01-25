resource "azurerm_subnet" "us-confluent-cluster-1" {
  name                 = "${var.prefix}-Subnet-CentralUS-Confluent-Cluster1"
  resource_group_name  = "${azurerm_resource_group.central-us.name}"
  virtual_network_name = "${azurerm_virtual_network.central-us-confluent.name}"
  address_prefix       = "192.1.1.0/24"
  
  lifecycle { 
     ignore_changes = ["route_table_id"]
 }
}

resource "azurerm_subnet_network_security_group_association" "us-confluent-cluster-1" {
  subnet_id                 = "${azurerm_subnet.us-confluent-cluster-1.id}"
  network_security_group_id = "${azurerm_network_security_group.central-us.id}"
}