resource "azurerm_resource_group" "rsg" {
  name     = lookup(var.name, var.location)
  location = var.location

  tags = var.tags
}

output "rsg" {
  value = azurerm_resource_group.rsg.tags
}
