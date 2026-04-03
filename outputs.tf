output "server" {
  description = "contains all sql server details"
  value       = azurerm_mssql_server.sql
}

output "elasticpools" {
  description = "contains elastic pools"
  value       = azurerm_mssql_elasticpool.elasticpool
}

output "databases" {
  description = "contains databases"
  value       = azurerm_mssql_database.database
}

output "tde" {
  description = "contains transparent data encryption details"
  value       = azurerm_mssql_server_transparent_data_encryption.tde
}

output "network_rules" {
  description = "contains virtual network rules"
  value       = azurerm_mssql_virtual_network_rule.vnetrule
}

output "fw_rules" {
  description = "contains firewall rules"
  value       = azurerm_mssql_firewall_rule.firewallrule
}