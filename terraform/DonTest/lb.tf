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
  frontend_port                  = 19080
  backend_port                   = 19080
  frontend_ip_configuration_name = "private"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.sf.id
  probe_id                       = azurerm_lb_probe.http.id
}

resource "azurerm_lb_rule" "client" {
  resource_group_name            = azurerm_resource_group.sf.name
  loadbalancer_id                = azurerm_lb.sf.id
  name                           = "Client"
  protocol                       = "Tcp"
  frontend_port                  = 19000
  backend_port                   = 19000
  frontend_ip_configuration_name = "private"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.sf.id
  probe_id                       = azurerm_lb_probe.client.id
}

resource "azurerm_lb_rule" "proxy" {
  resource_group_name            = azurerm_resource_group.sf.name
  loadbalancer_id                = azurerm_lb.sf.id
  name                           = "Proxy"
  protocol                       = "Tcp"
  frontend_port                  = 19081
  backend_port                   = 19081
  frontend_ip_configuration_name = "private"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.sf.id
  probe_id                       = azurerm_lb_probe.proxy.id
}


resource "azurerm_lb_probe" "http" {
  resource_group_name = azurerm_resource_group.sf.name
  loadbalancer_id     = azurerm_lb.sf.id
  name                = "httpprobe"
  port                = 19080
}

resource "azurerm_lb_probe" "client" {
  resource_group_name = azurerm_resource_group.sf.name
  loadbalancer_id     = azurerm_lb.sf.id
  name                = "clientprobe"
  port                = 19000
}

resource "azurerm_lb_probe" "proxy" {
  resource_group_name = azurerm_resource_group.sf.name
  loadbalancer_id     = azurerm_lb.sf.id
  name                = "proxyprobe"
  port                = 19081
}

resource "azurerm_lb_nat_pool" "sf" {
  resource_group_name            = azurerm_resource_group.sf.name
  loadbalancer_id                = azurerm_lb.sf.id
  name                           = "SFNatPool"
  protocol                       = "Tcp"
  frontend_port_start            = 3389
  frontend_port_end              = 4500 
  backend_port                   = 3389
  frontend_ip_configuration_name = "private"
}
