module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.32"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "germanywestcentral"
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 6.0"

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

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 5.0"

  storage = {
    name                = module.naming.storage_account.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "sql" {
  source  = "cloudnationhq/sql/azure"
  version = "~> 3.0"

  mssql_server = {
    name                         = module.naming.mssql_server.name_unique
    location                     = module.rg.groups.demo.location
    resource_group_name          = module.rg.groups.demo.name
    administrator_login_password = module.kv.secrets.sql.value

    databases = {
      orders = {
        max_size_gb = 50

        threat_detection_policy = {
          state                        = "Enabled"
          retention_days               = 30
          email_account_admins_enabled = true
          email_addresses              = ["security@cloudnation.nl"]
          disabled_alerts              = ["Sql_Injection_Vulnerability"]
          storage_endpoint             = module.storage.account.primary_blob_endpoint
          storage_account_access_key   = module.storage.account.primary_access_key
        }
      }
    }
  }
}
