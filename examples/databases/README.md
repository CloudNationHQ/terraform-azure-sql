This example illustrates configuring multiple sql server databases.

## Usage

```hcl
module "sql" {
  source  = "cloudnationhq/sql/azure"
  version = "~> 0.9"

  naming = local.naming

  instance = {
    name          = module.naming.sql_server.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    password      = module.kv.secrets.sql.value

    databases = {
      user   = { max_size_gb = 50 }
      orders = { max_size_gb = 150 }
    }
  }
}
```

In situations where several databases reference the same elastic pool, the following configuration can be employed:

```hcl
module "sql" {
  source  = "cloudnationhq/sql/azure"
  version = "~> 0.6"

  naming = local.naming

  instance = {
    name          = module.naming.mssql_server.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    password      = module.kv.secrets.sql.value

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
```
