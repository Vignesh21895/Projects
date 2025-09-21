variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "vm_name" {
  description = "Name of the generalized VM"
  type        = string
}

variable "vm_rg_name" {
  description = "Resource group where the VM exists"
  type        = string
}

variable "location" {
  description = "Azure location (e.g. uksouth)"
  type        = string
}

variable "os_type" {
  description = "OS type of the VM (Windows or Linux)"
  type        = string
}

variable "gallery_name" {
  description = "Name of the existing Compute Gallery"
  type        = string
}

variable "gallery_rg_name" {
  description = "Resource group of the Compute Gallery"
  type        = string
}

variable "image_definition_name" {
  description = "Name of the existing image definition in the gallery"
  type        = string
}

variable "customer_name" {
  description = "Customer name for tagging"
  type        = string
}

variable "customer_reference" {
  description = "Customer reference ID for tagging"
  type        = string
}

# Version to be passed from CI (example: 250920.0315.07)
variable "image_version" {
  description = "Compute Gallery image version in X.Y.Z format (e.g., YYMMDD.HHmm.ss)"
  type        = string
}

