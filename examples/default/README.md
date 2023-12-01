This example shows a very simple implementation of this module, showcasing the easiest way to deploy the module.

## Usage

```hcl
module "sql" {
  source  = "cloudnationhq/sql/azure"
  version = "~> 0.1"

  sql = {
    name          = module.naming.sql_server.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    password      = module.kv.secrets.sql.value
  }
}
```
