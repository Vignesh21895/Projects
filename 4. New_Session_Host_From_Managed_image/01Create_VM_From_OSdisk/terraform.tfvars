# Location for all new resources
location = "UK South"

# Source VM details
source_rg_name = "franklins-avdsessionhosts-uks"
source_vm_name = "host-0"

# Destination RG (snapshot + disk + new VM go here)
buildimage_rg_name = "franklins-buildimages-uks"

# Tags
customer_name      = "Franklins Accountancy Audit & Tax Limited"
customer_reference = "I8687-14"

# VM size (optional, has a default in variables.tf)
vm_size = "Standard_D2s_v3"

# Admin credentials for the new VM (required by provider)
admin_username = "AVDAdmin"
admin_password = "otBAH}@=e%Y=WYR2FW#^eR>+"   # (use Key Vault or secrets manager in real environments)

# Name of the source VM's OS disk (can be found in Azure Portal or via CLI/PowerShell)
source_os_disk_name = "host-0_OsDisk_1_b26f9c7882ee442dbae3da8dbff04dfa" 