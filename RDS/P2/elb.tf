resource "azurerm_public_ip" "rds" {
  name                = "UKS-RDS-GW-PIP"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rds.name
  allocation_method   = "Dynamic"
  domain_name_label   = "uksrdsgwpip"
}

resource "azurerm_lb" "rds" {
  name                = "UKS-RDS-GW-ELB"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rds.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.rds.id
  }
}

resource "azurerm_lb_backend_address_pool" "rds" {
  loadbalancer_id = azurerm_lb.rds.id
  name            = "RDS-GW"
}

resource "azurerm_lb_probe" "rds" {
  resource_group_name = data.azurerm_resource_group.rds.name
  loadbalancer_id     = azurerm_lb.rds.id
  name                = "RDS-GW-PROBE"
  port                = 443
}

resource "azurerm_lb_rule" "web" {
  resource_group_name = data.azurerm_resource_group.rds.name
  loadbalancer_id                = azurerm_lb.rds.id
  name                           = "RDS-GW-RULE"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.rds.id
  probe_id                       = azurerm_lb_probe.rds.id
  load_distribution              = "SourceIPProtocol"
}

resource "azurerm_lb_rule" "rds" {
  resource_group_name = data.azurerm_resource_group.rds.name
  loadbalancer_id                = azurerm_lb.rds.id
  name                           = "RDS-RD-RULE"
  protocol                       = "Tcp"
  frontend_port                  = 3391
  backend_port                   = 3391
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.rds.id
  probe_id                       = azurerm_lb_probe.rds.id
  load_distribution              = "SourceIPProtocol"
}

resource "azurerm_lb_nat_rule" "rds" {
  resource_group_name            = data.azurerm_resource_group.rds.name
  loadbalancer_id                = azurerm_lb.rds.id
  name                           = "RDPAccess"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_network_interface_backend_address_pool_association" "rds" {
  count                   = length(module.vm_gw_web.exports_nic.*.id)
  network_interface_id    = module.vm_gw_web.exports_nic.*.id[count.index]
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.rds.id
}