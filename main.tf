# mysql server
resource "azurerm_mssql_server" "sql" {
  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.instance, "location", null
    ), var.location
  )

  name                                         = var.instance.name
  version                                      = var.instance.version
  public_network_access_enabled                = var.instance.public_network_access_enabled
  primary_user_assigned_identity_id            = var.instance.primary_user_assigned_identity_id
  administrator_login                          = var.instance.administrator_login
  administrator_login_password                 = var.instance.administrator_login_password
  administrator_login_password_wo              = var.instance.administrator_login_password_wo
  administrator_login_password_wo_version      = var.instance.administrator_login_password_wo_version
  connection_policy                            = var.instance.connection_policy
  express_vulnerability_assessment_enabled     = var.instance.express_vulnerability_assessment_enabled
  minimum_tls_version                          = var.instance.minimum_tls_version
  outbound_network_restriction_enabled         = var.instance.outbound_network_restriction_enabled
  transparent_data_encryption_key_vault_key_id = var.instance.transparent_data_encryption_key_vault_key_id

  tags = coalesce(
    var.instance.tags, var.tags
  )

  dynamic "identity" {
    for_each = lookup(var.instance, "identity", null) != null ? [var.instance.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "azuread_administrator" {
    for_each = try(var.instance.azuread_administrator, null) != null ? { admin = var.instance.azuread_administrator } : {}

    content {
      login_username              = azuread_administrator.value.login_username
      object_id                   = azuread_administrator.value.object_id
      tenant_id                   = azuread_administrator.value.tenant_id
      azuread_authentication_only = azuread_administrator.value.azuread_authentication_only
    }
  }
}

# network rules
resource "azurerm_mssql_virtual_network_rule" "vnetrule" {
  for_each = lookup(var.instance, "network_rules", {}) != null ? lookup(var.instance, "network_rules", {}) : {}

  name                                 = "rule-${each.key}"
  server_id                            = azurerm_mssql_server.sql.id
  subnet_id                            = each.value.subnet_id
  ignore_missing_vnet_service_endpoint = each.value.ignore_missing_vnet_service_endpoint
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
  for_each = try(
    var.instance.elasticpools, {}
  )

  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(
      var.instance, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.name, join("-", [var.naming.mssql_elasticpool, each.key])
  )

  server_name                    = azurerm_mssql_server.sql.name
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
  for_each = try(
    var.instance.databases, {}
  )

  name = coalesce(
    each.value.name, join("-", [var.naming.mssql_database, each.key])
  )

  server_id                                                  = azurerm_mssql_server.sql.id
  collation                                                  = each.value.collation
  max_size_gb                                                = each.value.max_size_gb
  read_scale                                                 = each.value.read_scale
  zone_redundant                                             = each.value.zone_redundant
  sku_name                                                   = each.value.elasticpool == null ? each.value.sku : null
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
  restore_long_term_retention_backup_id                      = each.value.restore_long_term_retention_backup_id
  elastic_pool_id                                            = each.value.elasticpool == null ? null : azurerm_mssql_elasticpool.elasticpool[each.value.elasticpool].id

  tags = coalesce(
    each.value.tags, var.instance.tags, var.tags
  )

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
      state                      = threat_detection_policy.value.state
      disabled_alerts            = threat_detection_policy.value.disabled_alerts
      email_account_admins       = threat_detection_policy.value.email_account_admins
      email_addresses            = threat_detection_policy.value.email_addresses
      retention_days             = threat_detection_policy.value.retention_days
      storage_account_access_key = threat_detection_policy.value.storage_account_access_key
      storage_endpoint           = threat_detection_policy.value.storage_endpoint
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = each.value.long_term_retention_policy != null ? [each.value.long_term_retention_policy] : []

    content {
      weekly_retention  = long_term_retention_policy.value.weekly_retention
      monthly_retention = long_term_retention_policy.value.monthly_retention
      yearly_retention  = long_term_retention_policy.value.yearly_retention
      week_of_year      = long_term_retention_policy.value.week_of_year
    }
  }

  dynamic "short_term_retention_policy" {
    for_each = each.value.short_term_retention_policy != null ? [each.value.short_term_retention_policy] : []

    content {
      retention_days           = short_term_retention_policy.value.retention_days
      backup_interval_in_hours = short_term_retention_policy.value.backup_interval_in_hours
    }
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}
