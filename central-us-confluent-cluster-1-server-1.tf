resource "azurerm_network_interface" "us-kafka-server-1" {
  name                = "${var.prefix}-CentralUS-Cluster-1-Server-1-NIC"
  location            = "${azurerm_resource_group.central-us.location}"
  resource_group_name = "${azurerm_resource_group.central-us.name}"

  ip_configuration {
    name                          = "${var.prefix}-CentralUS-Cluster-1-Server-1-IP-Config"
    subnet_id                     = "${azurerm_subnet.us-confluent-cluster-1.id}"
    private_ip_address            = "192.1.1.10"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_virtual_machine" "us-kafka-server-1" {
  name                  = "${var.prefix}-CentralUS-Cluster-1-Server-1"
  location              = "${azurerm_resource_group.central-us.location}"
  resource_group_name   = "${azurerm_resource_group.central-us.name}"
  network_interface_ids = ["${azurerm_network_interface.us-kafka-server-1.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-CentralUS-Cluster-1-Server-1-OS-Disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "kafka-server-1"
    admin_username = "daniellavoie"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}