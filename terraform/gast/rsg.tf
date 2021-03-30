resource "azurerm_resource_group" "vnet" {
  name     = "DON-NET"
  location = var.location

  tags = var.tags
}

resource "azurerm_resource_group" "k8s" {
  name     = "DON-VNET"
  location = var.location

  tags = var.tags
}