### Provider, auth keys and Environment details.
### Keys taken from tarraform.tfvars file. 

terraform {
  backend "local" {
    # backend "azurerm" {
    #   resource_group_name  = "UKS-RSG-DON-TERRAFORM"
    #   storage_account_name = "uksdontfstore"
    #   container_name       = "tf-states"
    #   key                  = "terraform.tfstate"
    # }
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

variable "tags" {
  type = map(any)
  default = {
    Application   = "RDS"
    Date = "15/06/2021"
  }
}

### Network ###
variable "cidr_rd_web" {
  default     = "10.100.4.0/28"
}
variable "cidr_rd_gw" {
  default     = "10.100.4.16/28"
}
variable "cidr_rd_cb" {
  default     = "10.100.4.32/28"
}
variable "cidr_rd_ls" {
  default     = "10.100.4.48/28"
}
variable "cidr_rd_sh" {
  default     = "10.100.4.64/28"
}
variable "cidr_rd_file" {
  default     = "10.100.4.80/28"
}
variable "cidr_rd_ad" {
  default     = "10.100.4.96/28"
}
variable "cidr_rd_sql" {
  default     = "10.100.4.112/28"
}