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

module "uai" {
  source  = "cloudnationhq/uai/azure"
  version = "~> 2.0"

  config = {
    name                = module.naming.user_assigned_identity.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
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

    keys = {
      tde = {
        key_type = "RSA"
        key_size = 2048
        key_opts = ["unwrapKey", "wrapKey"]
      }
    }
  }
}

module "rbac" {
  source  = "cloudnationhq/rbac/azure"
  version = "~> 2.0"

  role_assignments = {
    sql-identity = {
      object_id = module.uai.config.principal_id
      type      = "ServicePrincipal"
      roles = {
        "Key Vault Crypto Service Encryption User" = {
          scopes = {
            kv = module.kv.vault.id
          }
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
    name                              = module.naming.mssql_server.name_unique
    location                          = module.rg.groups.demo.location
    resource_group_name               = module.rg.groups.demo.name
    administrator_login_password      = module.kv.secrets.sql.value
    primary_user_assigned_identity_id = module.uai.config.id

    identity = {
      type         = "UserAssigned"
      identity_ids = [module.uai.config.id]
    }

    transparent_data_encryption = {
      key_vault_key_id      = module.kv.keys.tde.id
      auto_rotation_enabled = true
    }
  }

  depends_on = [module.rbac]
}
