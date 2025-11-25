module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.25"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "germanywestcentral"
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 4.0"

  naming = local.naming

  vault = {
    name                = module.naming.key_vault.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

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
  version = "~> 2.0"

  naming = local.naming

  instance = {
    name                          = module.naming.mssql_server.name_unique
    location                      = module.rg.groups.demo.location
    resource_group_name           = module.rg.groups.demo.name
    administrator_login_password  = module.kv.secrets.sql.value
    public_network_access_enabled = true

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
