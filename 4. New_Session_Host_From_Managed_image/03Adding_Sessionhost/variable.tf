# Azure subscription ID
variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}
variable "location" {
  description = "Azure location (e.g. uksouth)"
  type        = string
}
# AVD Resource Group
variable "avd_rg" {
  description = "Name of the Azure resource group for AVD"
  type        = string
}

# Number of VMs to create
variable "vm_count" {
  description = "Number of session host VMs to deploy"
  type        = number
}

variable "vm_size" {
  description = "Size of the session host VMs"
  type        = string
}
# Shared Image Gallery details
variable "sig_name" {
  description = "Name of the Shared Image Gallery"
  type        = string
}

# Resource Group containing the SIG
variable "sig_rg" {
  description = "Resource Group containing the Shared Image Gallery"
  type        = string
}

variable "sig_image_name" {
  description = "Name of the image inside the Shared Image Gallery"
  type        = string
}

# Networking
variable "subnet_name" {
  description = "Subnet name where the session hosts will be placed"
  type        = string
}

variable "vnet_name" {
  description = "Virtual network name"
  type        = string
}

variable "vnet_rg" {
  description = "Resource Group containing the Virtual Network"
  type        = string
}

# AVD Host Pool details
variable "hostpool_name" {
  description = "Name of the AVD Host Pool"
  type        = string
}

variable "registration_token" {
  description = "Registration token for the AVD host pool"
  type        = string
  sensitive   = true
}

# Domain Join
variable "domain_name" {
  description = "Domain to join (e.g., cloud.franklins.org.uk)"
  type        = string
}

variable "domain_user" {
  description = "Domain join UPN (e.g., irisadmin@franklins.org.uk)"
  type        = string
}

variable "domain_password" {
  description = "Domain join password"
  type        = string
  sensitive   = true
}

# Local admin credentials
variable "local_admin_username" {
  description = "Local administrator username for session hosts"
  type        = string
  default     = "AVDAdmin"
}

variable "local_admin_password" {
  description = "Local administrator password for session hosts"
  type        = string
  sensitive   = true
}
