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


