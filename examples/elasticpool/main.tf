module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name
      location = "westeurope"
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 2.0"

  naming = local.naming

  vault = {
    name           = module.naming.key_vault.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

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
  version = "~> 1.0"

  naming = local.naming

  instance = {
    name                         = module.naming.mssql_server.name_unique
    location                     = module.rg.groups.demo.location
    resource_group               = module.rg.groups.demo.name
    administrator_login_password = module.kv.secrets.sql.value

    elasticpool = {
      appsvc = { max_size_gb = 50 }
      webapp = { max_size_gb = 100 }
    }
  }
}
