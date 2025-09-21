subscription_id = "<your-subscription-id>"
location         = "uksouth"
vm_count          = 1
sig_name          = "acg_<your-sig-name>_uks"
sig_rg            = "<customer-buildimages-uks>"
sig_image_name    = "<your-sig-image-name>"

avd_rg            = "customer_name-avdsessionhosts-uks"
vm_size           = "Standard_D8as_v5"

subnet_name       = "snet-avdresources"
vnet_name         = "vnet-customer_name-production-uks"
vnet_rg           = "customer_name-networking-uks"

hostpool_name     = "hostpool-customer_name-01-uks"
registration_token = "<your-registration-token>"

domain_name       = "customer_namepayrite.co.uk"
domain_user       = "irisadmin@customer_name.co.uk"
domain_password   = "<your-domain-password>"

local_admin_username = "AVDAdmin"
local_admin_password = "<your-local-admin-password>"
