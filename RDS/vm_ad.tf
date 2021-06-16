module "vm_ads" {
  source = "github.com/global-azure/terraform-azurerm-winvm-ad.git"

  vm_count_start        = 1
  vm_count_zero_padding = 1 # Set to 0 to create a single server with no number suffix

  vm_rsg_name    = azurerm_resource_group.rd-ad.name
  vm_subnet_id   = azurerm_subnet.rd-ad.id
  vm_size        = "Standard_B1s"
  vm_name        = "uksrdsad"
  # vm_name_suffix = ""

  vm_disk_sku    = "Standard_LRS"
 #vm_os_disk_size   = 128
  vm_data_disk_size = 32

  image_publisher = "MicrosoftWindowsServer"
  image_offer     = "WindowsServer"
  image_sku       = "2019-Datacenter"
  image_version   = "latest"

  # Define IP address(es) for the AD servers.
  # They are required to be static.
  # The number of IPs provided determines the number of BDCs to create (eg. 2 IPs builds 1 PDC and 1 BDC).
  nic_private_ip_address = ["10.100.4.101"]
  # vm_nic_dns           = ["locenvads01", "locenvads02"]
  # vm_nic_accelerate    = false

  # Uncomment to define either an Availability Set or Availability Zone.
  # For zones, define which zones to create the VM(s) in. Will loop in ascending order (eg. 1, 2, 3, 1, 2, 3)
  #
  # vm_avset_id = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/LOC-ENV-RSG-ADS/providers/Microsoft.Compute/availabilitySets/locenvads-as"
  #vm_avzones  = ["1", "2"]

  # Uncomment to set timezone away from default of UTC.
  # Uncomment to enable boot diagnostics.
  #
  # vm_timezone         = "UTC"
  #vm_boot_diagnostics = module.diag.exports.primary_blob_endpoint

  # windows_license    = "None"
  # windows_patch_mode = "Manual"

  # Domain specific details must be defined.
  # The Domain Administrator will be named <netbios>-adm.
  ad_domain       = var.ad_domain
  ad_netbios_name = var.ad_netbios_name
  ad_password     = var.ad_password     # Do not hard code passwords in plans

  sas_token       = var.sas_token
  location        = var.location
  environment     = var.environment
  tag_buildby     = var.buildby
  tag_buildticket = var.buildticket
  tag_builddate   = var.builddate
  tag_custom      = var.tags
}