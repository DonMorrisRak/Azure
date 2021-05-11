
data "azurerm_resource_group" "vnet" {
  name = "DON-NET"
}

data "azurerm_key_vault" "sf" {
  name = "don-sf-kv"
  resource_group_name = "DON-VNET"
}

data "azurerm_network_security_group" "don" {
  name                = "DON-NSG"
  resource_group_name = "DON-NET"
}

data "azurerm_virtual_network" "vnet" {
  name                = "DON-VNET"
  resource_group_name = "DON-NET"
}

data "azurerm_client_config" "current" {
}