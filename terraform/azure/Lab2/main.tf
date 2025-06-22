resource "azurerm_resource_group" "main" {
  name = "${var.environment_name}-${var.application_name}"
  location = var.primary_location
}