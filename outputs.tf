output "resource_group_name" {
  value = azurerm_resource_group.ltc-rg.name
}

output "vm_private_ip" {
  description = "Private IP address of the virtual machine"
  value       = azurerm_network_interface.ltc-NIC.ip_configuration[10.30.1.10].private_ip_address
}

output "storage_account_name" {
  description = "Name of the storage account used for boot diagnostics"
  value       = azurerm_storage_account.ltc-storage.name
}

output "sentinel_workspace_id" {
  description = "Workspace ID for Azure Sentinel (Log Analytics)"
  value       = azurerm_log_analytics_workspace.sentinel_law.workspace_id
}

variable "admin_username" {
  default = "azureuser"
}
