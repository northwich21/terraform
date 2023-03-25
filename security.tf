resource "azurerm_network_security_group" "nsg_webserver" {
  name                = "WebServerSecurityGroup1"
  location            = azurerm_resource_group.sg.location
  resource_group_name = azurerm_resource_group.sg.name

  security_rule {
    name                       = "sshadmin"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = [80,443]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "staging"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet2" {
  subnet_id                 = azurerm_subnet.sg2.id
  network_security_group_id = azurerm_network_security_group.nsg_webserver.id
}