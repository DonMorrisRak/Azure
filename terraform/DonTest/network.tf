# #Virtual Network
# resource "azurerm_virtual_network" "WEU-TST-VNET" {
#   name                = "WUE-VNET-01"
#   address_space       = ["10.20.0.0/16"]
#   location            = var.location
#   resource_group_name = azurerm_resource_group.trbrg.name
# }

data "azurerm_virtual_network" "vnet" {
  name                = "RXMAN-AEA-PRD-vnet"
  resource_group_name = "RXMAN-AEA-VNET-RSG-PRD"
}



#Subnets
resource "azurerm_subnet" "test" {
  name                 = "RXMAN-AEA-TEST-subnet"
  resource_group_name  = "RXMAN-AEA-VNET-RSG-PRD"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes       = ["172.22.96.32/27"]
}

#NSG
resource "azurerm_network_security_group" "test" {
  name                = "RXMAN-AEA-TEST-subnet-NSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.test.name

  security_rule {
    name                       = "ScaleFT"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["22", "4421"]
    source_address_prefix      = "172.22.96.0/27"
    destination_address_prefix = azurerm_subnet.test.address_prefix
  }
}

resource "azurerm_subnet_network_security_group_association" "test" {
  subnet_id                 = azurerm_subnet.test.id
  network_security_group_id = azurerm_network_security_group.test.id
}
