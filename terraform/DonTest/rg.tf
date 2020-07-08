#Resource Group
resource "azurerm_resource_group" "test" {
  name     = var.all-rsg-name
  location = var.location

}
