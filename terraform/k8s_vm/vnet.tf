#resource "azurerm_virtual_network" "vnet" {
#  name                = "DON-K8S-VNET"
#  location            = azurerm_resource_group.vnet.location
#  resource_group_name = azurerm_resource_group.vnet.name
#  address_space       = ["10.100.0.0/23"]
#
#  tags = var.tags
#}
