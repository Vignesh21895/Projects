terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.68.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# ------------------------
# Get the existing VM (must be generalized and deallocated)
# ------------------------
data "azurerm_virtual_machine" "generalized_vm" {
  name                = var.vm_name
  resource_group_name = var.vm_rg_name
}

# ------------------------
# Reference Compute Gallery & Image Definition
# ------------------------
data "azurerm_shared_image_gallery" "target_gallery" {
  name                = var.gallery_name
  resource_group_name = var.gallery_rg_name
}

data "azurerm_shared_image" "target_image_def" {
  name                = var.image_definition_name
  gallery_name        = data.azurerm_shared_image_gallery.target_gallery.name
  resource_group_name = data.azurerm_shared_image_gallery.target_gallery.resource_group_name
}

# ------------------------
# Create Shared Image Version directly from VM
# ------------------------

locals {
  # Day-Month-Year as integer
  date = tonumber(formatdate("YYMMDD", timestamp()))   # e.g., 250922

  # Strip leading zero from minute and hour
  minute = tonumber(formatdate("mm", timestamp()))
  hour   = tonumber(formatdate("HH", timestamp()))

  # Build X.Y.Z version (e.g., 250922.5.17)
  version = "${local.date}.${local.minute}.${local.hour}"
}
resource "azurerm_shared_image_version" "new_version" {
  # Version must be explicit; pass from CI as a formatted timestamp (e.g., 250920.0315.07)
  name                = local.version
  gallery_name        = data.azurerm_shared_image_gallery.target_gallery.name
  image_name          = data.azurerm_shared_image.target_image_def.name
  resource_group_name = data.azurerm_shared_image_gallery.target_gallery.resource_group_name
  location            = var.location

  # Use the generalized VM's resource ID as the source (no intermediate Managed Image)
  managed_image_id    = data.azurerm_virtual_machine.generalized_vm.id

  target_region {
    name                   = var.location
    regional_replica_count = 1
    storage_account_type   = "Standard_LRS"
  }

  exclude_from_latest = false

  tags = {
    customer_name       = var.customer_name
    customer_reference  = var.customer_reference
  }
}
