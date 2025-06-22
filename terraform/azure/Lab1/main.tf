resource "azurerm_resource_group" "main" {
  name     = "${var.application_name}-${var.environment_name}-rg"
  location = var.primary_location
}


resource "random_string" "suffix" {
  length  = 10
  upper   = false
  special = false
}

resource "azurerm_storage_account" "main" {
  name                     = "${random_string.suffix.result}st"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}