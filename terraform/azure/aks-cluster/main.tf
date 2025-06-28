resource "azurerm_resource_group" "main" {
  name     = "${var.prefix_name}-${var.environment_name}-rg"
  location = "${var.location}"
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.prefix_name}-${var.environment_name}-aks"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "standard_a2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Dev"
  }
}

