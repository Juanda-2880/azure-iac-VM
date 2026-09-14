module "resource_group" {
  source = "./modules/resource_group"

  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

module "network" {
  source = "./modules/network"

  resource_group_name     = module.resource_group.name
  location                = module.resource_group.location
  vnet_name               = local.vnet_name
  subnet_name             = local.subnet_name
  public_ip_name          = local.public_ip_name
  vnet_address_space      = var.vnet_address_space
  subnet_address_prefixes = var.subnet_address_prefixes
  tags                    = local.common_tags
}

module "security" {
  source = "./modules/security"

  name                              = local.nsg_name
  location                          = module.resource_group.location
  resource_group_name               = module.resource_group.name
  subnet_id                         = module.network.subnet_id
  allowed_ssh_source_address_prefix = var.allowed_ssh_source_address_prefix
  tags                              = local.common_tags
}

module "compute" {
  source = "./modules/compute"

  resource_group_name     = module.resource_group.name
  location                = module.resource_group.location
  nic_name                = local.nic_name
  vm_name                 = local.vm_name
  subnet_id               = module.network.subnet_id
  public_ip_id            = module.network.public_ip_id
  vm_size                 = var.vm_size
  admin_username          = var.admin_username
  ssh_public_key          = var.ssh_public_key
  generate_local_key_file = var.generate_local_key_file
  tags                    = local.common_tags

  depends_on = [module.security]
}

