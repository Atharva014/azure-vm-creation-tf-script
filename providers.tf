terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.58.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "ac70ebb0-e210-4e50-aa16-ef83a50acf77"
}