# Azure Linux Virtual Machine Infrastructure as Code (Mexico Central)

## Executive Summary

This repository contains production-ready Terraform configuration for provisioning an enterprise-grade Linux Virtual Machine on Microsoft Azure within the Mexico Central (`mexicocentral`) region. Designed according to cloud architecture best practices, the solution emphasizes modularity, separation of concerns, defense-in-depth networking, and robust secret handling without hardcoded credentials.

---

## Architectural Principles and Design Decisions

### 1. Strategic Region Selection: Mexico Central

Microsoft Azure's Mexico Central (`mexicocentral`) region provides enterprise availability, data residency compliance, and ultra-low latency for workloads originating in Mexico and Latin America. All resources in this configuration (Virtual Network, Subnet, Public IP, Network Security Group, Network Interface, and Virtual Machine) are pinned to this region.

### 2. Modular Decomposition

Rather than deploying a monolithic `main.tf`, the infrastructure is decomposed into four discrete, single-responsibility modules:

- **Resource Group Module (`modules/resource_group`)**: Manages the lifecycle and tagging boundaries of the resource container.
- **Network Module (`modules/network`)**: Provisions the Virtual Network (`10.0.0.0/16`), isolated Subnet (`10.0.1.0/24`), and a dedicated Public IP.
- **Security Module (`modules/security`)**: Enforces network perimeter protection via a dedicated Network Security Group (NSG) associated at the subnet level, governing inbound SSH access.
- **Compute Module (`modules/compute`)**: Manages the Network Interface (NIC), automated cryptographic key generation, OS disk configuration, and the Ubuntu 22.04 LTS Linux Virtual Machine.

This separation ensures high reusability, simplifies automated testing, isolates blast radiuses, and facilitates independent module upgrades.

### 3. Networking and Standard SKU Public IP

Azure has phased out Basic SKU public IP addresses. This deployment uses:

- **SKU**: `Standard`
- **Allocation Method**: `Static`
- **Subnet Boundary Association**: The Network Security Group is bound directly to the Subnet (`azurerm_subnet_network_security_group_association`), guaranteeing that any compute resource placed inside the subnet inherits uniform network filtering policies.

### 4. Zero-Trust SSH Authentication and Key Management

To prevent credential stuffing and brute-force vulnerabilities:

- Password authentication is explicitly disabled (`disable_password_authentication = true`).
- A 4096-bit RSA cryptographic key pair is dynamically generated using the `tls` provider if an external public key is not supplied.
- The corresponding private key is written to a local file (`id_rsa_azure.pem`) with strict filesystem permissions (`0600`) via `local_sensitive_file`.
- Private keys and credentials are automatically ignored by Git version control via `.gitignore`.

### 5. Centralized Resource Governance and Tagging

Consistent resource naming and metadata tagging are centralized in `locals.tf`:

- Predictable prefix conventions: `rg-`, `vnet-`, `snet-`, `pip-`, `nsg-`, `nic-`, and `vm-`.
- Mandatory baseline tags (`Project`, `Environment`, `Region`, `ManagedBy = "Terraform"`) merged with optional user-supplied `custom_tags`.

---

## Repository Structure

```text
azure-iac-VM/
├── .gitignore                      # Git exclusion rules for state, plans, and secrets
├── README.md                       # Complete technical and architectural documentation
├── versions.tf                     # Terraform binary and provider version constraints
├── providers.tf                    # AzureRM provider configuration
├── variables.tf                    # Root input variable declarations with validations
├── locals.tf                       # Centralized naming prefixes and tag governance
├── main.tf                         # Root orchestrator invoking infrastructure modules
├── outputs.tf                      # Root output values and SSH connection helpers
├── terraform.tfvars                # Default configuration values for Mexico Central
├── terraform.tfvars.example        # Version-controlled configuration template
└── modules/
    ├── resource_group/             # Azure Resource Group module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── network/                    # Virtual Network, Subnet, and Public IP module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security/                   # Network Security Group and rules module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── compute/                    # NIC, SSH key generation, and Linux VM module
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Module Specifications

### Resource Group Module (`modules/resource_group`)

- **Purpose**: Creates the parent Azure Resource Group.
- **Inputs**: `name` (string), `location` (string), `tags` (map(string)).
- **Outputs**: `id`, `name`, `location`.

### Network Module (`modules/network`)

- **Purpose**: Provisions Virtual Network, Subnet, and Standard Static Public IP.
- **Inputs**: `resource_group_name`, `location`, `vnet_name`, `subnet_name`, `public_ip_name`, `vnet_address_space`, `subnet_address_prefixes`, `tags`.
- **Outputs**: `vnet_id`, `vnet_name`, `subnet_id`, `subnet_name`, `public_ip_id`, `public_ip_address`.

### Security Module (`modules/security`)

- **Purpose**: Creates Network Security Group with SSH inbound filtering and attaches it to the subnet.
- **Inputs**: `name`, `location`, `resource_group_name`, `subnet_id`, `allowed_ssh_source_address_prefix`, `tags`.
- **Outputs**: `id`, `name`.

### Compute Module (`modules/compute`)

- **Purpose**: Manages Network Interface, optional TLS SSH key pair generation, local private key file creation, and Ubuntu Linux Virtual Machine.
- **Inputs**: `resource_group_name`, `location`, `nic_name`, `vm_name`, `subnet_id`, `public_ip_id`, `vm_size`, `admin_username`, `ssh_public_key`, `generate_local_key_file`, `os_disk_storage_account_type`, `os_disk_size_gb`, `image_publisher`, `image_offer`, `image_sku`, `image_version`, `tags`.
- **Outputs**: `vm_id`, `vm_name`, `nic_id`, `private_ip_address`, `admin_username`, `public_key_openssh`, `private_key_pem` (sensitive).

---

## Input Variables Reference

| Variable Name                       | Type           | Default Value     | Description                                                                          |
| :---------------------------------- | :------------- | :---------------- | :----------------------------------------------------------------------------------- |
| `location`                          | `string`       | `"mexicocentral"` | Azure region where all infrastructure components reside.                             |
| `environment`                       | `string`       | `"dev"`           | Target deployment tier (`dev`, `staging`, `prod`, `test`).                           |
| `project_name`                      | `string`       | `"iac-vm"`        | Identifier used to construct standard resource naming conventions.                   |
| `vnet_address_space`                | `list(string)` | `["10.0.0.0/16"]` | IP CIDR block allocated to the Virtual Network.                                      |
| `subnet_address_prefixes`           | `list(string)` | `["10.0.1.0/24"]` | IP CIDR block allocated to the Virtual Machine subnet.                               |
| `allowed_ssh_source_address_prefix` | `string`       | `"*"`             | CIDR prefix allowed inbound on TCP port 22. Must be restricted in production.        |
| `vm_size`                           | `string`       | `"Standard_B2s"`  | Virtual Machine instance size.                                                       |
| `admin_username`                    | `string`       | `"azureuser"`     | Administrative username for OS-level SSH login.                                      |
| `ssh_public_key`                    | `string`       | `null`            | Optional external public key. If null, a 4096-bit RSA key is generated.              |
| `generate_local_key_file`           | `bool`         | `true`            | When true, writes generated private key to `id_rsa_azure.pem` with 0600 permissions. |
| `custom_tags`                       | `map(string)`  | `{}`              | Additional key-value pairs merged with baseline management tags.                     |

---

## Output Reference

| Output Name               | Description                                              | Sensitivity |
| :------------------------ | :------------------------------------------------------- | :---------- |
| `resource_group_name`     | Name of the provisioned Azure Resource Group.            | No          |
| `resource_group_location` | Geographic Azure region (`mexicocentral`).               | No          |
| `virtual_network_name`    | Name of the provisioned Virtual Network.                 | No          |
| `subnet_name`             | Name of the subnet containing the VM network interface.  | No          |
| `virtual_machine_name`    | Name of the provisioned Linux Virtual Machine.           | No          |
| `virtual_machine_id`      | Full Azure Resource ID of the Virtual Machine.           | No          |
| `public_ip_address`       | Public IPv4 address assigned to the VM.                  | No          |
| `private_ip_address`      | Internal IPv4 address assigned to the VM NIC.            | No          |
| `admin_username`          | Administrative SSH account username.                     | No          |
| `ssh_connection_command`  | Formatted SSH command string for direct terminal access. | No          |
| `private_key_pem`         | Generated RSA private key in PEM format.                 | Yes         |

---

## Prerequisites

Before executing Terraform commands, ensure the following tooling and authentication are present:

1. **Terraform CLI**: Version 1.5.0 or higher.

   ```bash
   terraform version
   ```

2. **Azure CLI (`az`)**: Installed and authenticated against your target Azure tenant.

   ```bash
   az login
   az account show
   ```

   If multiple subscriptions are available, set the active subscription:

   ```bash
   az account set --subscription "<SUBSCRIPTION_ID_OR_NAME>"
   ```

---

## Operational Lifecycle

Follow these steps to initialize, validate, inspect, provision, and decommission the infrastructure.

### Step 1: Clone and Configure

Copy the example variable file and customize parameters as needed:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` to set your project identifier, environment, or restrict `allowed_ssh_source_address_prefix` to your workstation or office CIDR (for example, `203.0.113.50/32`).

### Step 2: Initialize Terraform

Download provider plugins (`azurerm`, `tls`, `local`) and register local child modules:

```bash
terraform init
```

### Step 3: Format and Validate

Verify that all configuration files conform to standard HashiCorp canonical styling and that the module graph satisfies schema constraints:

```bash
terraform fmt -check -recursive
terraform validate
```

### Step 4: Generate Execution Plan

Perform a dry run to compare local configuration against Azure state without making changes:

```bash
terraform plan -out=tfplan
```

Review the plan output. The output will detail the 10 resources scheduled for creation:

- Resource Group
- Virtual Network
- Subnet
- Public IP (Standard Static)
- Network Security Group
- Subnet-NSG Association
- TLS Private Key
- Local Sensitive File (`id_rsa_azure.pem`)
- Network Interface
- Linux Virtual Machine

### Step 5: Apply Execution Plan (Deployment)

When ready to provision infrastructure on Microsoft Azure:

```bash
terraform apply tfplan
```

### Step 6: Connect to the Virtual Machine

Once provisioning completes, query the SSH command output:

```bash
terraform output -raw ssh_connection_command
```

Or connect directly using the generated private key file:

```bash
ssh -i id_rsa_azure.pem azureuser@<PUBLIC_IP_ADDRESS>
```

### Step 7: Decommission and Cleanup

To terminate all provisioned resources and prevent ongoing Azure charges:

```bash
terraform destroy
```

---

## Security Hardening and Production Guidelines

1. **Restrict SSH Ingress**: Never leave `allowed_ssh_source_address_prefix` set to `*` in production. Always restrict access to known corporate VPNs, bastion jump hosts, or Azure Bastion.
2. **State Management**: For team environments, migrate from local state to an encrypted remote backend, such as an Azure Storage Account Blob Container with state locking via Azure Blob leases.
3. **Private Key Storage**: While local key generation is convenient for development and lab environments, production workflows should ingest pre-existing public keys managed by enterprise PKI or Azure Key Vault.
4. **Git Hygiene**: State files (`.tfstate`), plan files (`.tfplan`), and private key files (`.pem`) must never be committed to source control. The included `.gitignore` enforces these exclusions.
