 output "ssh_command" { 
   value = "ssh ${azurerm_linux_virtual_machine.myVM.admin_username}@${azurerm_public_ip.myPublicIP.ip_address}" 
   description = "SSH command to connect to the VM" 
 }