locals {
  instance = {
    name                          = module.naming.mssql_server.name_unique
    location                      = module.rg.groups.demo.location
    resource_group                = module.rg.groups.demo.name
    administrator_login_password  = module.kv.secrets.sql.value
    public_network_access_enabled = true

    databases = {
      user = {
        max_size_gb = 50
        sku         = "ElasticPool"
        elasticpool = "appsvc"
      }
      orders = {
        max_size_gb = 150
      }
    }

    elasticpools = {
      appsvc = {
        max_size_gb = 50
      }
    }

    fw_rules = {
      sales = {
        start_ip_address = "10.20.30.1"
        end_ip_address   = "10.20.30.255"
      }
    }

    identity = {
      type = "SystemAssigned, UserAssigned"
    }
  }
}
