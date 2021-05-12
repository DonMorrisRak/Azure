resource "azurerm_public_ip" "sf" {
  name                = "nat-gateway-publicIP"
  location            = azurerm_resource_group.sf.location
  resource_group_name = azurerm_resource_group.sf.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "sf" {
  name                    = "nat-Gateway"
  location                = azurerm_resource_group.sf.location
  resource_group_name     = azurerm_resource_group.sf.name
  public_ip_address_ids   = [azurerm_public_ip.sf.id]
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

resource "azurerm_subnet_nat_gateway_association" "sf" {
  subnet_id      = azurerm_subnet.sf.id
  nat_gateway_id = azurerm_nat_gateway.sf.id
}