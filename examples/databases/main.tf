module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name
      location = "northeurope"
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 2.0"

  naming = local.naming

  vault = {
    name           = module.naming.key_vault.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    secrets = {
      random_string = {
        sql = {
          length  = 24
          special = true
        }
      }
    }
  }
}

module "sql" {
  source  = "cloudnationhq/sql/azure"
  version = "~> 1.0"

  naming = local.naming

  instance = {
    name                         = module.naming.mssql_server.name_unique
    location                     = module.rg.groups.demo.location
    resource_group               = module.rg.groups.demo.name
    administrator_login_password = module.kv.secrets.sql.value

    databases = {
      user = {
        max_size_gb = 50
        sku         = "ElasticPool"
        elasticpool = "appsvc"

        short_term_retention_policy = {
          retention_days           = 8
          backup_interval_in_hours = 24
        }
      }
      orders = {
        max_size_gb = 150

        long_term_retention_policy = {
          weekly_retention          = "P1W"
          monthly_retention         = "P1M"
          yearly_retention          = "P1Y"
          immutable_backups_enabled = true
        }
      }
    }

    elasticpools = {
      appsvc = {
        max_size_gb = 50
      }
    }
  }
}
