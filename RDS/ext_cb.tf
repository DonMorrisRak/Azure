# DSC to Configure Connection Broker #
resource "azurerm_virtual_machine_extension" "rds-cb" {
  name                       = "RDS-Connection-Broker"
  virtual_machine_id         =  module.vm_cb_ls.exports_vm.0.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.20"
  auto_upgrade_minor_version = true

  depends_on = [module.vm_cb_ls, module.ext_ad_cb, azurerm_virtual_machine_extension.rds_gw_web, azurerm_virtual_machine_extension.rds_sh]



  settings = <<-BASE_SETTINGS
 {
    "wmfVersion": "latest",
    "configuration": {
        "url": "http://uksdonrdstest.blob.core.windows.net/rds/scripts.zip",
        "script": "rds.ps1",
        "function": "Broker"
    },
    "configurationArguments": {
      "DomainName": "${var.ad_domain}",
      "connectionBroker": "${module.vm_cb_ls.exports_vm.0.name}.${var.ad_domain}",
      "webAccessServer": "${module.vm_gw_web.exports_vm.0.name}.${var.ad_domain}",
      "sessionHost": "${module.vm_sh.exports_vm.0.name}.${var.ad_domain}",
      "externalfqdn": "uksrdsgwpip.uksouth.cloudapp.azure.com"
    }
 }
 BASE_SETTINGS

  protected_settings = <<-PROTECTED_SETTINGS
 {
    "configurationUrlSasToken": "${var.rds_sas}",
    "configurationArguments": {
      "Admincreds": {
        "userName": "${var.ad_netbios_name}-adm",
        "password": "${var.ad_password}"
      }
      }
    }
 PROTECTED_SETTINGS
}