# Virtual Network
resource "azurerm_virtual_network" "ltc-vn" {
  name                = "ltc-network"
  resource_group_name = azurerm_resource_group.ltc-rg.name
  location            = azurerm_resource_group.ltc-rg.location
  address_space       = ["10.30.0.0/16"]

  tags = {
    environment = "dev"
  }
}

# Subnet
resource "azurerm_subnet" "ltc-sn" {
  name                 = "ltc-subnet"
  resource_group_name  = azurerm_resource_group.ltc-rg.name
  virtual_network_name = azurerm_virtual_network.ltc-vn.name
  address_prefixes     = ["10.30.1.0/24"]
}

# NSG
resource "azurerm_network_security_group" "ltc-nsg" {
  name                = "ltc-nsg"
  location            = azurerm_resource_group.ltc-rg.location
  resource_group_name = azurerm_resource_group.ltc-rg.name

  tags = {
    environment = "dev"
  }
}

# Security Rule
resource "azurerm_network_security_rule" "ltc-sec-rule" {
  name                        = "ltc-sec-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "172.0.12.230/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ltc-rg.name
  network_security_group_name = azurerm_network_security_group.ltc-nsg.name
}

# Create network interface
resource "azurerm_network_interface" "ltc-NIC" {
  name                = "ltc-NIC"
  location            = azurerm_resource_group.ltc-rg.location
  resource_group_name = azurerm_resource_group.ltc-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ltc-sn.id
    private_ip_address_allocation = "Static"
    private_ip_address        = "10.30.1.10" # Choose any free IP in 10.30.1.4-254
  }
}

resource "azurerm_subnet_network_security_group_association" "ltc-sga" {
  subnet_id                 = azurerm_subnet.ltc-sn.id
  network_security_group_id = azurerm_network_security_group.ltc-sec-rule.id
}

