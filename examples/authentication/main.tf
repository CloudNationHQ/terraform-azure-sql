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

data "azuread_group" "db_admin" {
  display_name = "db-administrators"
}

module "sql" {
  source  = "cloudnationhq/sql/azure"
  version = "~> 2.0"

  naming = local.naming

  instance = {
    name                = module.naming.mssql_server.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    identity = {
      type = "SystemAssigned"
    }

    azuread_administrator = {
      login_username              = data.azuread_group.db_admin.display_name
      object_id                   = data.azuread_group.db_admin.object_id
      azuread_authentication_only = true
    }
  }
}
