# Configure the Azure Provider
provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.57.0"
    }
  }
  required_version = ">= 0.15"
  backend "azurerm" {
    storage_account_name = "mvconfigstore"
    container_name       = "testbed"
    key                  = "infra.tfstate"
    # for security reasons we don't specify the access_key here.  instead set the environment variable ARM_ACCESS_KEY.
  }
}

resource "azurerm_resource_group" "testbed" {
  location = var.location
  name = "RG-${var.country}-${var.region}-TESTBED"
}