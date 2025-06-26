resource "azurerm_resource_group" "main" {
  name     = "${var.application_name}-${var.environment_name}-rg"
  location = var.primary_location
}
resource "azurerm_key_vault" "main" {
  name                = "${var.application_name}-${var.environment_name}-kv"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = "afadec18-0533-4cba-8578-5316252ff93f"

  sku_name = "standard"
}