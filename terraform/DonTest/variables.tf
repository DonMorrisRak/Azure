provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

variable "subscription_id" {
  description = "Enter Subscription ID for provisioning resources in Azure"
}

variable "client_id" {
  description = "Enter Client ID for Application created in Azure AD"
}

variable "client_secret" {
  description = "Enter Client secret for Application in Azure AD"
}

variable "tenant_id" {
  description = "Enter Tenant ID / Directory ID of your Azure AD. Run Get-AzureSubscription to know your Tenant ID"
}

variable "location" {
  default = "australiaeast"
}

variable "all-rsg-name" {
  default = "RXMAN-AEA-TEST-RSG-PRD"
}

variable "buildby" {
  default = "Don Morris"
}

variable "cse_account" {
  default = "raxmanaeabuild"
}

variable "cse_key" {
  default = "pWxb90s1Cn3LMt1fZTSsse34WYTeiNUTzpB/EN/SrvduJv7mbu/+JDUoO3iOYJl7tcfDC2InaV6jsCAfLRoNUQ=="
}