#resource "azurerm_network_security_group" "don" {
#  name                = "DON-NGS"
#  location            = azurerm_resource_group.vnet.location
# resource_group_name = azurerm_resource_group.vnet.name

#  security_rule {
#    name                       = "Don-Home"
#    priority                   = 100
#    direction                  = "Inbound"
#    access                     = "Allow"
#    protocol                   = "Tcp"
#    source_port_range          = "*"
#    destination_port_ranges     = ["80", "22", "443"]
#    source_address_prefix      = var.home_ip
#    destination_address_prefix = "*"
#  }
#}

