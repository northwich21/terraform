resource "azurerm_virtual_network" "sg" {
   name                = "MagentoVnet"
   address_space       = ["10.1.0.0/16"]
   location            = azurerm_resource_group.sg.location
   resource_group_name = azurerm_resource_group.sg.name
 }

 resource "azurerm_subnet" "sg1" {
   name                 = "LoadBalancersSubnet"
   resource_group_name  = azurerm_resource_group.sg.name
   virtual_network_name = azurerm_virtual_network.sg.name
   address_prefixes     = ["10.1.1.0/24"]
 }

 resource "azurerm_subnet" "sg2" {
   name                 = "FrontWebSubnet"
   resource_group_name  = azurerm_resource_group.sg.name
   virtual_network_name = azurerm_virtual_network.sg.name
   address_prefixes     = ["10.1.2.0/24"]
 }

 resource "azurerm_public_ip" "sg" {
   name                         = "MagentoPublicIPForLB"
   location                     = azurerm_resource_group.sg.location
   resource_group_name          = azurerm_resource_group.sg.name
   allocation_method            = "Static"
 }

 resource "azurerm_lb" "sg" {
   name                = "loadBalancer"
   location            = azurerm_resource_group.sg.location
   resource_group_name = azurerm_resource_group.sg.name

   frontend_ip_configuration {
     name                 = "publicIPAddress"
     public_ip_address_id = azurerm_public_ip.sg.id
   }
 }

 resource "azurerm_lb_backend_address_pool" "sg" {
   loadbalancer_id     = azurerm_lb.sg.id
   name                = "BackEndAddressPool"
 }

 resource "azurerm_network_interface" "sg" {
   count               = 2
   name                = "MagentoNic${count.index}"
   location            = azurerm_resource_group.sg.location
   resource_group_name = azurerm_resource_group.sg.name

   ip_configuration {
     name                          = "IpConfiguration"
     subnet_id                     = azurerm_subnet.sg2.id
     private_ip_address_allocation = "Dynamic"
   }
 }

  resource "azurerm_public_ip" "ssh" {
   name                         = "MagentoPublicIPForSSH"
   location                     = azurerm_resource_group.sg.location
   resource_group_name          = azurerm_resource_group.sg.name
   allocation_method            = "Static"
 }