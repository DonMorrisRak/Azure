# DSC to Configure Connection Broker #


resource "azurerm_virtual_machine_extension" "rds_gw_web" {
  count                      = length(module.vm_gw_web.exports_vm.*.id)
  name                       = "RDS-GW-WEB"
  virtual_machine_id         =  element(module.vm_gw_web.exports_vm.*.id, count.index)
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.20"
  auto_upgrade_minor_version = true

  depends_on = [module.vm_gw_web, module.ext_ad_gw]

  settings = <<-BASE_SETTINGS
 {
    "wmfVersion": "latest",
    "configuration": {
        "url": "http://uksdonrdstest.blob.core.windows.net/rds/scripts.zip",
        "script": "rds.ps1",
        "function": "Gateway"
    },
    "configurationArguments": {}
 }
 BASE_SETTINGS

  protected_settings = <<-PROTECTED_SETTINGS
 {
    "configurationUrlSasToken": "${var.rds_sas}"
    }
 PROTECTED_SETTINGS
}