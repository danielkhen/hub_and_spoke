terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.65.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-container"
    storage_account_name = "tfstate1account"
    container_name       = "danieltfstate"
    key                  = "terraform.tfstate"
  }

  required_version = ">= 1.4.6"
}