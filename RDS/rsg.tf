resource "azurerm_resource_group" "vnet" {
  name     = "UKS-RSG-RDS-NET"
  location = var.location

  tags = var.tags
}

resource "azurerm_resource_group" "rd-web" {
  name     = "UKS-RSG-RDS-WEB"
  location = var.location

  tags = var.tags
}

resource "azurerm_resource_group" "rd-gw" {
  name     = "UKS-RSG-RDS-GATEWAY"
  location = var.location

  tags = var.tags
}

resource "azurerm_resource_group" "rd-cb" {
  name     = "UKS-RSG-RDS-CON-BROKER"
  location = var.location

  tags = var.tags
}

resource "azurerm_resource_group" "rd-ls" {
  name     = "UKS-RSG-RDS-LIC"
  location = var.location

  tags = var.tags
}

resource "azurerm_resource_group" "rd-sh" {
  name     = "UKS-RSG-RDS-SES-HOST"
  location = var.location

  tags = var.tags
}

resource "azurerm_resource_group" "rd-ad" {
  name     = "UKS-RSG-RDS-ADDS"
  location = var.location

  tags = var.tags
}

resource "azurerm_resource_group" "rd-sql" {
  name     = "UKS-RSG-RDS-MSQL"
  location = var.location

  tags = var.tags
}

resource "azurerm_resource_group" "rd-file" {
  name     = "UKS-RSG-RDS-FILE"
  location = var.location

  tags = var.tags
}