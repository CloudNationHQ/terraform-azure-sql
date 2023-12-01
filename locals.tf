locals {
  db = flatten([
    for db_key, db in try(var.sql.databases, {}) : {
      db_key          = db_key
      name            = try(db.name, join("-", [var.naming.mssql_database, db_key]))
      server_id       = azurerm_mssql_server.sql.id
      collation       = try(db.collation, "SQL_Latin1_General_CP1_CI_AS")
      max_size_gb     = try(db.max_size_gb, 100)
      read_scale      = try(db.read_scale, false)
      zone_redundant  = try(db.zone_redundant, false)
      sku             = try(db.sku, "S0")
      elasticpool     = try(db.elasticpool, null)
      elastic_pool_id = try(db.elasticpool, null) != null ? azurerm_mssql_elasticpool.elasticpool[db.elasticpool].id : null
    }
  ])
}

locals {
  ep = flatten([
    for ep_key, ep in try(var.sql.elasticpools, {}) : {
      ep_key         = ep_key
      name           = try(ep.name, join("-", [var.naming.mssql_elasticpool, ep_key]))
      server_name    = azurerm_mssql_server.sql.name
      license_type   = try(ep.license_type, "LicenseIncluded")
      max_size_gb    = try(ep.max_size_gb, 4)
      zone_redundant = try(ep.zone_redundant, false)

      sku = {
        name     = try(ep.sku.name, "StandardPool")
        tier     = try(ep.sku.tier, "Standard")
        capacity = try(ep.sku.capacity, 200)
      }

      per_database_settings = {
        min_capacity = try(ep.per_database_settings.min_capacity, 0)
        max_capacity = try(ep.per_database_settings.max_capacity, 10)
      }
    }
  ])
}
