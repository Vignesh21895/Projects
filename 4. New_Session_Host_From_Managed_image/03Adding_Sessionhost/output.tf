output "sessionhost_names" {
  description = "Names of the deployed session hosts"
  value       = azurerm_windows_virtual_machine.sessionhost[*].name
}

output "sessionhost_private_ips" {
  description = "Private IPs of the deployed session hosts"
  value       = [
    for nic in azurerm_network_interface.sessionhost_nic : nic.ip_configuration[0].private_ip_address
  ]
}

output "resource_group_name" {
  description = "Resource group where session hosts are deployed"
  value       = azurerm_resource_group.rg.name
}

output "avd_hostpool" {
  description = "AVD Host Pool name where session hosts are registered"
  value       = var.hostpool_name
}
