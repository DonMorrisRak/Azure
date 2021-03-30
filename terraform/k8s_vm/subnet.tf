resource "azurerm_subnet" "k8s" {
  name                 = "DON-VNET-K8S"
  resource_group_name  = data.azurerm_resource_group.vnet.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.100.2.32/27"]
}

resource "azurerm_subnet_network_security_group_association" "k8s" {
  subnet_id                 = azurerm_subnet.k8s.id
  network_security_group_id = data.azurerm_network_security_group.don.id
}