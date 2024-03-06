locals {
  db = flatten([
    for db_key, db in try(var.instance.databases, {}) : {
      db_key                                                     = db_key
      name                                                       = try(db.name, join("-", [var.naming.mssql_database, db_key]))
      server_id                                                  = azurerm_mssql_server.sql.id
      collation                                                  = try(db.collation, "SQL_Latin1_General_CP1_CI_AS")
      max_size_gb                                                = try(db.max_size_gb, 100)
      read_scale                                                 = try(db.read_scale, false)
      zone_redundant                                             = try(db.zone_redundant, false)
      sku                                                        = try(db.sku, "S0")
      elasticpool                                                = try(db.elasticpool, null)
      elastic_pool_id                                            = try(db.elasticpool, null) != null ? azurerm_mssql_elasticpool.elasticpool[db.elasticpool].id : null
      min_capacity                                               = try(db.min_capacity, null)
      create_mode                                                = try(db.create_mode, "Default")
      license_type                                               = try(db.license_type, null)
      ledger_enabled                                             = try(db.ledger_enabled, false)
      geo_backup_enabled                                         = try(db.geo_backup_enabled, true)
      sample_name                                                = try(db.sample_name, null)
      read_replica_count                                         = try(db.read_replica_count, null)
      storage_account_type                                       = try(db.storage_account_type, null)
      transparent_data_encryption_enabled                        = try(db.transparent_data_encryption_enabled, true)
      enclave_type                                               = try(db.enclave_type, null)
      transparent_data_encryption_key_vault_key_id               = try(db.transparent_data_encryption_key_vault_key_id, null)
      transparent_data_encryption_key_automatic_rotation_enabled = try(db.transparent_data_encryption_key_automatic_rotation_enabled, null)
      maintenance_configuration_name                             = try(db.maintenance_configuration_name, null)
      recover_database_id                                        = try(db.recover_database_id, null)
      restore_point_in_time                                      = try(db.restore_point_in_time, null)
      auto_pause_delay_in_minutes                                = try(db.auto_pause_delay_in_minutes, null)
      creation_source_database_id                                = try(db.creation_source_database_id, null)
      restore_dropped_database_id                                = try(db.restore_dropped_database_id, null)
      tags                                                       = try(db.tags, var.tags, null)
    }
  ])
}

locals {
  ep = flatten([
    for ep_key, ep in try(var.instance.elasticpools, {}) : {
      ep_key                         = ep_key
      name                           = try(ep.name, join("-", [var.naming.mssql_elasticpool, ep_key]))
      server_name                    = azurerm_mssql_server.sql.name
      license_type                   = try(ep.license_type, "LicenseIncluded")
      max_size_gb                    = try(ep.max_size_gb, 4)
      zone_redundant                 = try(ep.zone_redundant, false)
      enclave_type                   = try(ep.enclave_type, null)
      maintenance_configuration_name = try(ep.maintenance_configuration_name, null)
      max_size_bytes                 = try(ep.max_size_bytes, null)
      sku                            = try(ep.sku, "StandardPool")
      tier                           = try(ep.tier, "Standard")
      capacity                       = try(ep.capacity, 200)
      family                         = try(ep.family, null)
      tags                           = try(ep.tags, var.tags, null)

      per_database_settings = {
        min_capacity = try(ep.per_database_settings.min_capacity, 0)
        max_capacity = try(ep.per_database_settings.max_capacity, 10)
      }
    }
  ])
}
