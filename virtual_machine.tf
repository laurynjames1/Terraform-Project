# Create virtual machine

resource "azurerm_linux_virtual_machine" "vm-03" {
  name                  = "vm-03"
  location              = azurerm_resource_group.ltc-rg.location
  resource_group_name   = azurerm_resource_group.ltc-rg.name
  network_interface_ids = [azurerm_network_interface.ltc-NIC.id]
  size                  = "Standard_DS1_v2"
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

  computer_name  = "Asterick001"
  admin_username = var.admin_username
  
  admin_ssh_key {
    username = var.admin_username
    public_key = file("/Users/jlohackx/.ssh/id_rsa.pub")
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.ltc-storage.primary_blob_endpoint
  }
}