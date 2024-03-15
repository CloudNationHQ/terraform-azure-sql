This example details a sql server setup with a private endpoint, enhancing security by restricting data access to a private network.

## Usage: private endpoint

```hcl
module "privatelink" {
  source  = "cloudnationhq/pe/azure"
  version = "~> 0.6"

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  endpoints = local.endpoints
}
```

The module uses the below locals for configuration:

```hcl
locals {
  endpoints = {
    vault = {
      name                           = module.naming.private_endpoint.name
      subnet_id                      = module.network.subnets.sn1.id
      private_connection_resource_id = module.sql.server.id
      private_dns_zone_ids           = [module.private_dns.zones.sql.id]
      subresource_names              = ["SqlServer"]
    }
  }
}
```
