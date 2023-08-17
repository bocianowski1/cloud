terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  environment = "dev"
  location    = "norwayeast"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-resources"
  location = local.location

  tags = {
    environment = local.environment
  }
}

module "function" {
  source = "./modules/function"

  prefix       = var.prefix
  rg_name      = azurerm_resource_group.rg.name
  location     = local.location
  news_api_key = var.news_api_key
}