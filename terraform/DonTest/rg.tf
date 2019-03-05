#Resource Group
resource "azurerm_resource_group" "WEU-TST-RSG" {
  name     = "WEU-TF-TST-RSG"
  location = "West Europe"

  tags {
    Buildby = "Don Morris"
  }
}
