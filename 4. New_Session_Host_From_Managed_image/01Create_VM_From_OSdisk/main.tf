terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.68.0"
    }
    azapi = {
      source = "Azure/azapi"
    }
  }
  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "azapi" {}

# -----------------------
# Get source VM (to find its OS disk)
# -----------------------
data "azurerm_managed_disk" "source_os_disk" {
  name                = var.source_os_disk_name
  resource_group_name = var.source_rg_name
}

# -----------------------
# Local names with date suffix
# -----------------------
locals {
  today_ddmmyy  = formatdate("DDMMYY", timestamp())
  snapshot_name = "Snapshot-Buildimage-${local.today_ddmmyy}"
  disk_name     = "disk-buildimageOS-${local.today_ddmmyy}"
  vm_name       = "VM-Buildimage01"
}

# -----------------------
# 1) Create snapshot
# -----------------------
resource "azurerm_snapshot" "os_snapshot" {
  name                = local.snapshot_name
  resource_group_name = var.buildimage_rg_name
  location            = var.location

  create_option       = "Copy"
  source_resource_id  = data.azurerm_managed_disk.source_os_disk.id

  network_access_policy = "DenyAll"

  tags = {
    CustomerName      = var.customer_name
    CustomerReference = var.customer_reference
  }
}

# -----------------------
# 2) Create managed disk from snapshot
# -----------------------
resource "azurerm_managed_disk" "os_managed_disk" {
  name                = local.disk_name
  location            = var.location
  resource_group_name = var.buildimage_rg_name

  create_option       = "Copy"
  source_resource_id  = azurerm_snapshot.os_snapshot.id

  storage_account_type  = "StandardSSD_LRS"
  network_access_policy = "DenyAll"

  tags = {
    CustomerName      = var.customer_name
    CustomerReference = var.customer_reference
  }
}

# -----------------------
# 3) Create new VNet + Subnet
# -----------------------
resource "azurerm_virtual_network" "buildimage_vnet" {
  name                = "buildimageVNet"
  location            = var.location
  resource_group_name = var.buildimage_rg_name
  address_space       = ["10.10.0.0/16"]

  tags = {
    CustomerName      = var.customer_name
    CustomerReference = var.customer_reference
  }
}

resource "azurerm_subnet" "buildimage_subnet" {
  name                 = "buildimageSubnet"
  resource_group_name  = var.buildimage_rg_name
  virtual_network_name = azurerm_virtual_network.buildimage_vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

# -----------------------
# 4) Create NIC + Public IP for VM
# -----------------------
resource "azurerm_public_ip" "vm_pip" {
  name                = "${local.vm_name}-pip"
  location            = var.location
  resource_group_name = var.buildimage_rg_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "${local.vm_name}-nic"
  location            = var.location
  resource_group_name = var.buildimage_rg_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.buildimage_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }

  tags = {
    CustomerName      = var.customer_name
    CustomerReference = var.customer_reference
  }
}

# -----------------------
# 5) Create VM from existing managed OS disk (Trusted Launch)
# -----------------------
data "azurerm_resource_group" "buildimage" {
  name = var.buildimage_rg_name
}

resource "azapi_resource" "vm_from_disk_trusted" {
  type      = "Microsoft.Compute/virtualMachines@2024-07-01"
  name      = local.vm_name
  location  = var.location
  parent_id = data.azurerm_resource_group.buildimage.id

  body = {
    properties = {
      hardwareProfile = {
        vmSize = var.vm_size
      }
      networkProfile = {
        networkInterfaces = [
          { id = azurerm_network_interface.vm_nic.id }
        ]
      }
      storageProfile = {
        osDisk = {
          name         = azurerm_managed_disk.os_managed_disk.name
          managedDisk  = { id = azurerm_managed_disk.os_managed_disk.id }
          createOption = "Attach"
          osType       = "Windows"
          caching      = "ReadWrite"
        }
      }
      securityProfile = {
        securityType = "TrustedLaunch"
        uefiSettings = {
          secureBootEnabled = true
          vTpmEnabled       = true
        }
      }
    }
    tags = {
      CustomerName      = var.customer_name
      CustomerReference = var.customer_reference
    }
  }

  depends_on = [
    azurerm_managed_disk.os_managed_disk,
    azurerm_network_interface.vm_nic
  ]
}

resource "azurerm_virtual_machine_extension" "uninstall_rds" {
  name                 = "uninstall-rds"
  virtual_machine_id   = azapi_resource.vm_from_disk_trusted.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
{
  "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -Command \"& { Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -match 'Remote Desktop Services|Remote Desktop Agent Boot Loader' } | ForEach-Object { $_.Uninstall() } }\""
}
SETTINGS
}
  








