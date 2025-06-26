terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.34.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.6.3"
    }
  }
  backend "azurerm" {
    resource_group_name  = "chocolate-dev-rg"
    storage_account_name = "wahrub6ws2st"
    container_name       = "tfstate"
    key                  = "devops-dev"
  }
}

provider "azurerm" {
  features {
  }
  subscription_id = "a49abe1f-f1b0-48a0-aab0-960e145b5abc"
}