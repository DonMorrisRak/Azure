resource "azurerm_subnet" "sf" {
  name                 = "DON-VNET-SF"
  resource_group_name  = data.azurerm_resource_group.vnet.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.100.3.0/27"]
}

resource "azurerm_subnet_network_security_group_association" "sf" {
  subnet_id                 = azurerm_subnet.sf.id
  network_security_group_id = data.azurerm_network_security_group.don.id
}