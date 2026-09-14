variable "resource_group_name" {
  description = "The name of the resource group in which to create compute resources."
  type        = string
}

variable "location" {
  description = "The Azure region where compute resources will be created."
  type        = string
}

variable "nic_name" {
  description = "The name of the Network Interface."
  type        = string
}

variable "vm_name" {
  description = "The name of the Linux Virtual Machine."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the Subnet to attach the NIC to."
  type        = string
}

variable "public_ip_id" {
  description = "The ID of the Public IP address to associate with the NIC."
  type        = string
}

variable "vm_size" {
  description = "The SKU size of the Virtual Machine."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "The administrator username for the Virtual Machine."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "An optional custom SSH public key. If omitted or null, a new SSH key pair is generated automatically."
  type        = string
  default     = null
}

variable "generate_local_key_file" {
  description = "Whether to save the generated private SSH key locally to id_rsa_azure.pem (only applicable when ssh_public_key is null)."
  type        = bool
  default     = true
}

variable "os_disk_storage_account_type" {
  description = "The type of storage account for the OS disk (e.g. Standard_LRS, Premium_LRS)."
  type        = string
  default     = "Standard_LRS"
}

variable "os_disk_size_gb" {
  description = "The size of the OS disk in gigabytes."
  type        = number
  default     = 30
}

variable "image_publisher" {
  description = "The publisher of the OS image."
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "The offer of the OS image."
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "The SKU of the OS image."
  type        = string
  default     = "22_04-lts-gen2"
}

variable "image_version" {
  description = "The version of the OS image."
  type        = string
  default     = "latest"
}

variable "tags" {
  description = "A mapping of tags to assign to the compute resources."
  type        = map(string)
  default     = {}
}

