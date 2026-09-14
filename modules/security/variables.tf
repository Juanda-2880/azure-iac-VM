variable "name" {
  description = "The name of the Network Security Group."
  type        = string
}

variable "location" {
  description = "The Azure region where the NSG will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the NSG."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the Subnet to associate with this Network Security Group."
  type        = string
}

variable "allowed_ssh_source_address_prefix" {
  description = "The CIDR or IP range allowed to connect via SSH. Defaults to allowing from any source, but should be restricted in production environments."
  type        = string
  default     = "*"
}

variable "tags" {
  description = "A mapping of tags to assign to the NSG."
  type        = map(string)
  default     = {}
}

