locals {
  endpoints = {
    vault = {
      name                           = module.naming.private_endpoint.name
      subnet_id                      = module.network.subnets.sn1.id
      private_connection_resource_id = module.sql.server.id
      private_dns_zone_ids           = [module.private_dns.private_zones.sql.id]
      subresource_names              = ["SqlServer"]
    }
  }
}
