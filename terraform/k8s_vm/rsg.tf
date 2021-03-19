resource "azurerm_resource_group" "vnet" {
  name     = "DON-K8S-NET"
  location = var.location

  tags = var.tags
}

resource "azurerm_resource_group" "k8s" {
  name     = "DON-K8S"
  location = var.location

  tags = var.tags
}