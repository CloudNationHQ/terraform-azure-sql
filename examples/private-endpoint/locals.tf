locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "key_vault_secret"]
}

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
