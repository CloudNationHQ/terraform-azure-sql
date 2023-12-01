This example shows an implementation of this module focused on adding multiple elastic pools to the sql server.

## Usage

```hcl
module "sql" {
  source = "../../"

  naming = local.naming

  sql = {
    name          = module.naming.sql_server.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    password      = module.kv.secrets.sql.value


    elasticpool = {
      prod = { max_size_gb = 19.5312500 }
      dev  = { max_size_gb = 19.5312500 }
    }
  }
}
```
