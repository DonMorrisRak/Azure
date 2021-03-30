resource "azurerm_virtual_network" "vnet" {
  name                = "DON-VNET"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name
  address_space       = ["10.100.2.0/23"]

  tags = var.tags
}

resource "azurerm_subnet" "k8s" {
  name                 = "DON-VNET-GAST"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.100.2.0/27"]
}