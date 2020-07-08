variable "vm_id" {
  description = "ID of the VM you are creating the extension on"
  type        = list(string)
}

variable "storage_account" {
  description = "Asset storage account"
}

variable "storage_account_key" {
  description = "Storage Account Key for asset storage account. Can be found at https://passwordsafe.corp.rackspace.com/projects/25979/credentials"
}
