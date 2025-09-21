output "snapshot_name" {
  description = "Name of the created snapshot"
  value       = azurerm_snapshot.os_snapshot.name
}

output "snapshot_id" {
  description = "ID of the created snapshot"
  value       = azurerm_snapshot.os_snapshot.id
}

output "managed_disk_name" {
  description = "Name of the created managed disk"
  value       = azurerm_managed_disk.os_managed_disk.name
}

output "managed_disk_id" {
  description = "ID of the created managed disk"
  value       = azurerm_managed_disk.os_managed_disk.id
}

output "vm_from_disk_name" {
  description = "Name of the VM created from the OS disk"
  value       = azapi_resource.vm_from_disk_trusted.name
}

output "vm_from_disk_id" {
  description = "ID of the VM created from the OS disk"
  value       = azapi_resource.vm_from_disk_trusted.id
}
