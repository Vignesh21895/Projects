variable "source_vm_name" {
  description = "Name of the source virtual machine"
  type        = string
}

variable "source_resource_group_name" {
  description = "Resource group of the source VM"
  type        = string
}

variable "source_os_disk_id" {
  description = "OS Disk ID of the source VM (if not using lookup)"
  type        = string
  default     = null
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "new_vm_name" {
  description = "Name of the new cloned VM"
  type        = string
}

variable "new_resource_group_name" {
  description = "Resource group for the new VM"
  type        = string
}

variable "vm_size" {
  description = "Size of the new virtual machine"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "admin_username" {
  description = "Admin username for the new VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the new VM"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default = {
    environment = "dev"
    project     = "vm-clone"
  }
}
