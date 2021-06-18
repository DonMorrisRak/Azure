# DSC to Configure Connection Broker #


resource "azurerm_virtual_machine_extension" "rds_sh" {
  name                       = "RDS-Session-Host"
  virtual_machine_id         =  module.vm_sh.exports_vm.0.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.20"
  auto_upgrade_minor_version = true

  depends_on = [module.vm_sh, module.ext_ad_sh]

  settings = <<-BASE_SETTINGS
 {
    "wmfVersion": "latest",
    "configuration": {
        "url": "http://uksdonrdstest.blob.core.windows.net/rds/scripts.zip",
        "script": "rds.ps1",
        "function": "Session"
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