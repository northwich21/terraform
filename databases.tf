resource "azurerm_subnet" "sgmysql" {
  name                 = "MySQLSubnet"
  resource_group_name  = azurerm_resource_group.sg.name
  virtual_network_name = azurerm_virtual_network.sg.name
  address_prefixes     = ["10.1.3.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "sgdnsprivate" {
  name                = "sportgears-d.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.sg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "sgdnsprivatelink" {
  name                  = "sportsgears.com"
  private_dns_zone_name = azurerm_private_dns_zone.sgdnsprivate.name
  virtual_network_id    = azurerm_virtual_network.sg.id
  resource_group_name   = azurerm_resource_group.sg.name
}

resource "azurerm_mysql_flexible_server" "sgmysqlserver" {
  name                   = "sportsgears-mysql"
  resource_group_name    = azurerm_resource_group.sg.name
  location               = azurerm_resource_group.sg.location
  administrator_login    = "azureadmin"
  administrator_password = "Password1234!"
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.sgmysql.id
  private_dns_zone_id    = azurerm_private_dns_zone.sgdnsprivate.id
  sku_name               = "GP_Standard_D2ds_v4"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.sgdnsprivatelink]
}