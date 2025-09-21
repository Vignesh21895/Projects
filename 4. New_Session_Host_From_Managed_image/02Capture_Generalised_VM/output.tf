# outputs for the direct-from-VM flow

output "shared_image_version_id" {
  description = "ID of the created Shared Image Version"
  value       = azurerm_shared_image_version.new_version.id
}

output "shared_image_version_name" {
  description = "The name of the new image version created"
  value       = azurerm_shared_image_version.new_version.name
}

output "source_vm_id" {
  description = "ID of the generalized source VM used to build the image version"
  value       = data.azurerm_virtual_machine.generalized_vm.id
}