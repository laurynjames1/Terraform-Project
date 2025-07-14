# Create virtual machine

resource "azurerm_linux_virtual_machine" "example-vm-name" {
  name                  = "example-vm-name"
  location              = azurerm_resource_group.ltc-rg.location
  resource_group_name   = azurerm_resource_group.ltc-rg.name
  network_interface_ids = [azurerm_network_interface.ltc-NIC.id]
  size                  = "Standard_D1s"
  }
  
  os_disk {
    name                 = "ltc-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "Example-name"
  admin_username = var.admin_username #This variable will be found in your "Variables.tf" folder
  
  admin_ssh_key {
    username = var.admin_username
    public_key = file("Public-key") #Insert file path after generating public key locally 
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.ltc-storage.primary_blob_endpoint
  }
}
