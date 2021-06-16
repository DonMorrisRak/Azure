module "pip_cbast" {
  source = "github.com/global-azure/terraform-azurerm-publicip.git"

  # pip_count              = 2
  # pip_count_start        = 3
  # pip_count_zero_padding = 2

  name        = "UKS-RDS-BAST-PIP"
  pip_rsg     = azurerm_resource_group.vnet.name
  pip_sku     = "Standard"
  allocation  = "Static"
  # pip_avzones = ["1"]

  location        = var.location
  environment     = var.environment
  tag_buildby     = var.buildby
  tag_buildticket = var.buildticket
  tag_builddate   = var.builddate
  tag_custom      = var.tags
}


resource "azurerm_bastion_host" "cbast" {
  name                = "UKS-RDS-BAST"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.rd-bast.id
    public_ip_address_id = module.pip_cbast.exports.*.id[0]
  }

  tags = merge({
    Environment = var.environment
    BuildBy     = var.buildby
    BuildTicket = var.buildticket
    BuildDate   = var.builddate
  }, var.tags)
}