This example shows a complete implementation of this module, including databases, elastic pools, firewall rules and virtual network rules.

## Usage

```hcl
sql = {
    name                          = module.naming.sql_server.name_unique
    location                      = module.rg.groups.demo.location
    resourcegroup                 = module.rg.groups.demo.name
    version                       = "12.0"
    administrator_login           = "adminJordy"
    administrator_login_password  = module.kv.secrets.secret1.value
    public_network_access_enabled = true

    azuread_administrator = {
      login_username              = "adminWouter"
      object_id                   = "12345678-1234-9876-4563-123456789012"
      azuread_authentication_only = false
    }

     virtual_network_rules = {
       rule1 = {
         name      = "vnetrule1"
         subnet_id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/rg-lz-network-shared-weu-001/providers/Microsoft.Network/virtualNetworks/vnet-spoke-shared-weu-001/subnets/aks-subnet-shared-weu-001"
       }
       rule2 = {
         name      = "vnetrule2"
         subnet_id = module.network.subnets.sql.id
       }
     }

    firewall_rules = {
      rule1 = {
        name             = "FirewallRule1"
        start_ip_address = "10.0.17.62"
        end_ip_address   = "10.0.18.62"
      },
      rule2 = {
        name             = "FirewallRule2"
        start_ip_address = "11.0.17.62"
        end_ip_address   = "11.0.18.62"
      }
    }

    databases = {
      db1 = {
        name           = "db1"
        collation      = "SQL_Latin1_General_CP1_CI_AS"
        max_size_gb    = 50
        read_scale     = false
        zone_redundant = false
        sku_name       = "S0"
      },
      db2 = {
        name = "db2"
      }
    }

    elasticpool = {
      pool1 = {
        name = "pool1"
        sku = {
          name     = "StandardPool"
          tier     = "Standard"
          capacity = 50
        }
        max_size_gb    = 50
        zone_redundant = false
        license_type   = "LicenseIncluded"

        per_database_settings = {
          min_capacity = 0
          max_capacity = 50
        }
      }
      pool2 = {
        name = "pool2"
        sku = {
          name     = "BasicPool"
          tier     = "Basic"
          capacity = 50
        }
        max_size_gb    = 4.8828125
        zone_redundant = false
        per_database_settings = {
          min_capacity = 0
          max_capacity = 5
        }
      }
    }
  }
}

```
