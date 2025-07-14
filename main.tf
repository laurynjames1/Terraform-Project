provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "ltc_rg" {
  name     = "ltc-resource"
  location = "East US"
}

resource "azurerm_virtual_network" "ltc_vnet" {
  name                = "ltc-network"
  resource_group_name = azurerm_resource_group.ltc_rg.name
  location            = azurerm_resource_group.ltc_rg.location
  address_space       = ["10.30.0.0/16"]

  tags = {
    environment = "example tag"
  }
}

resource "azurerm_subnet" "ltc_subnet" {
  name                 = "ltc-subnet"
  resource_group_name  = azurerm_resource_group.ltc_rg.name
  virtual_network_name = azurerm_virtual_network.ltc_vnet.name
  address_prefixes     = ["10.30.1.0/24"]
}

resource "azurerm_network_security_group" "ltc_nsg" {
  name                = "ltc-nsg"
  location            = azurerm_resource_group.ltc_rg.location
  resource_group_name = azurerm_resource_group.ltc_rg.name

  tags = {
    environment = "example tag"
  }
}

resource "azurerm_network_security_rule" "ltc_ssh_rule" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "YOUR_PUBLIC_IP/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ltc_rg.name
  network_security_group_name = azurerm_network_security_group.ltc_nsg.name
}

resource "azurerm_network_interface" "ltc_nic" {
  name                = "ltc-nic"
  location            = azurerm_resource_group.ltc_rg.location
  resource_group_name = azurerm_resource_group.ltc_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ltc_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.30.1.10"
  }
}

resource "azurerm_subnet_network_security_group_association" "ltc_sga" {
  subnet_id                 = azurerm_subnet.ltc_subnet.id
  network_security_group_id = azurerm_network_security_group.ltc_nsg.id
}

resource "random_id" "unique" {
  keepers = {
    resource_group = azurerm_resource_group.ltc_rg.name
  }
  byte_length = 8
}

resource "azurerm_storage_account" "ltc_storage" {
  name                     = "diag${random_id.unique.hex}"
  location                 = azurerm_resource_group.ltc_rg.location
  resource_group_name      = azurerm_resource_group.ltc_rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_linux_virtual_machine" "example_vm" {
  name                  = "example-vm"
  location              = azurerm_resource_group.ltc_rg.location
  resource_group_name   = azurerm_resource_group.ltc_rg.name
  network_interface_ids = [azurerm_network_interface.ltc_nic.id]
  size                  = "Standard_B1s"

  os_disk {
    name                 = "ltc-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "example-vm"
  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.ltc_storage.primary_blob_endpoint
  }
}

resource "azurerm_log_analytics_workspace" "ltc_law" {
  name                = "ltc-law"
  location            = azurerm_resource_group.ltc_rg.location
  resource_group_name = azurerm_resource_group.ltc_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "ltc_sentinel" {
  workspace_id = azurerm_log_analytics_workspace.ltc_law.id
}
