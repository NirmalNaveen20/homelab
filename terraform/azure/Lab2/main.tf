resource "azurerm_resource_group" "main" {
  name = "${var.application_name}-${var.environment_name}-rg"
  location = var.primary_location
}