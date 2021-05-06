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