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
