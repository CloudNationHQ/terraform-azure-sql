moved {
  from = data.azuread_user.db_admin
  to   = data.azuread_user.this
}

moved {
  from = data.azuread_group.db_admin
  to   = data.azuread_group.this
}

moved {
  from = data.azuread_service_principal.db_admin
  to   = data.azuread_service_principal.this
}

moved {
  from = azurerm_mssql_server.sql
  to   = azurerm_mssql_server.this
}

moved {
  from = azurerm_mssql_server_transparent_data_encryption.tde
  to   = azurerm_mssql_server_transparent_data_encryption.this
}

moved {
  from = azurerm_mssql_virtual_network_rule.vnetrule
  to   = azurerm_mssql_virtual_network_rule.this
}

moved {
  from = azurerm_mssql_firewall_rule.firewallrule
  to   = azurerm_mssql_firewall_rule.this
}

moved {
  from = azurerm_mssql_elasticpool.elasticpool
  to   = azurerm_mssql_elasticpool.this
}

moved {
  from = azurerm_mssql_database.database
  to   = azurerm_mssql_database.this
}
