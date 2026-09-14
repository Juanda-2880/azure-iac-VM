variable "resource_group_name" {
  description = "The name of the resource group in which to create network resources."
  type        = string
}

variable "location" {
  description = "The Azure region where the network resources will be created."
  type        = string
}

variable "vnet_name" {
  description = "The name of the Virtual Network."
  type        = string
}

variable "subnet_name" {
  description = "The name of the Subnet."
  type        = string
}

variable "public_ip_name" {
  description = "The name of the Public IP address."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space used by the Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "The address prefixes used by the Subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "tags" {
  description = "A mapping of tags to assign to network resources."
  type        = map(string)
  default     = {}
}

