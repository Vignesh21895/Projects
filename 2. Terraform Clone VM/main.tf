terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Get the source VM
data "azurerm_virtual_machine" "source_vm" {
  name                = var.source_vm_name
  resource_group_name = var.source_resource_group_name
}

# Get the OS Disk by name
data "azurerm_managed_disk" "source_os_disk" {
  name                = data.azurerm_virtual_machine.source_vm.storage_os_disk_name
  resource_group_name = var.source_resource_group_name
}

locals {
  source_os_disk_id = (
    var.source_os_disk_id != null && var.source_os_disk_id != ""
  ) ? var.source_os_disk_id : data.azurerm_managed_disk.source_os_disk.id
}

# Example VNet (only created if var.create_network = true)
resource "azurerm_virtual_network" "vnet" {
  count               = var.create_network ? 1 : 0
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.target.location
  resource_group_name = azurerm_resource_group.target.name
  tags                = var.tags
}

# Example Subnet (only created if var.create_network = true)
resource "azurerm_subnet" "subnet" {
  count                = var.create_network ? 1 : 0
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.target.name
  virtual_network_name = azurerm_virtual_network.vnet[0].name
  address_prefixes     = [var.subnet_prefix]
}

# Public IP
resource "azurerm_public_ip" "pip" {
  name                = "${var.new_vm_name}-pip"
  location            = azurerm_resource_group.target.location
  resource_group_name = azurerm_resource_group.target.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  tags                = var.tags
}
