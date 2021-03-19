resource "azurerm_virtual_network" "vnet" {
  name                = "DON-K8S-VNET"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name
  address_space       = ["10.100.0.0/23"]

  tags = var.tags
}

resource "azurerm_subnet" "k8s" {
  name                 = "DON-K8S-VNET-K8S"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.100.0.0/27"]
}