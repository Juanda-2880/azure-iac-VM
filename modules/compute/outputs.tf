output "vm_id" {
  description = "The ID of the Virtual Machine."
  value       = azurerm_linux_virtual_machine.this.id
}

output "vm_name" {
  description = "The name of the Virtual Machine."
  value       = azurerm_linux_virtual_machine.this.name
}

output "nic_id" {
  description = "The ID of the Network Interface."
  value       = azurerm_network_interface.this.id
}

output "private_ip_address" {
  description = "The private IP address of the Virtual Machine."
  value       = azurerm_network_interface.this.private_ip_address
}

output "admin_username" {
  description = "The administrator username for the Virtual Machine."
  value       = azurerm_linux_virtual_machine.this.admin_username
}

output "private_key_pem" {
  description = "The generated private key data in PEM format, if generated."
  value       = try(tls_private_key.ssh[0].private_key_pem, null)
  sensitive   = true
}

output "public_key_openssh" {
  description = "The public key data in OpenSSH format."
  value       = local.ssh_key
}

