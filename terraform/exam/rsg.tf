resource "azurerm_resource_group" "rsg" {
  name     = lookup(var.name, var.location)
  location = var.location

  tags = var.tags
}

output "rsg" {
  value = azurerm_resource_group.rsg.tags
}

resource "azurerm_resource_group" "d11" {
  name     = "DON-11"
  location = "uksouth"

  tags = var.tags
}
