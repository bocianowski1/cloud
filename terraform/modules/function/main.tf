resource "azurerm_function_app" "function" {
  name                = "${var.prefix}-function-app"
  resource_group_name = var.rg_name
  location            = var.location
  app_service_plan_id = azurerm_app_service_plan.asp.id
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"       = "",
    "FUNCTION_WORKER_RUNTIME"        = "node",
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.insights.instrumentation_key
  }

  os_type = "linux"
  site_config {
    linux_fx_version          = "NODE|18"
    use_32_bit_worker_process = false
  }
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  version                    = "~4"

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.prefix}storage"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_application_insights" "insights" {
  name                = "${var.prefix}-application-insights"
  resource_group_name = var.rg_name
  location            = var.location
  application_type    = "Node.JS"
}

resource "azurerm_app_service_plan" "asp" {
  name                = "${var.prefix}-app-service-plan"
  resource_group_name = var.rg_name
  location            = var.location
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}