resource "azurerm_network_interface" "ca-workload-server-1" {
  name                = "${var.prefix}-CentralCA-Workload-Server-1-NIC"
  location            = "${azurerm_resource_group.central-ca.location}"
  resource_group_name = "${azurerm_resource_group.central-ca.name}"

  ip_configuration {
    name                          = "${var.prefix}-CentralCA-Workload-Server-1-IP-Config"
    subnet_id                     = "${azurerm_subnet.ca-apps-workload.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "ca-workload-server-1" {
  name                  = "${var.prefix}-CentralCA-Workload-Server-1"
  location              = "${azurerm_resource_group.central-ca.location}"
  resource_group_name   = "${azurerm_resource_group.central-ca.name}"
  network_interface_ids = ["${azurerm_network_interface.ca-workload-server-1.id}"]
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
    name              = "${var.prefix}-CentralCA-Workload-Server-1-OS-Disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "workload-server-1"
    admin_username = "user"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}