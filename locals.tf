locals {
  name_prefix = "${var.project_name}-${var.environment}"

  resource_group_name = "rg-${local.name_prefix}"
  vnet_name           = "vnet-${local.name_prefix}"
  subnet_name         = "snet-${local.name_prefix}"
  public_ip_name      = "pip-${local.name_prefix}"
  nsg_name            = "nsg-${local.name_prefix}"
  nic_name            = "nic-${local.name_prefix}"
  vm_name             = "vm-${local.name_prefix}"

  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      Region      = var.location
      ManagedBy   = "Terraform"
    },
    var.custom_tags
  )
}

