resource "azurerm_network_security_group" "rd-web" {
  name                = "${azurerm_subnet.rd-web.name}-NSG"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  security_rule {
    name                       = "VNET"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = var.cidr_rd_web
  }
}

resource "azurerm_subnet_network_security_group_association" "rd-web" {
  subnet_id                 = azurerm_subnet.rd-web.id
  network_security_group_id = azurerm_network_security_group.rd-web.id
}

resource "azurerm_network_security_group" "rd-gw" {
  name                = "${azurerm_subnet.rd-gw.name}-NSG"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  security_rule {
    name                       = "VNET"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = var.cidr_rd_gw
  }
}

resource "azurerm_subnet_network_security_group_association" "rd-gw" {
  subnet_id                 = azurerm_subnet.rd-gw.id
  network_security_group_id = azurerm_network_security_group.rd-gw.id
}
resource "azurerm_network_security_group" "rd-cb" {
  name                = "${azurerm_subnet.rd-cb.name}-NSG"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  security_rule {
    name                       = "VNET"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = var.cidr_rd_cb
  }
}

resource "azurerm_subnet_network_security_group_association" "rd-cb" {
  subnet_id                 = azurerm_subnet.rd-cb.id
  network_security_group_id = azurerm_network_security_group.rd-cb.id
}
resource "azurerm_network_security_group" "rd-ls" {
  name                = "${azurerm_subnet.rd-ls.name}-NSG"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  security_rule {
    name                       = "VNET"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = var.cidr_rd_ls
  }
}

resource "azurerm_subnet_network_security_group_association" "rd-ls" {
  subnet_id                 = azurerm_subnet.rd-ls.id
  network_security_group_id = azurerm_network_security_group.rd-ls.id
}
resource "azurerm_network_security_group" "rd-sh" {
  name                = "${azurerm_subnet.rd-sh.name}-NSG"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  security_rule {
    name                       = "VNET"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = var.cidr_rd_sh
  }
}

resource "azurerm_subnet_network_security_group_association" "rd-sh" {
  subnet_id                 = azurerm_subnet.rd-sh.id
  network_security_group_id = azurerm_network_security_group.rd-sh.id
}
resource "azurerm_network_security_group" "rd-file" {
  name                = "${azurerm_subnet.rd-file.name}-NSG"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  security_rule {
    name                       = "VNET"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = var.cidr_rd_file
  }
}

resource "azurerm_subnet_network_security_group_association" "rd-file" {
  subnet_id                 = azurerm_subnet.rd-file.id
  network_security_group_id = azurerm_network_security_group.rd-file.id
}
resource "azurerm_network_security_group" "rd-ad" {
  name                = "${azurerm_subnet.rd-ad.name}-NSG"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  security_rule {
    name                       = "VNET"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = var.cidr_rd_ad
  }
}

resource "azurerm_subnet_network_security_group_association" "rd-ad" {
  subnet_id                 = azurerm_subnet.rd-ad.id
  network_security_group_id = azurerm_network_security_group.rd-ad.id
}
resource "azurerm_network_security_group" "rd-sql" {
  name                = "${azurerm_subnet.rd-sql.name}-NSG"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  security_rule {
    name                       = "VNET"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = var.cidr_rd_sql
  }
}

resource "azurerm_subnet_network_security_group_association" "rd-sql" {
  subnet_id                 = azurerm_subnet.rd-sql.id
  network_security_group_id = azurerm_network_security_group.rd-sql.id
}
