resource "azurerm_windows_virtual_machine" "vm-template" {
  name                = var.vm_name
  resource_group_name = var.rg-name
  location            = var.vm-location
  size                = var.vm-size
  admin_username      = var.admin-user
  admin_password      = var.admin-pwd
  network_interface_ids = [var.nic-id]
  
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-smalldisk"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
    name                 = var.os-drive-name

  }
}