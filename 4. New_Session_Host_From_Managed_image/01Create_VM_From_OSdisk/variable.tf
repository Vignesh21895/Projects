variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region for snapshot, disk, and VM (e.g., UK South)"
  type        = string
}

variable "source_rg_name" {
  description = "Resource group of the source VM"
  type        = string
}

variable "source_vm_name" {
  description = "Name of the existing VM to snapshot (OS disk will be used)"
  type        = string
}

variable "source_os_disk_name" {
  description = "The name of the source VM's OS disk"
  type        = string
}

variable "buildimage_rg_name" {
  description = "Destination resource group where snapshot, disk, and VM will be created (existing RG)"
  type        = string
  default     = "buildimageRG"
}

variable "customer_name" {
  description = "Tag: Customer Name"
  type        = string
}

variable "customer_reference" {
  description = "Tag: Customer Reference"
  type        = string
}

variable "vm_size" {
  description = "Size for the created VM"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "Admin username for the new VM (required by provider)"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for the new VM (required by provider). Use secret management in real deployments."
  type        = string
  sensitive   = true
  default     = "ChangeMe123!"
}

variable "add_tags_to_nic" {
  description = "Whether to add tags to NIC"
  type        = bool
  default     = true
}
