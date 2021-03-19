resource "azurerm_public_ip" "k8s" {
  name                = "don-k8s-cp-ip"
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
  allocation_method   = "Dynamic"

  tags = var.tags
}

output "pip" {
    value = azurerm_public_ip.k8s.ip_address
}

resource "azurerm_network_interface" "k8s_cp_nic" {
  name                = "don-k8s-cp-nic"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  enable_ip_forwarding = true 

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.k8s.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.k8s.id
  }
    tags = var.tags
}

resource "azurerm_linux_virtual_machine" "k8s-cp" {
  name                = "don-k8s-cp"
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
  size                = "Standard_B2s"
  admin_username      = "don"
  network_interface_ids = [
    azurerm_network_interface.k8s_cp_nic.id,
  ]

  admin_ssh_key {
    username   = "don"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = var.tags
}