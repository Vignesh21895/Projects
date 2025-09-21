terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# ---------------------------------------------------------
# Resource Group (adjust if you already have one)
# ---------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.avd_rg
  location = "UK South"
}

# ---------------------------------------------------------
# Shared Image Gallery References
# ---------------------------------------------------------
data "azurerm_shared_image_gallery" "sig" {
  name                = var.sig_name
  resource_group_name = var.sig_rg
}

data "azurerm_shared_image" "image" {
  name                = var.sig_image_name
  gallery_name        = data.azurerm_shared_image_gallery.sig.name
  resource_group_name = data.azurerm_shared_image_gallery.sig.resource_group_name
}

data "azurerm_shared_image_version" "image_version" {
  name                = "latest"
  image_name          = data.azurerm_shared_image.image.name
  gallery_name        = data.azurerm_shared_image_gallery.sig.name
  resource_group_name = data.azurerm_shared_image_gallery.sig.resource_group_name
}

# ---------------------------------------------------------
# Networking
# ---------------------------------------------------------
data "azurerm_subnet" "production_subnet" {
  name                 = "snet-avdresources"
  virtual_network_name = "vnet-franklins-production-uks"
  resource_group_name  = "franklins-networking-uks"
}

resource "azurerm_network_interface" "sessionhost_nic" {
  count               = var.vm_count
  name                = "nic-host-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.production_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# ---------------------------------------------------------
# Windows Virtual Machines (Session Hosts)
# ---------------------------------------------------------
resource "azurerm_windows_virtual_machine" "sessionhost" {
  count               = var.vm_count
  name                = "host-2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D4ds_v5"

  admin_username = "AVDAdmin"
  admin_password = "otBAH}@=e%Y=WYR2FW#^eR>+"

  network_interface_ids = [azurerm_network_interface.sessionhost_nic[count.index].id]

  zone                = "3"
  secure_boot_enabled = true
  vtpm_enabled        = true

  source_image_id = data.azurerm_shared_image_version.image_version.id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  boot_diagnostics {
    storage_account_uri = null # managed storage account
  }
}

# ---------------------------------------------------------
# Domain Join Extension
# ---------------------------------------------------------
resource "azurerm_virtual_machine_extension" "domainjoin" {
  count                = var.vm_count
  name                 = "joindomain-${count.index + 1}"
  virtual_machine_id   = azurerm_windows_virtual_machine.sessionhost[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"

  settings = <<SETTINGS
    {
      "Name": "cloud.franklins.org.uk",
      "OUPath": "OU=AVD,DC=cloud,DC=franklins,DC=org,DC=uk",
      "User": "irisadmin@franklins.org.uk",
      "Restart": "true",
      "Options": "3"
    }
  SETTINGS

  protected_settings = <<PROTECTED
    {
      "Password": "YpR.ibHjK*xCbG3J)TEYZc}-"
    }
  PROTECTED
}

# ---------------------------------------------------------
# AVD Host Pool Registration Extension
# ---------------------------------------------------------
resource "azurerm_virtual_machine_extension" "avd_registration" {
  count                      = var.vm_count
  name                       = "avdRegistration-${count.index + 1}"
  virtual_machine_id         = azurerm_windows_virtual_machine.sessionhost[count.index].id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"

  settings = <<SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "hostPoolName": "your-hostpool-name",
        "registrationInfoToken": "paste-your-registration-key-here"
      }
    }
  SETTINGS
}
