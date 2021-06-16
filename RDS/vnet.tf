resource "azurerm_virtual_network" "vnet" {
  name                = "UKS-VNET-RDS"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name
  address_space       = ["10.100.4.0/24"]

  tags = var.tags
}

resource "azurerm_subnet" "rd-web" {
  name                 = "UKS-VNET-RDS-WEB"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.cidr_rd_web]
}

resource "azurerm_subnet" "rd-gw" {
  name                 = "UKS-VNET-RDS-GATEWAY"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.cidr_rd_gw]
}

resource "azurerm_subnet" "rd-cb" {
  name                 = "UKS-VNET-RDS-CON-BROKER"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.cidr_rd_cb]
}

resource "azurerm_subnet" "rd-ls" {
  name                 = "UKS-VNET-RDS-LIC"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.cidr_rd_ls]
}

resource "azurerm_subnet" "rd-sh" {
  name                 = "UKS-VNET-RDS-SES-HOST"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.cidr_rd_sh]
}

resource "azurerm_subnet" "rd-file" {
  name                 = "UKS-VNET-RDS-FILE"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.cidr_rd_file]
}

resource "azurerm_subnet" "rd-ad" {
  name                 = "UKS-VNET-RDS-ADDS"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.cidr_rd_ad]
}

resource "azurerm_subnet" "rd-sql" {
  name                 = "UKS-VNET-RDS-SQL"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.cidr_rd_sql]
}

resource "azurerm_subnet" "rd-bast" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.cidr_rd_bast]
}