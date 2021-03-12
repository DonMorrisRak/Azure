### Provider, auth keys and Environment details.
### Keys taken from tarraform.tfvars file. 

terraform {
  #  backend "local" {
  backend "azurerm" {
    resource_group_name  = "UKS-RSG-DON-TERRAFORM"
    storage_account_name = "uksdontfstore"
    container_name       = "tf-states"
    key                  = "terraform.tfstate"


  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}


provider "azurerm" {
  features {}
}

### Build Parameters ###
variable "location" {
  description = "Azure Region for the build"
  default     = "uksouth"
}

variable "vnet_name" {
  default = "don-vnet-01"
}

variable "tags" {
  type = map(any)
  default = {
    Env   = "DEV"
    Build = "DON"
  }
}

variable "name" {
  default = {
    uksouth = "UKS-DON"
    ukwest  = "UKW-DON"
  }
}

