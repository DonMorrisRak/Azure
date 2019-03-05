#Availability Set
resource "azurerm_availability_set" "WEU-TST-AVSET-WEB" {
  name                = "WEU-TST-AVSET-WEB"
  location            = "${var.location}"
  resource_group_name = "${var.all-rsg-name}"
  managed             = "true"

  tags {
    Buildby = "${var.buildby}"
  }
}

#NIC
resource "azurerm_network_interface" "WEU-VM-WEB-01-nic" {
  name                = "WEU-VM-WEB-01-nic"
  location            = "${var.location}"
  resource_group_name = "${var.all-rsg-name}"

  ip_configuration {
    name                          = "WEU-VM-WEB-01-nic"
    subnet_id                     = "${azurerm_subnet.WEU-TST-VNET-DMZ.id}"
    private_ip_address_allocation = "dynamic"
  }

  tags {
    Buildby = "${var.buildby}"
  }
}

#VM
resource "azurerm_virtual_machine" "WEU-VM-WEB-01" {
  name                  = "WEU-VM-WEB-01"
  location              = "${var.location}"
  resource_group_name   = "${var.all-rsg-name}"
  network_interface_ids = ["${azurerm_network_interface.WEU-VM-WEB-01-nic.id}"]
  vm_size               = "Standard_DS1_v2"
  availability_set_id   = "${azurerm_availability_set.WEU-TST-AVSET-WEB.id}"

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "WEU-VM-WEB-01"
    admin_username = "garrus"
    admin_password = "yuw0f2u87TH5VihlpinO"
  }

  os_profile_linux_config {
    disable_password_authentication = "false"
  }

  tags {
    Buildby = "${var.buildby}"
  }
}
