This example illustrates the default sql server setup, in its simplest form.

## Usage: default

```hcl
module "sql" {
  source  = "cloudnationhq/sql/azure"
  version = "~> 0.4"

  instance = {
    name          = module.naming.mssql_server.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    password      = module.kv.secrets.sql.value
  }
}
```

## Usage: multiple

Additionally, for certain scenarios, the example below highlights the ability to use multiple sql servers, enabling a broader setup.

```hcl
module "sql" {
  source = "cloudnationhq/sql/azure"
  version = "~> 0.1"

  for_each = local.sql

  naming = local.naming
  instance = each.value
}
```

The module uses a local to iterate, generating a storage account for each key.

```hcl
locals {
  sql = {
    sql1 = {
      name          = "sql-demo-dev-001"
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
      password      = module.kv.secrets.sql.value

      databases = {
        user = {
          max_size_gb = 50
          sku         = "ElasticPool"
          elasticpool = "appsvc"
        }
      }

      elasticpools = {
        appsvc = {
          max_size_gb = 50
        }
      }
    },
    sql2 = {
      name          = "sql-demo-dev-002"
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
      password      = module.kv.secrets.sql.value

      databases = {
        marketing = {
          max_size_gb = 150
        }
      }
    }
  }
}
```

The below maps resource types to their corresponding outputs from the naming module, ensuring consistent naming conventions across resources

```hcl
locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["key_vault_secret", "mssql_elasticpool", "mssql_database"]
}
```
