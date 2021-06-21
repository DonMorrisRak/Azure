module "vm_sh" {
  source = "github.com/global-azure/terraform-azurerm-vm.git"

  vm_count              = 2
  vm_count_start        = 1
  vm_count_zero_padding = 1 # Set to 0 to create a single server with no number suffix

  rsg            = data.azurerm_resource_group.rds.name
  vm_name        = "uksrdssh"
  # vm_name_suffix = ""
  vm_size        = "Standard_F2s_v2"
  os_disk_sku    = "Premium_LRS"
  #os_disk_size   = 128

  #nic_dns                      = ["10.100.4.101", "168.63.129.16"]
  # nic_private_ip_address_start = "192.168.50.4"
  # nic_pip_id                   = module.pip.exports.*.id
  # nic_accelerated_networking   = false
  nic_subnet_id = data.azurerm_subnet.rd-sh.id
  # Uncomment to define either an Availability Set or Availability Zone.
  # For zones, define which zones to create the VM(s) in. Will loop in ascending order (eg. 1, 2, 3, 1, 2, 3)
  # vm_avset_id = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/LOC-ENV-RSG-CODE-SERVICE/providers/Microsoft.Compute/availabilitySets/locenvcodeapp-as"
  #vm_avzones  = ["1", "2"]
  # vm_ppg      = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/LOC-ENV-RSG-CODE-SERVICE/providers/Microsoft.Compute/proximityPlacementGroups/locenvcodeapp-ppg"

  vm_os_type      = "Windows" # Either Windows or Linux
  image_publisher = "MicrosoftWindowsServer"
  image_offer     = "WindowsServer"
  image_sku       = "2019-Datacenter"
  # image_version   = "latest"
  # image_id        = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/LOC-ENV-RSG-CODE-SERVICE/providers/Microsoft.Compute/images/locenvcodeapp-image-20200423110050"

  # windows_license    = ""
  # windows_patch_mode = "Manual"

  #drive_list = var.data_ssrs

  # vm_timezone         = "UTC"
  #vm_boot_diagnostics = module.diag.exports.primary_blob_endpoint
  # admin_username      = "custom-admin"
  admin_password      = var.ad_password 

  location        = var.location
  environment     = var.environment
  tag_buildby     = var.buildby
  tag_buildticket = var.buildticket
  tag_builddate   = var.builddate
  tag_custom      = var.tags
}

# variable "data_ssrs" {
#   default = [
#     {
#       lun                       = 1
#       caching                   = "ReadWrite"
#       disk_size_gb              = 128
#       write_accelerator_enabled = false
#       managed_disk_type         = "Premium_LRS"
#     }
#   ]
# }

# ### VM EXtensions ###
# ### BGInfo ###
# module "ext_bginfo_ssrs" {
#   source = "github.com/global-azure/terraform-azurerm-bginfo.git"
#   # is_vmss = false
#   vm_id  = module.vm_ssrs.exports_vm.*.id
# }
# ### Windows CSE ###
# module "ext_win_cse_ssrs" {
#   source                = "github.com/global-azure/terraform-azurerm-cse.git"
#   # is_vmss               = false
#   vm_id                 = module.vm_ssrs.exports_vm.*.id
#   vm_extension_function = "OS"
#   storage_account       = var.cse_account
#   storage_account_key   = var.cse_key
#   module_depends_on     = [module.vm_ssrs.exports_disk_attachment.*.id]
# }

### Domain Join ###
module "ext_ad_sh" {
  source                    = "github.com/global-azure/terraform-azurerm-domain-join.git"
  # is_vmss                   = false
  vm_id                     = module.vm_sh.exports_vm.*.id
  vm_extension_ad_domain    = var.ad_domain
  vm_extension_ad_username  = var.ad_username
  vm_extension_ad_password  = var.ad_password
  # vm_extension_ad_ou        = "Unit"
}