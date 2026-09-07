data "azuread_user" "this" {
  for_each = var.mssql_server.azuread_administrator != null && var.mssql_server.azuread_administrator.object_id == null && var.mssql_server.azuread_administrator.object_type == "User" ? { "this" = {} } : {}

  user_principal_name = var.mssql_server.azuread_administrator.login_username
}

data "azuread_group" "this" {
  for_each = var.mssql_server.azuread_administrator != null && var.mssql_server.azuread_administrator.object_id == null && var.mssql_server.azuread_administrator.object_type == "Group" ? { "this" = {} } : {}

  display_name = var.mssql_server.azuread_administrator.login_username
}

data "azuread_service_principal" "this" {
  for_each = var.mssql_server.azuread_administrator != null && var.mssql_server.azuread_administrator.object_id == null && var.mssql_server.azuread_administrator.object_type == "ServicePrincipal" ? { "this" = {} } : {}

  display_name = var.mssql_server.azuread_administrator.login_username
}

# mysql server
resource "azurerm_mssql_server" "this" {
  resource_group_name = coalesce(
    var.mssql_server.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.mssql_server.location, var.location
  )

  name                                         = var.mssql_server.name
  version                                      = var.mssql_server.version
  public_network_access_enabled                = var.mssql_server.public_network_access_enabled
  primary_user_assigned_identity_id            = var.mssql_server.primary_user_assigned_identity_id
  administrator_login_password                 = var.mssql_server.administrator_login_password
  administrator_login_password_wo              = var.mssql_server.administrator_login_password_wo
  administrator_login_password_wo_version      = var.mssql_server.administrator_login_password_wo_version
  connection_policy                            = var.mssql_server.connection_policy
  express_vulnerability_assessment_enabled     = var.mssql_server.express_vulnerability_assessment_enabled
  minimum_tls_version                          = var.mssql_server.minimum_tls_version
  outbound_network_restriction_enabled         = var.mssql_server.outbound_network_restriction_enabled
  transparent_data_encryption_key_vault_key_id = var.mssql_server.transparent_data_encryption_key_vault_key_id

  administrator_login = (
    var.mssql_server.administrator_login_password != null ||
    var.mssql_server.administrator_login_password_wo != null
  ) ? coalesce(var.mssql_server.administrator_login, "adminLogin") : null

  tags = coalesce(
    var.mssql_server.tags, var.tags
  )

  dynamic "identity" {
    for_each = var.mssql_server.identity != null ? { "this" = var.mssql_server.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "azuread_administrator" {
    for_each = var.mssql_server.azuread_administrator != null ? { admin = var.mssql_server.azuread_administrator } : {}

    content {
      login_username              = azuread_administrator.value.login_username
      tenant_id                   = azuread_administrator.value.tenant_id
      azuread_authentication_only = azuread_administrator.value.azuread_authentication_only

      object_id = coalesce(
        azuread_administrator.value.object_id,
        one(values(data.azuread_user.this)[*].object_id),
        one(values(data.azuread_group.this)[*].object_id),
        one(values(data.azuread_service_principal.this)[*].object_id),
      )
    }
  }
}

# extended auditing policy
resource "azurerm_mssql_server_extended_auditing_policy" "this" {
  for_each = var.mssql_server.extended_auditing_policy != null ? { this = var.mssql_server.extended_auditing_policy } : {}

  server_id                               = azurerm_mssql_server.this.id
  enabled                                 = each.value.enabled
  blob_storage_endpoint                   = each.value.blob_storage_endpoint
  storage_account_access_key              = each.value.storage_account_access_key
  storage_account_access_key_is_secondary = each.value.storage_account_access_key_is_secondary
  storage_account_subscription_id         = each.value.storage_account_subscription_id
  retention_in_days                       = each.value.retention_in_days
  log_monitoring_enabled                  = each.value.log_monitoring_enabled
  predicate_expression                    = each.value.predicate_expression
  audit_actions_and_groups                = each.value.audit_actions_and_groups
}

# transparent data encryption
resource "azurerm_mssql_server_transparent_data_encryption" "this" {
  for_each = var.mssql_server.transparent_data_encryption != null ? { this = {} } : {}

  server_id             = azurerm_mssql_server.this.id
  key_vault_key_id      = var.mssql_server.transparent_data_encryption.key_vault_key_id
  auto_rotation_enabled = var.mssql_server.transparent_data_encryption.auto_rotation_enabled
}

# network rules
resource "azurerm_mssql_virtual_network_rule" "this" {
  for_each = var.mssql_server.network_rules

  name = coalesce(
    each.value.name, each.key
  )

  server_id                            = azurerm_mssql_server.this.id
  subnet_id                            = each.value.subnet_id
  ignore_missing_vnet_service_endpoint = each.value.ignore_missing_vnet_service_endpoint
}

# firewall rules
resource "azurerm_mssql_firewall_rule" "this" {
  for_each = var.mssql_server.fw_rules

  name = coalesce(
    each.value.name, each.key
  )

  server_id        = azurerm_mssql_server.this.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

# elastic pool
resource "azurerm_mssql_elasticpool" "this" {
  for_each = var.mssql_server.elasticpools

  resource_group_name = coalesce(
    var.mssql_server.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.mssql_server.location, var.location
  )

  name = coalesce(
    each.value.name,
    each.key
  )

  server_name                     = azurerm_mssql_server.this.name
  license_type                    = each.value.license_type
  max_size_gb                     = each.value.max_size_gb
  zone_redundant                  = each.value.zone_redundant
  enclave_type                    = each.value.enclave_type
  maintenance_configuration_name  = each.value.maintenance_configuration_name
  max_size_bytes                  = each.value.max_size_bytes
  high_availability_replica_count = each.value.high_availability_replica_count
  tags                            = each.value.tags

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
resource "azurerm_mssql_database" "this" {
  for_each = var.mssql_server.databases

  name = coalesce(
    each.value.name, each.key
  )

  server_id                                                  = azurerm_mssql_server.this.id
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
  elastic_pool_id                                            = each.value.elasticpool == null ? null : azurerm_mssql_elasticpool.this[each.value.elasticpool].id

  tags = coalesce(
    each.value.tags, var.mssql_server.tags, var.tags
  )

  dynamic "import" {
    for_each = each.value.import != null ? { "this" = each.value.import } : {}

    content {
      storage_uri                  = import.value.storage_uri
      storage_key                  = import.value.storage_key
      storage_key_type             = import.value.storage_key_type
      administrator_login          = import.value.administrator_login
      administrator_login_password = import.value.administrator_login_password
      authentication_type          = import.value.authentication_type
      storage_account_id           = import.value.storage_account_id
    }
  }

  dynamic "threat_detection_policy" {
    for_each = each.value.threat_detection_policy != null ? { "this" = each.value.threat_detection_policy } : {}

    content {
      state                        = threat_detection_policy.value.state
      disabled_alerts              = threat_detection_policy.value.disabled_alerts
      email_account_admins_enabled = threat_detection_policy.value.email_account_admins_enabled
      email_addresses              = threat_detection_policy.value.email_addresses
      retention_days               = threat_detection_policy.value.retention_days
      storage_account_access_key   = threat_detection_policy.value.storage_account_access_key
      storage_endpoint             = threat_detection_policy.value.storage_endpoint
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = each.value.long_term_retention_policy != null ? { "this" = each.value.long_term_retention_policy } : {}

    content {
      weekly_retention  = long_term_retention_policy.value.weekly_retention
      monthly_retention = long_term_retention_policy.value.monthly_retention
      yearly_retention  = long_term_retention_policy.value.yearly_retention
      week_of_year      = long_term_retention_policy.value.week_of_year
    }
  }

  dynamic "short_term_retention_policy" {
    for_each = each.value.short_term_retention_policy != null ? { "this" = each.value.short_term_retention_policy } : {}

    content {
      retention_days           = short_term_retention_policy.value.retention_days
      backup_interval_in_hours = short_term_retention_policy.value.backup_interval_in_hours
    }
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? { "this" = each.value.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}
