output "resource_group_name" {
  description = "The name of the provisioned Azure Resource Group."
  value       = module.resource_group.name
}

output "resource_group_location" {
  description = "The region where the Resource Group and its resources reside."
  value       = module.resource_group.location
}

output "virtual_network_name" {
  description = "The name of the Virtual Network."
  value       = module.network.vnet_name
}

output "subnet_name" {
  description = "The name of the Virtual Network subnet."
  value       = module.network.subnet_name
}

output "virtual_machine_name" {
  description = "The name of the Azure Linux Virtual Machine."
  value       = module.compute.vm_name
}

output "virtual_machine_id" {
  description = "The unique Resource ID of the Linux Virtual Machine."
  value       = module.compute.vm_id
}

output "public_ip_address" {
  description = "The public IP address associated with the VM network interface."
  value       = module.network.public_ip_address
}

output "private_ip_address" {
  description = "The private IP address assigned to the VM network interface within the subnet."
  value       = module.compute.private_ip_address
}

output "admin_username" {
  description = "The administrator username configured on the VM."
  value       = module.compute.admin_username
}

output "ssh_connection_command" {
  description = "Ready-to-use SSH connection command using the generated key file."
  value       = "ssh -i id_rsa_azure.pem ${module.compute.admin_username}@${module.network.public_ip_address}"
}

output "private_key_pem" {
  description = "The generated private key data in PEM format (marked sensitive)."
  value       = module.compute.private_key_pem
  sensitive   = true
}

