# mysql server
resource "azurerm_mssql_server" "sql" {
  name                                         = var.instance.name
  resource_group_name                          = coalesce(lookup(var.instance, "resource_group", null), var.resource_group)
  location                                     = coalesce(lookup(var.instance, "location", null), var.location)
  version                                      = try(var.instance.version, "12.0")
  public_network_access_enabled                = try(var.instance.public_network_access_enabled, true)
  primary_user_assigned_identity_id            = try(var.instance.primary_user_assigned_identity_id, null)
  administrator_login                          = try(var.instance.administrator_login, "adminLogin")
  administrator_login_password                 = try(var.instance.administrator_login_password, null)
  administrator_login_password_wo              = try(var.instance.administrator_login_password_wo, null)
  administrator_login_password_wo_version      = try(var.instance.administrator_login_password_wo_version, null)
  connection_policy                            = try(var.instance.connection_policy, "Default")
  express_vulnerability_assessment_enabled     = try(var.instance.express_vulnerability_assessment_enabled, false)
  minimum_tls_version                          = try(var.instance.minimum_tls_version, "1.2")
  outbound_network_restriction_enabled         = try(var.instance.outbound_network_restriction_enabled, false)
  transparent_data_encryption_key_vault_key_id = try(var.instance.transparent_data_encryption_key_vault_key_id, null)
  tags                                         = try(var.instance.tags, var.tags, null)

  dynamic "identity" {
    for_each = contains(keys(var.instance), "identity") ? [var.instance.identity] : []

    content {
      type = identity.value.type
      identity_ids = contains(["UserAssigned", "SystemAssigned, UserAssigned"], identity.value.type) ? concat(
        try([azurerm_user_assigned_identity.identity["identity"].id], []),
        try(lookup(identity.value, "identity_ids", []), [])
      ) : []
    }
  }

  dynamic "azuread_administrator" {
    for_each = try(var.instance.azuread_administrator, null) != null ? { admin = var.instance.azuread_administrator } : {}
    content {
      login_username              = try(azuread_administrator.value.login_username, null)
      object_id                   = try(azuread_administrator.value.object_id, null)
      tenant_id                   = try(azuread_administrator.value.tenant_id, null)
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
  resource_group_name            = coalesce(lookup(var.instance, "resource_group", null), var.resource_group)
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
  create_mode                                                = each.value.create_mode != null && each.value.import == null ? each.value.create_mode : null
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
  recovery_point_id                                          = each.value.recovery_point_id
  restore_point_in_time                                      = each.value.restore_point_in_time
  auto_pause_delay_in_minutes                                = each.value.auto_pause_delay_in_minutes
  creation_source_database_id                                = each.value.creation_source_database_id
  restore_dropped_database_id                                = each.value.restore_dropped_database_id
  secondary_type                                             = each.value.secondary_type
  tags                                                       = each.value.tags

  dynamic "import" {
    for_each = each.value.import != null ? [each.value.import] : []

    content {
      storage_uri                  = import.value.storage_uri
      storage_key                  = import.value.storage_key
      storage_key_type             = import.value.storage_key_type
      administrator_login          = import.value.administrator_login
      administrator_login_password = import.value.administrator_login_password
      authentication_type          = import.value.authentication_type
      storage_account_id           = try(import.value.storage_account_id, null)
    }
  }

  dynamic "threat_detection_policy" {
    for_each = each.value.threat_detection_policy != null ? [each.value.threat_detection_policy] : []

    content {
      state                      = try(threat_detection_policy.value.state, "Disabled")
      disabled_alerts            = try(threat_detection_policy.value.disabled_alerts, null)
      email_account_admins       = try(threat_detection_policy.value.email_account_admins, "Disabled")
      email_addresses            = try(threat_detection_policy.value.email_addresses, null)
      retention_days             = try(threat_detection_policy.value.retention_days, null)
      storage_account_access_key = try(threat_detection_policy.value.storage_account_access_key, null)
      storage_endpoint           = try(threat_detection_policy.value.storage_endpoint, null)
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = each.value.long_term_retention_policy != null ? [each.value.long_term_retention_policy] : []

    content {
      weekly_retention  = try(long_term_retention_policy.value.weekly_retention, null)
      monthly_retention = try(long_term_retention_policy.value.monthly_retention, null)
      yearly_retention  = try(long_term_retention_policy.value.yearly_retention, null)
      week_of_year      = try(long_term_retention_policy.value.week_of_year, null)
    }
  }

  dynamic "short_term_retention_policy" {
    for_each = each.value.short_term_retention_policy != null ? [each.value.short_term_retention_policy] : []

    content {
      retention_days           = try(short_term_retention_policy.value.retention_days, null)
      backup_interval_in_hours = try(short_term_retention_policy.value.backup_interval_in_hours, 12)
    }
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []

    content {
      type         = "UserAssigned"
      identity_ids = identity.value.identity_ids
    }
  }
}

resource "azurerm_user_assigned_identity" "identity" {
  for_each = contains(["UserAssigned", "SystemAssigned, UserAssigned"], try(var.instance.identity.type, "")) ? { "identity" = var.instance.identity } : {}

  name                = try(each.value.name, "uai-${var.instance.name}")
  resource_group_name = coalesce(lookup(var.instance, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(var.instance, "location", null), var.location)
  tags                = try(each.value.tags, var.tags, null)
}
