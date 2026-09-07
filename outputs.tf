output "mssql_server" {
  description = "contains all sql server details"
  value       = azurerm_mssql_server.this
}

output "elasticpools" {
  description = "contains elastic pools"
  value       = azurerm_mssql_elasticpool.this
}

output "databases" {
  description = "contains databases"
  value       = azurerm_mssql_database.this
}

output "tde" {
  description = "contains transparent data encryption details"
  value       = azurerm_mssql_server_transparent_data_encryption.this
}

output "network_rules" {
  description = "contains virtual network rules"
  value       = azurerm_mssql_virtual_network_rule.this
}

output "fw_rules" {
  description = "contains firewall rules"
  value       = azurerm_mssql_firewall_rule.this
}

output "extended_auditing_policy" {
  description = "contains extended auditing policy details"
  value       = azurerm_mssql_server_extended_auditing_policy.this
  sensitive   = true
}