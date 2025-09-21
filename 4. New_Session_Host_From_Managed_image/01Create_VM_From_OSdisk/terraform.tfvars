# Location for all new resources
location = "UK South"
# Azure Subscription ID
subscription_id = "<your-subscription-id>"

# Source VM details
source_rg_name = "<your-source-rg>"   # Resource Group where the source VM is located
source_vm_name = "<your-source-vm>"   # host-0,1,2 etc

# Destination RG (snapshot + disk + new VM go here)
buildimage_rg_name = "<your-destination-rg>"

# Tags
customer_name      = "<your-customer-name>"
customer_reference = "<your-customer-reference>"

# VM size (optional, has a default in variables.tf)
vm_size = "Standard_D2s_v3"

# Admin credentials for the new VM (required by provider)
admin_username = "AVDAdmin"
admin_password = "<your-admin-password>"   # (use Key Vault or secrets manager in real environments)

# Name of the source VM's OS disk (can be found in Azure Portal or via CLI/PowerShell)
source_os_disk_name = "<your-source-os-disk-name>"