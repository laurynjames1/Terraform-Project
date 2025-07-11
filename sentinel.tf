resource "azurerm_log_analytics_workspace" "sentinel_law" {
  name                = "ltc-law"
  location            = azurerm_resource_group.ltc-rg.location
  resource_group_name = azurerm_resource_group.ltc-rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  workspace_id = azurerm_log_analytics_workspace.sentinel_law.id
}

resource "azurerm_virtual_machine_extension" "oms_agent" {
  name                 = "OmsAgentForLinux"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm-03.id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "OmsAgentForLinux"
  type_handler_version = "1.13"

  settings = jsonencode({
    workspaceId = azurerm_log_analytics_workspace.sentinel_law.workspace_id
  })

  protected_settings = jsonencode({
    workspaceKey = azurerm_log_analytics_workspace.sentinel_law.primary_shared_key
  })
}
