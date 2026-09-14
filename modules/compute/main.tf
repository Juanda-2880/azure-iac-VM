locals {
  is_custom_key = var.ssh_public_key != null && var.ssh_public_key != ""
  ssh_key       = local.is_custom_key ? var.ssh_public_key : try(tls_private_key.ssh[0].public_key_openssh, "")
}

resource "tls_private_key" "ssh" {
  count     = local.is_custom_key ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "private_key" {
  count           = !local.is_custom_key && var.generate_local_key_file ? 1 : 0
  content         = tls_private_key.ssh[0].private_key_pem
  filename        = "${path.root}/id_rsa_azure.pem"
  file_permission = "0600"
}

resource "azurerm_network_interface" "this" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_id
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name                            = var.vm_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  network_interface_ids           = [azurerm_network_interface.this.id]
  disable_password_authentication = true
  tags                            = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = local.ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}

