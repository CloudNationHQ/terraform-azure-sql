This example showcases setting up multiple elastic pools.

## Usage

```hcl
module "sql" {
  source  = "cloudnationhq/sql/azure"
  version = "~> 0.8"

  naming = local.naming

  instance = {
    name          = module.naming.mssql_server.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    password      = module.kv.secrets.sql.value


    elasticpool = {
      appsvc = { max_size_gb = 50 }
      webapp = { max_size_gb = 100 }
    }
  }
}
```
