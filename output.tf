output "public_IP" {
  value = azurerm_windows_virtual_machine.diaz-win-01.public_ip_address
}
output "private_ip" {
  value = azurerm_windows_virtual_machine.diaz-win-01.private_ip_address
  
}
 