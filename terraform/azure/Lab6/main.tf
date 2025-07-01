resource "azurerm_resource_group" "main" {
  name     = "${var.application_name}-${var.environment_name}-rg"
  location = var.primary_location
}

resource "azurerm_public_ip" "vm1" {
  name                = "${var.application_name}-${var.environment_name}-pip-vm1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

data "azurerm_subnet" "beta" {
  name                 = "snet-beta"
  virtual_network_name = "network-dev-vnet"
  resource_group_name  = "network-dev-rg"
}

resource "azurerm_network_interface" "vm1" {
  name                = "${var.application_name}-${var.environment_name}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = data.azurerm_subnet.beta.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm1.id
  }
}

resource "tls_private_key" "vm1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# resource "local_file" "private_key" {
#   content = tls_private_key.vm1.private_key_pem
#   filename = pathexpand("~/.ssh/vm1")
#   file_permission = "0600"
# }

# resource "local_file" "public_key" {
#   content = tls_private_key.vm1.public_key_openssh
#   filename = pathexpand("~/.ssh/vm1.pub")
# }

data "azurerm_key_vault" "main" {
  name                = "devops-dev-j7e9m-kv"
  resource_group_name = "devops-dev-rg"
}

resource "azurerm_key_vault_secret" "vm1_ssh_private" {
  name         = "vm1-ssh-private"
  value        = tls_private_key.vm1.private_key_pem
  key_vault_id = data.azurerm_key_vault.main.id
}


resource "azurerm_key_vault_secret" "vm1_ssh_public" {
  name         = "vm1-ssh-public"
  value        = tls_private_key.vm1.public_key_openssh
  key_vault_id = data.azurerm_key_vault.main.id
}

resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "${var.application_name}${var.environment_name}vm1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_F2" #Standard_D2_v2_Promo
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.vm1.id,
  ]

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.vm1.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

}

# Enable entra ID extension to the VM
resource "azurerm_virtual_machine_extension" "entra_id_login" {
  name                       = "${azurerm_linux_virtual_machine.vm1.name}-AADSSHLogin"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm1.id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADSSHLoginForLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

# Add role assignment

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "entra_id_user_login" {
  scope                = azurerm_linux_virtual_machine.vm1.id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = data.azurerm_client_config.current.object_id
}