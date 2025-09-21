# Azure Image Build and AVD Deployment with Terraform

This repository contains three Terraform configurations for common Azure image and AVD workflows.

## Scenarios

### A) Build-Image VM from Snapshot (Trusted Launch)
- Creates a snapshot from a source managed OS disk, then a managed disk, networking, and a VM with Trusted Launch (secure boot + vTPM) using azapi. The VM runs a Custom Script Extension to uninstall Remote Desktop components. 

### B) Publish Shared Image Gallery Version from a Generalized VM
- Reads a deallocated, generalized VM and publishes a new SIG image version directly from the VM resource ID without an intermediate managed image. Version name is timestamp-based. 

### C) Deploy AVD Session Hosts from Latest SIG Image
- Provisions Windows session hosts from the latest SIG image, enables secure boot/vTPM, joins them to the domain, and registers them to an AVD host pool using the DSC extension. 

## Requirements
- Terraform CLI per scenario constraints (>= 1.3.0 for A/B, >= 1.6.0 for C).
- Providers: azurerm (>= 3.68.0 for A/B, >= 3.80.0 for C), and azapi for scenario A.
- Appropriate Azure permissions on subscriptions and resource groups referenced by variables.

## Files
- Scenario A: `main.tf` (snapshot → disk → VNet/Subnet → NIC/PIP → VM via azapi → CustomScriptExtension).
- Scenario B: `main.tf` (generalized VM → SIG image version).
- Scenario C: `main.tf` (SIG references → NICs → Windows VMs → Domain Join + AVD registration extensions).

## Variables (examples)

### Scenario A (`terraform.tfvars`)


source_os_disk_name = "<osdisk-name>"
source_rg_name = "<source-rg>"
buildimage_rg_name = "franklins-buildimages-uks"
location = "UK South"
customer_name = "Contoso"
customer_reference = "REF-123"


### Scenario B (`terraform.tfvars`)

subscription_id = "<sub-guid>"
vm_name = "<generalized-vm>"
vm_rg_name = "<vm-rg>"
gallery_name = "<sig-name>"
gallery_rg_name = "<sig-rg>"
image_definition_name = "<image-def>"
location = "UK South"
customer_name = "Contoso"
customer_reference = "REF-456"


### Scenario C (`terraform.tfvars`)

subscription_id = "<sub-guid>"
avd_rg = "franklins-avd-uks"
sig_name = "<sig-name>"
sig_rg = "<sig-rg>"
sig_image_name = "<image-def>"
vm_count = 2
local_admin_username = "localadmin"
local_admin_password = "P@ssw0rd"


## How to Use
1. Place the desired scenario’s `main.tf` in its own working directory and create a matching `terraform.tfvars` with the required inputs.  
2. Run `terraform init`, then `terraform plan -var-file=terraform.tfvars`.  
3. Apply with `terraform apply -var-file=terraform.tfvars`.  
4. For Scenario C, populate `JsonADDomainExtension` credentials and the AVD `registrationInfoToken` before apply.

## Notes
- The Custom Script in Scenario A removes Remote Desktop Services and the Remote Desktop Agent Boot Loader from the build VM; validate alignment with organizational standards.  
- Scenario B requires the VM to be generalized (Sysprep) and deallocated; the VM resource ID is used as `managed_image_id`.  
- Scenario C auto-increments host names by counting existing VMs in the resource group to avoid collisions.

## Cleanup
Run `terraform destroy` from the same working directory when resources are no longer needed.


