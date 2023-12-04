# mysql server
resource "azurerm_mssql_server" "sql" {
  name                                 = var.instance.name
  resource_group_name                  = var.instance.resourcegroup
  location                             = var.instance.location
  version                              = try(var.instance.version, "12.0")
  public_network_access_enabled        = try(var.instance.public_access, false)
  administrator_login                  = try(var.instance.admin, "adminLogin")
  administrator_login_password         = var.instance.password
  connection_policy                    = try(var.instance.connection_policy, "Default")
  minimum_tls_version                  = try(var.instance.minimum_tls_version, "1.2")
  outbound_network_restriction_enabled = try(var.instance.outbound_network_restriction_enabled, false)

  identity {
    type = "SystemAssigned"
  }

  dynamic "azuread_administrator" {
    for_each = try(var.instance.azuread_administrator, null) != null ? { admin = var.instance.azuread_administrator } : {}
    content {
      login_username              = try(azuread_administrator.value.login_username, null)
      object_id                   = try(azuread_administrator.value.object_id, null)
      azuread_authentication_only = try(azuread_administrator.value.azuread_authentication_only, null)
    }
  }
}

# network rules
resource "azurerm_mssql_virtual_network_rule" "vnetrule" {
  for_each = lookup(var.instance, "network_rules", {}) != null ? lookup(var.instance, "network_rules", {}) : {}

  name                                 = "rule-${each.key}"
  server_id                            = azurerm_mssql_server.sql.id
  subnet_id                            = each.value.subnet_id
  ignore_missing_vnet_service_endpoint = try(each.value.ignore_missing_vnet_service_endpoint, false)
}

# firewall rules
resource "azurerm_mssql_firewall_rule" "firewallrule" {
  for_each = lookup(var.instance, "fw_rules", {}) != null ? lookup(var.instance, "fw_rules", {}) : {}

  name             = "fwrule-${each.key}"
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

# elastic pool
resource "azurerm_mssql_elasticpool" "elasticpool" {
  for_each = {
    for ep in local.ep : ep.ep_key => ep
  }

  name                = each.value.name
  resource_group_name = var.instance.resourcegroup
  location            = var.instance.location
  server_name         = each.value.server_name
  license_type        = each.value.license_type
  max_size_gb         = each.value.max_size_gb
  zone_redundant      = each.value.zone_redundant

  sku {
    name     = each.value.sku
    tier     = each.value.tier
    capacity = each.value.capacity
  }

  per_database_settings {
    min_capacity = each.value.per_database_settings.min_capacity
    max_capacity = each.value.per_database_settings.max_capacity
  }
}

# databases
resource "azurerm_mssql_database" "database" {
  for_each = {
    for db in local.db : db.db_key => db
  }

  name            = each.value.name
  server_id       = each.value.server_id
  collation       = each.value.collation
  max_size_gb     = each.value.max_size_gb
  read_scale      = each.value.read_scale
  zone_redundant  = each.value.zone_redundant
  sku_name        = each.value.sku
  elastic_pool_id = each.value.elastic_pool_id
}

# databases elastic pool
resource "azurerm_mssql_database" "database_ep" {
  for_each = {
    for db in local.db : db.db_key => db if db.elasticpool != null
  }

  name            = each.value.name
  server_id       = each.value.server_id
  collation       = each.value.collation
  max_size_gb     = each.value.max_size_gb
  read_scale      = each.value.read_scale
  zone_redundant  = each.value.zone_redundant
  sku_name        = each.value.sku
  elastic_pool_id = azurerm_mssql_elasticpool.elasticpool[each.value.elasticpool].id
}

