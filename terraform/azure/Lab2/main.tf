resource "azurerm_resource_group" "main" {
  name = "${var.application_name}-${var.environment_name}-rg"
  location = var.primary_location
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.application_name}-${var.environment_name}-log"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}