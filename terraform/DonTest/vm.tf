# #Availability Set
# resource "azurerm_availability_set" "WEU-TST-AVSET-WEB" {
#   name                = "WEU-TST-AVSET-WEB"
#   location            = "${var.location}"
#   resource_group_name = "${var.all-rsg-name}"
#   managed             = "true"

#   tags {
#     Buildby = "${var.buildby}"
#   }
# }

#NIC
resource "azurerm_network_interface" "WEU-VM-WEB-01-nic" {
  name                = "RXMAN-AEA-TST-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.test.name

  ip_configuration {
    name                          = "RXMAN-AEA-TST-nic"
    subnet_id                     = azurerm_subnet.test.id
    private_ip_address_allocation = "dynamic"
  }
}

#VM
resource "azurerm_virtual_machine" "WEU-VM-WEB-01" {
  name                  = "RXMAN-AEA-TST"
  location              = var.location
  resource_group_name   = azurerm_resource_group.test.name
  network_interface_ids = ["${azurerm_network_interface.WEU-VM-WEB-01-nic.id}"]
  vm_size               = "Standard_B2s"

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  os_profile {
    computer_name  = "RXMAN-AEA-TST"
    admin_username = "garrus"
    admin_password = "yuw0f2u87TH5VihlpinO"
  }

  os_profile_windows_config {
    provision_vm_agent = "true"
    timezone = "E. Australia Standard Time"
  }

}
