resource "azurerm_public_ip" "k8s" {
  name                = "don-gast-ip"
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
  allocation_method   = "Dynamic"

  tags = var.tags
}

output "pip" {
    value = azurerm_public_ip.k8s.ip_address
}

resource "azurerm_network_interface" "k8s_cp_nic" {
  name                = "don-gast-nic"
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

resource "azurerm_windows_virtual_machine" "k8s-cp" {
  name                = "don-gast"
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
  size                = "Standard_B2s"
  admin_username      = "don"
  admin_password      = var.pass
  network_interface_ids = [
    azurerm_network_interface.k8s_cp_nic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "rs5-pro"
    version   = "latest"
  }

  tags = var.tags
}