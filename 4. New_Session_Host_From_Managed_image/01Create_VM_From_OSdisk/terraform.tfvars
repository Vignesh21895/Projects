# Location for all new resources
location = "UK South"
# Azure Subscription ID
subscription_id = "e60d8df5-6d8c-4903-bc33-e60bc130d645"

# Source VM details
source_rg_name = "yell-avdsessionhosts-uks"
source_vm_name = "host-0"

# Destination RG (snapshot + disk + new VM go here)
buildimage_rg_name = "yell-buildimages-uks"

# Tags
customer_name      = "Yell Limited"
customer_reference = "OINEA-A2"

# VM size (optional, has a default in variables.tf)
vm_size = "Standard_D2s_v3"

# Admin credentials for the new VM (required by provider)
admin_username = "AVDAdmin"
admin_password = "Bkee,>EL)@atv&s)bFMCR_%J"   # (use Key Vault or secrets manager in real environments)

# Name of the source VM's OS disk (can be found in Azure Portal or via CLI/PowerShell)
source_os_disk_name = "host-0_OsDisk_1_3fe83a06ffaa4937b766d7af347ed3de" 