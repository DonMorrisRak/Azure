resource "azurerm_resource_group" "sf" {
  name     = "DON-SF"
  location = var.location

  tags = var.tags
}