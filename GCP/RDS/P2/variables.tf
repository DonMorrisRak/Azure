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
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = ">= 2.26"
#     }
#   }
}


provider "google" {
  project = "mpc-donavan-morris"
  region  = "europe-west2"
  zone    = "europe-west2-a"
}

variable "sas_token" {}
variable "cse_account" {}
variable "cse_key" {}
variable "buildticket" {}
variable "ad_password" {}
variable "builddate" {}
variable "buildby" {}
variable "rds_sas" {}
variable "ip" {}

variable "project_id" {
  default = "mpc-donavan-morris"
}

### Build Parameters ###
variable "location" {
  description = "Azure Region for the build"
  default     = "europe-west2"
}

variable "zone" {
  description = "Azure Region for the build"
  default     = "europe-west2-a"
}

variable "environment" {
  default     = "rds"
}

variable "tags" {
  type = map(any)
  default = {
  }
}

### Network ###
variable "cidr_rd_web" {
  default = "10.100.4.0/28"
}
variable "cidr_rd_gw" {
  default = "10.100.4.16/28"
}
variable "cidr_rd_cb" {
  default = "10.100.4.32/28"
}
variable "cidr_rd_ls" {
  default = "10.100.4.48/28"
}
variable "cidr_rd_sh" {
  default = "10.100.4.64/28"
}
variable "cidr_rd_file" {
  default = "10.100.4.80/28"
}
variable "cidr_rd_ad" {
  default = "10.100.5.0/24"
}
variable "cidr_rd_sql" {
  default = "10.100.4.112/28"
}
variable "cidr_rd_bast" {
  default = "10.100.4.128/28"
}
### Active Directory ###
variable "ad_domain" {
  default     = "don.local"
}

variable "ad_netbios_name" {
  default     = "don"
}

variable "ad_username" {
  default     = "don-adm"
}