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
  location    = "westeurope"
  user        = "torger"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-resources"
  location = local.location

  tags = {
    environment = local.environment
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.prefix}storage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_application_insights" "insights" {
  name                = "${var.prefix}-application-insights"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  application_type    = "Node.JS"
}

resource "azurerm_app_service_plan" "asp" {
  name                = "${var.prefix}-app-service-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "function" {
  name                = "${var.prefix}-function-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  app_service_plan_id = azurerm_app_service_plan.asp.id
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"       = "",
    "FUNCTION_WORKER_RUNTIME"        = "node",
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.insights.instrumentation_key
  }

  os_type = "linux"
  site_config {
    linux_fx_version          = "NODE|14"
    use_32_bit_worker_process = false
  }
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  version                    = "~3"

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]
  }
}