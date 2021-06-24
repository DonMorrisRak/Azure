data "azurerm_resource_group" "rds" {
  name = "UKS-RSG-RDS-DON-TEST"
}

data "azurerm_virtual_network" "vnet" {
  name                = "UKS-VNET-RDS"
  resource_group_name = "UKS-RSG-RDS-DON-TEST"
}

data "azurerm_subnet" "rd-sh" {
  name                = "UKS-VNET-RDS-GATEWAY"
  resource_group_name = "UKS-RSG-RDS-DON-TEST"
    virtual_network_name = "UKS-VNET-RDS"
}

data "azurerm_subnet" "rd-gw" {
  name                = "UKS-VNET-RDS-GATEWAY"
  resource_group_name = "UKS-RSG-RDS-DON-TEST"
    virtual_network_name = "UKS-VNET-RDS"
}

data "azurerm_subnet" "rd-cb" {
  name                = "UKS-VNET-RDS-CON-BROKER"
  resource_group_name = "UKS-RSG-RDS-DON-TEST"
    virtual_network_name = "UKS-VNET-RDS"
}

data "azurerm_lb" "rds" {
  name               =  "UKS-RDS-GW-ELB"
  resource_group_name = "UKS-RSG-RDS-DON-TEST"
}

data "azurerm_lb_backend_address_pool" "rds" {
  name                = "RDS-GW"
  loadbalancer_id     = data.azurerm_lb.rds.id
}

data "azurerm_availability_set" "gw" {
   name                = "uksrdsgwweb-avset"
   resource_group_name = "UKS-RSG-RDS-DON-TEST"
}
