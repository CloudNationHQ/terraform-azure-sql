# mysql server
resource "azurerm_mssql_server" "sql" {
  name                                         = var.instance.name
  resource_group_name                          = coalesce(lookup(var.instance, "resourcegroup", null), var.resourcegroup)
  location                                     = coalesce(lookup(var.instance, "location", null), var.location)
  version                                      = try(var.instance.version, "12.0")
  public_network_access_enabled                = try(var.instance.public_network_access_enabled, false)
  administrator_login                          = try(var.instance.administrator_login, "adminLogin")
  administrator_login_password                 = var.instance.administrator_login_password
  connection_policy                            = try(var.instance.connection_policy, "Default")
  minimum_tls_version                          = try(var.instance.minimum_tls_version, "1.2")
  outbound_network_restriction_enabled         = try(var.instance.outbound_network_restriction_enabled, false)
  transparent_data_encryption_key_vault_key_id = try(var.instance.transparent_data_encryption_key_vault_key_id, null)
  tags                                         = try(var.instance.tags, var.tags, null)

  dynamic "identity" {
    for_each = [lookup(var.instance, "identity", { type = "SystemAssigned", identity_ids = [] })]

    content {
      type         = identity.value.type
      identity_ids = var.instance.identity.type == "UserAssigned" || var.instance.identity.type == "SystemAssigned, UserAssigned" ? concat([azurerm_user_assigned_identity.identity["identity"].id], lookup(var.instance.identity, "identity_ids", [])) : []
    }
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

  name                           = each.value.name
  resource_group_name            = coalesce(lookup(var.instance, "resourcegroup", null), var.resourcegroup)
  location                       = coalesce(lookup(var.instance, "location", null), var.location)
  server_name                    = each.value.server_name
  license_type                   = each.value.license_type
  max_size_gb                    = each.value.max_size_gb
  zone_redundant                 = each.value.zone_redundant
  enclave_type                   = each.value.enclave_type
  maintenance_configuration_name = each.value.maintenance_configuration_name
  max_size_bytes                 = each.value.max_size_bytes
  tags                           = each.value.tags

  sku {
    name     = each.value.sku
    tier     = each.value.tier
    capacity = each.value.capacity
    family   = each.value.family
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

  name                                                       = each.value.name
  server_id                                                  = each.value.server_id
  collation                                                  = each.value.collation
  max_size_gb                                                = each.value.max_size_gb
  read_scale                                                 = each.value.read_scale
  zone_redundant                                             = each.value.zone_redundant
  sku_name                                                   = each.value.sku != "ElasticPool" ? each.value.sku : null
  elastic_pool_id                                            = try(azurerm_mssql_elasticpool.elasticpool[each.value.elasticpool].id, null)
  min_capacity                                               = each.value.min_capacity
  create_mode                                                = each.value.create_mode
  license_type                                               = each.value.license_type
  ledger_enabled                                             = each.value.ledger_enabled
  geo_backup_enabled                                         = each.value.geo_backup_enabled
  sample_name                                                = each.value.sample_name
  read_replica_count                                         = each.value.read_replica_count
  storage_account_type                                       = each.value.storage_account_type
  transparent_data_encryption_enabled                        = each.value.transparent_data_encryption_enabled
  enclave_type                                               = each.value.enclave_type
  transparent_data_encryption_key_vault_key_id               = each.value.transparent_data_encryption_key_vault_key_id
  transparent_data_encryption_key_automatic_rotation_enabled = each.value.transparent_data_encryption_key_automatic_rotation_enabled
  maintenance_configuration_name                             = each.value.maintenance_configuration_name
  recover_database_id                                        = each.value.recover_database_id
  restore_point_in_time                                      = each.value.restore_point_in_time
  auto_pause_delay_in_minutes                                = each.value.auto_pause_delay_in_minutes
  creation_source_database_id                                = each.value.creation_source_database_id
  restore_dropped_database_id                                = each.value.restore_dropped_database_id
  tags                                                       = each.value.tags
}

resource "azurerm_user_assigned_identity" "identity" {
  for_each = contains(["UserAssigned", "SystemAssigned, UserAssigned"], try(var.instance.identity.type, "")) ? { "identity" = var.instance.identity } : {}

  name                = try(each.value.name, "uai-${var.instance.name}")
  resource_group_name = coalesce(lookup(var.instance, "resourcegroup", null), var.resourcegroup)
  location            = coalesce(lookup(var.instance, "location", null), var.location)
  tags                = try(each.value.tags, var.tags, null)
}
