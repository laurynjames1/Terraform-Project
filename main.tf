provider "azurerm" {
  features {}
  subscription_id = "cbe41c4f-5119-4011-8aae-b4163df9cc65"
}

resource "azurerm_resource_group" "ltc-rg" {
  name     = "ltc-resource"
  location = "East US"
}



resource "azurerm_virtual_network" "ltc-vn" {
  name                = "ltc-network"
  resource_group_name = azurerm_resource_group.ltc-rg.name
  location            = azurerm_resource_group.ltc-rg.location
  address_space       = ["10.30.0.0/16"]

  tags = {
    environment = "dev"
  }
}


resource "azurerm_subnet" "ltc-sn" {
  name                 = "ltc-subnet"
  resource_group_name  = azurerm_resource_group.ltc-rg.name
  virtual_network_name = azurerm_virtual_network.ltc-vn.name
  address_prefixes     = ["10.30.1.0/24"]
}

resource "azurerm_network_security_group" "ltc-dev-rule" {
  name                = "ltc-dev-rule"
  location            = azurerm_resource_group.ltc-rg.location
  resource_group_name = azurerm_resource_group.ltc-rg.name

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "ltc-dev-rule" {
  name                        = "ltc-dev-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "172.0.12.230/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ltc-rg.name
  network_security_group_name = azurerm_network_security_group.ltc-dev-rule.name
}

resource "azurerm_subnet_network_security_group_association" "ltc-sga" {
  subnet_id                 = azurerm_subnet.ltc-sn.id
  network_security_group_id = azurerm_network_security_group.ltc-dev-rule.id
}