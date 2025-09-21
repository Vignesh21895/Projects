subscription_id      = "9f64211c-d3b3-4265-b155-73fd37eaf382"

# Generalized VM details
vm_name              = "VM-Buildimage01"
vm_rg_name           = "franklins-buildimages-uks"
location             = "uksouth"
os_type              = "Windows"

# Compute Gallery details
gallery_name         = "acg_franklins_uks"            # <-- replace with your actual gallery name
gallery_rg_name      = "franklins-buildimages-uks"          # <-- replace with your gallery RG
image_definition_name = "win10-22h2-avd-m365-g2"       # <-- replace with actual image definition

# Tagging
customer_name        = "Franklins Accountancy Audit & Tax Limited"
customer_reference   = "I8687-14"

# Version naming (CI should inject a unique timestamp string like YYMMDD.HHmm.ss)
image_version       = "250920.0330.45"

