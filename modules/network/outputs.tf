output "vnet_id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "The name of the Virtual Network."
  value       = azurerm_virtual_network.this.name
}

output "subnet_id" {
  description = "The ID of the Subnet."
  value       = azurerm_subnet.this.id
}

output "subnet_name" {
  description = "The name of the Subnet."
  value       = azurerm_subnet.this.name
}

output "public_ip_id" {
  description = "The ID of the Public IP resource."
  value       = azurerm_public_ip.this.id
}

output "public_ip_address" {
  description = "The assigned public IP address."
  value       = azurerm_public_ip.this.ip_address
}

