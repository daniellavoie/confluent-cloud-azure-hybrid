resource "azurerm_public_ip" "ca-hub-test" {
  name                = "${var.prefix}-CentralCA-Hub-Test-Public-IP"
  location            = "Canada Central"
  resource_group_name = "${azurerm_resource_group.central-ca.name}"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "ca-hub-test" {
  name                = "${var.prefix}-CentralCA-Hub-Test-NIC"
  location            = "${azurerm_resource_group.central-ca.location}"
  resource_group_name = "${azurerm_resource_group.central-ca.name}"

  ip_configuration {
    name                          = "${var.prefix}-CentralCA-Hub-Test-IP-Config"
    subnet_id                     = "${azurerm_subnet.ca-hub-infra.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.ca-hub-test.id}"
  }
}

resource "azurerm_virtual_machine" "ca-hub-test" {
  name                  = "${var.prefix}-CentralCA-Hub-Test"
  location              = "${azurerm_resource_group.central-ca.location}"
  resource_group_name   = "${azurerm_resource_group.central-ca.name}"
  network_interface_ids = ["${azurerm_network_interface.ca-hub-test.id}"]
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
    name              = "${var.prefix}-CentralCA-Hub-Test-OS-Disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "infra-test"
    admin_username = "user"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}