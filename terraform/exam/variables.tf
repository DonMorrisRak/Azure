### Provider, auth keys and Environment details.
### Keys taken from tarraform.tfvars file. 

terraform {
  backend "local" {
    # organization = "Don"
    # workspaces {
    #  name = "DOMO"
    #}
  }
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "docker" {}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}

variable "subscription_id" {
  description = "Target Azure Subscription ID"
}

variable "tenant_id" {
  description = "Microsoft Tenant ID"
}

variable "client_id" {
  description = "Service Principle User ID"
}

variable "client_secret" {
  description = "Service Principle Secret"
}

### Build Parameters ###
variable "location" {
  description = "Azure Region for the build"
  default     = "uksouth"
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

