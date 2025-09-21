subscription_id = "e60d8df5-6d8c-4903-bc33-e60bc130d645"

# Generalized VM details
vm_name              = "VM-Buildimage01"
vm_rg_name           = "yell-buildimages-uks"
location             = "uksouth"
os_type              = "Windows"

# Compute Gallery details
gallery_name         = "acg_yell_uks"            # <-- replace with your actual gallery name
gallery_rg_name      = "yell-buildimages-uks"          # <-- replace with your gallery RG
image_definition_name = "win11-22h2-avd-m365"       # <-- replace with actual image definition

# Tagging
customer_name        = "Yell Limited"
customer_reference   = "OINEA-A2"
