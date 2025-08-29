# Terraform Azure VM Clone

## Overview
This configuration clones a source Azure Virtual Machine by referencing its OS managed disk, then creates a new VM with configurable size, credentials, tags, and optional networking (VNet/Subnet/Public IP/NIC). It automatically looks up the source OS disk by name from the source VM unless an explicit disk ID is provided.

## What it creates
- Data sources to read the source VM and its OS managed disk.
- Target resource group–scoped resources for the new VM: Public IP, NIC, and the VM itself.
- Optional networking: VNet and Subnet created only when create_network = true.
- Outputs for the new VM ID, NIC ID, and assigned public IP address.

## Repository layout
- **variables.tf**: All input variables, including source/new VM identifiers, credentials, size, and tags.
- **main.tf**: Provider setup, data lookups, locals, optional network, public IP, and core VM resources.
- **outputs.tf**: vm_id, nic_id, and public_ip.

## Prerequisites
- Terraform >= 1.3.0
- Azure subscription with permissions to read the source VM/RG and create resources in the target RG.
- Azure CLI authenticated (`az login`) or another supported auth method for the azurerm provider.

## Inputs
- **source_vm_name**: Name of the source VM to clone.
- **source_resource_group_name**: Resource group of the source VM.
- **source_os_disk_id**: Optional explicit OS Disk ID; if null/empty, the OS disk is auto‑resolved from the source VM.
- **location**: Azure region for new resources (default: East US).
- **new_vm_name**: Name for the cloned VM.
- **new_resource_group_name**: Target resource group name for the new VM.
- **vm_size**: Azure VM size (default: Standard_DS1_v2).
- **admin_username**: Admin user for the new VM.
- **admin_password**: Admin password (sensitive).
- **tags**: Map of resource tags (defaults include environment=dev, project=vm-clone).
- **Networking toggles and names** (create_network, vnet_name, vnet_address_space, subnet_name, subnet_prefix) expected when create_network = true.

## How it works
- Data lookup reads source VM metadata and its storage_os_disk_name.
- The OS disk ID is resolved via local source_os_disk_id, preferring the explicit variable if provided; otherwise uses the managed disk data source.
- When networking creation is enabled, a VNet and Subnet are created and referenced by downstream resources; otherwise, supply existing network objects outside this module.

## Usage

### 1) Configure variables
Create `terraform.tfvars` with required values:

```hcl
source_vm_name              = "src-vm-01"
source_resource_group_name  = "rg-source"
new_resource_group_name     = "rg-target"
new_vm_name                 = "vm-clone-01"
admin_username              = "azureadmin"
admin_password              = "P@ssw0rd123!"
location                    = "East US"
create_network              = true
vnet_name                   = "vnet-clone"
vnet_address_space          = "10.10.0.0/16"
subnet_name                 = "subnet-clone"
subnet_prefix               = "10.10.1.0/24"
```

### 2) Initialize and deploy
```sh
terraform init
terraform plan
terraform apply
```

### 3) Outputs
```sh
terraform output vm_id
terraform output nic_id
terraform output public_ip
```

## Notes and options
- **Existing network**: Set `create_network = false` and provide an existing subnet/NIC wiring in your own code path; this file shows conditional creation for VNet/Subnet only.
- **Disk selection**: To clone from a different snapshot/disk, pass `source_os_disk_id` directly to bypass the lookup.
- **Sizing**: Adjust `vm_size` for workload needs; defaults suit light test/dev.
- **Security**: Treat `admin_password` as sensitive; prefer Key Vault + Terraform data sources or environment variables in CI.

## Destroy
Remove provisioned resources with:
```sh
terraform destroy
```

---
This README is structured for fast adoption and safe operations while cloning from an existing VM’s OS disk with optional network scaffolding.
