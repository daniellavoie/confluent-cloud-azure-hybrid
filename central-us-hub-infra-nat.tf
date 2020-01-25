resource "azurerm_public_ip" "us-nat" {
  name                = "${var.prefix}-CentralUS-NAT-Public-IP"
  location            = "Central US"
  resource_group_name = "${azurerm_resource_group.central-us.name}"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "us-nat" {
  name                = "${var.prefix}-CentralUS-NAT-NIC"
  location            = "${azurerm_resource_group.central-us.location}"
  resource_group_name = "${azurerm_resource_group.central-us.name}"

  ip_configuration {
    name                          = "${var.prefix}-CentralUS-NAT-IP-Config"
    subnet_id                     = "${azurerm_subnet.us-hub-infra.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.us-nat.id}"
  }
}

resource "azurerm_virtual_machine" "us-nat" {
  name                          = "${var.prefix}-CentralUS-NAT"
  location                      = "${azurerm_resource_group.central-us.location}"
  resource_group_name           = "${azurerm_resource_group.central-us.name}"
  network_interface_ids         = ["${azurerm_network_interface.us-nat.id}"]
  vm_size                       = "Standard_DS1_v2"

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
    name              = "${var.prefix}-CentralUS-NAT-OS-Disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "us-nat"
    admin_username = "user"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

/*
resource "azurerm_virtual_machine_extension" "us-nat-startup" {
  name                 = "${var.prefix}-CentralUS-NAT-Startup"
  location             = "${azurerm_resource_group.central-us.location}"
  resource_group_name  = "${azurerm_resource_group.central-us.name}"
  virtual_machine_name = "${azurerm_virtual_machine.us-nat.name}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "script": "${base64encode(file(var.nat-startup-file))}"
    }
SETTINGS
}
*/