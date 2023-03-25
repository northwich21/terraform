 resource "azurerm_managed_disk" "sg" {
   count                = 2
   name                 = "datadisk_magento_${count.index}"
   location             = azurerm_resource_group.sg.location
   resource_group_name  = azurerm_resource_group.sg.name
   storage_account_type = "Standard_LRS"
   create_option        = "Empty"
   disk_size_gb         = "1023"
 }

 resource "azurerm_availability_set" "avset" {
   name                         = "magento_avset"
   location                     = azurerm_resource_group.sg.location
   resource_group_name          = azurerm_resource_group.sg.name
   platform_fault_domain_count  = 2
   platform_update_domain_count = 2
   managed                      = true
 }

 resource "azurerm_virtual_machine" "sg" {
   count                 = 2
   name                  = "MagentoVM${count.index}"
   location              = azurerm_resource_group.sg.location
   availability_set_id   = azurerm_availability_set.avset.id
   resource_group_name   = azurerm_resource_group.sg.name
   network_interface_ids = [element(azurerm_network_interface.sg.*.id, count.index)]
   vm_size               = "Standard_DS1_v2"

   # Uncomment this line to delete the OS disk automatically when deleting the VM
   # delete_os_disk_on_termination = true

   # Uncomment this line to delete the data disks automatically when deleting the VM
   # delete_data_disks_on_termination = true

   storage_image_reference {
     publisher = "Canonical"
     offer     = "0001-com-ubuntu-server-focal"
     sku       = "20_04-lts"
     version   = "latest"
   }

   storage_os_disk {
     name              = "osdisk_magento_${count.index}"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }

   storage_data_disk {
     name            = element(azurerm_managed_disk.sg.*.name, count.index)
     managed_disk_id = element(azurerm_managed_disk.sg.*.id, count.index)
     create_option   = "Attach"
     lun             = 1
     disk_size_gb    = element(azurerm_managed_disk.sg.*.disk_size_gb, count.index)
   }

   os_profile {
     computer_name  = "hostname"
     admin_username = "azureadmin"
     admin_password = "Password1234!"
   }

   os_profile_linux_config {
     disable_password_authentication = false
   }


   tags = {
     environment = "staging"
   }
 }