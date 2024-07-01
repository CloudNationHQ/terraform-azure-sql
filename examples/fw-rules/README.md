This example demonstrates configuring firewall rules for secure access management.

## Usage

```hcl
module "sql" {
  source  = "cloudnationhq/sql/azure"
  version = "~> 0.9"

  naming = local.naming

  instance = {
    name          = module.naming.mssql_server.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    password      = module.kv.secrets.sql.value
    public_access = true

    fw_rules = {
      sales = {
        start_ip_address = "10.20.30.1"
        end_ip_address   = "10.20.30.255"
      }
      hr = {
        start_ip_address = "10.20.31.1"
        end_ip_address   = "10.20.31.255"
      }
    }
  }
}
```
