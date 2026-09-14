variable "location" {
  description = "The Azure region where all resources will be deployed."
  type        = string
  default     = "mexicocentral"
}

variable "environment" {
  description = "Target deployment environment (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod", "test"], var.environment)
    error_message = "The environment variable must be one of: dev, staging, prod, test."
  }
}

variable "project_name" {
  description = "The project or workload identifier used to construct standardized resource names."
  type        = string
  default     = "iac-vm"
}

variable "vnet_address_space" {
  description = "The CIDR block address space for the Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "The CIDR block address prefixes for the VM subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "allowed_ssh_source_address_prefix" {
  description = "Allowed CIDR prefix or IP range for inbound SSH access on port 22. In production, restrict this to trusted IP ranges."
  type        = string
  default     = "*"
}

variable "vm_size" {
  description = "The Azure VM SKU size to deploy."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "The administrative username for SSH authentication on the Linux Virtual Machine."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "An optional OpenSSH-formatted public key string. If omitted, a dedicated RSA 4096-bit key pair will be generated automatically."
  type        = string
  default     = null
}

variable "generate_local_key_file" {
  description = "Whether to write the generated private SSH key to a local PEM file (id_rsa_azure.pem) when auto-generation is used."
  type        = bool
  default     = true
}

variable "custom_tags" {
  description = "Additional tags to merge with the baseline infrastructure tags."
  type        = map(string)
  default     = {}
}

