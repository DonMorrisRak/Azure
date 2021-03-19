resource "azurerm_network_interface" "k8s_nodes_nic" {
  count               = 2
  name                = "don-k8s-node-${count.index + 1}-nic"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.k8s.id
    private_ip_address_allocation = "Dynamic"
  }
    tags = var.tags
}

resource "azurerm_linux_virtual_machine" "k8s-nodes" {
  count               = 2
  name                = "don-k8s-node-${count.index + 1}"
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
  size                = "Standard_B2s"
  admin_username      = "don"
  network_interface_ids = [element(azurerm_network_interface.k8s_nodes_nic.*.id, count.index)]

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