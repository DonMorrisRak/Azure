#Resource Group
resource "azurerm_resource_group" "WEU-TST-RSG" {
  name     = "${var.all-rsg-name}"
  location = "${var.location}"

  tags {
    Buildby = "${var.buildby}"
  }
}
