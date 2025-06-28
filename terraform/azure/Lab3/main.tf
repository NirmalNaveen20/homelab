resource "azurerm_resource_group" "main" {
  name     = "${var.application_name}-${var.environment_name}-rg"
  location = var.primary_location
}
resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                = "${var.application_name}-${var.environment_name}-${random_string.suffix.result}-kv"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"
}

resource "azurerm_role_assignment" "terraform_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

data "azurerm_log_analytics_workspace" "observability" {
  name                = "observability-dev-log"
  resource_group_name = "observability-dev-rg"
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  name               = "${var.application_name}-${var.environment_name}-diag"
  target_resource_id = azurerm_key_vault.main.id

  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.observability.id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}