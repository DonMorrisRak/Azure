#Virtual Network
resource "azurerm_virtual_network" "WEU-TST-VNET" {
  name                = "WUE-VNET-01"
  address_space       = ["10.20.0.0/16"]
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.WEU-TST-RSG.name}"

  tags {
    Buildby = "Don Morris"
  }
}

#Subnets
resource "azurerm_subnet" "WEU-TST-VNET-DMZ" {
  name                 = "WUE-VNET-01-DMZ-TST"
  resource_group_name  = "${azurerm_resource_group.WEU-TST-RSG.name}"
  virtual_network_name = "${azurerm_virtual_network.WEU-TST-VNET.name}"
  address_prefix       = "10.20.0.0/24"
}

resource "azurerm_subnet" "WEU-TST-VNET-SQL" {
  name                 = "WUE-VNET-01-SQL-TST"
  resource_group_name  = "${azurerm_resource_group.WEU-TST-RSG.name}"
  virtual_network_name = "${azurerm_virtual_network.WEU-TST-VNET.name}"
  address_prefix       = "10.20.1.0/24"
}

#NSG
resource "azurerm_network_security_group" "WEU-TST-VNET-DMZ-NSG" {
  name                = "WEU-TST-VNET-DMZ-NSG"
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.WEU-TST-RSG.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "86.139.30.177/32"
    destination_address_prefix = "${azurerm_subnet.WEU-TST-VNET-DMZ.address_prefix}"
  }
}

resource "azurerm_subnet_network_security_group_association" "DMZ" {
  subnet_id                 = "${azurerm_subnet.WEU-TST-VNET-DMZ.id}"
  network_security_group_id = "${azurerm_network_security_group.WEU-TST-VNET-DMZ-NSG.id}"
}
