resource "azurerm_resource_group" "main" {
  name     = "${var.application_name}-${var.environment_name}-rg"
  location = var.primary_location
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.application_name}-${var.environment_name}-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.base_address_space]
}


locals {
  bastion_address_space = cidrsubnet(var.base_address_space, 4, 0)
  alpha_address_space = cidrsubnet(var.base_address_space, 2, 1)
  beta_address_space = cidrsubnet(var.base_address_space, 2, 2)
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.bastion_address_space]
}

resource "azurerm_subnet" "alpha" {
  name                 = "snet-alpha"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.alpha_address_space]
}

resource "azurerm_subnet" "beta" {
  name                 = "snet-beta"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.beta_address_space]
}

resource "azurerm_network_security_group" "remote_access" {
  name                = "${var.application_name}-${var.environment_name}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = chomp(data.http.my_ip.body)
    destination_address_prefix = "*"
  }

  tags = {
    department = "CloudOps"
  }
}

# resource "azurerm_subnet_network_security_group_association" "alpha_remote_access" {
#   subnet_id                 = azurerm_subnet.alpha.id
#   network_security_group_id = azurerm_network_security_group.remote_access.id
# }

# my current source address 
data "http" "my_ip" {
  url = "https://ifconfig.me/ip"
}

resource "azurerm_public_ip" "bastion" {
  name                = "${var.application_name}${var.environment_name}-bastion-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "main" {
  name                = "${var.application_name}${var.environment_name}-bas"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}