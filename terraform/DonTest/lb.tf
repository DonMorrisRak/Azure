resource "azurerm_lb" "sf" {
  name                = "TestLoadBalancer"
  location            = azurerm_resource_group.sf.location
  resource_group_name = azurerm_resource_group.sf.name
  sku                 = "Basic"

  frontend_ip_configuration {
    name                 = "private"
    subnet_id               = azurerm_subnet.sf.id
  }
}

resource "azurerm_lb_backend_address_pool" "sf" {
  loadbalancer_id = azurerm_lb.sf.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "http" {
  resource_group_name            = azurerm_resource_group.sf.name
  loadbalancer_id                = azurerm_lb.sf.id
  name                           = "Http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "private"
}

resource "azurerm_lb_rule" "client" {
  resource_group_name            = azurerm_resource_group.sf.name
  loadbalancer_id                = azurerm_lb.sf.id
  name                           = "Client"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "private"
}

resource "azurerm_lb_nat_pool" "sf" {
  resource_group_name            = azurerm_resource_group.sf.name
  loadbalancer_id                = azurerm_lb.sf.id
  name                           = "Http"
  protocol                       = "Tcp"
  frontend_port_start            = 20050
  frontend_port_end              = 20500 
  backend_port                   = 8080
  frontend_ip_configuration_name = "private"
}
