Example:

module "web_vms_cse" {
  source                = "github.com/global-azure/terraform-azurerm-cse.git"
  vm_id                 = module.vm01.vm.*.id
  storage_account       = var.cse_account
  storage_account_key   = var.cse_key
}