resource "azurerm_storage_account" "sf" {
  name                     = "donsftest123"
  resource_group_name      = azurerm_resource_group.sf.name
  location                 = azurerm_resource_group.sf.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}