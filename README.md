# Sql Server

This terraform module simplifies the creation and management of azure sql servers, offering a flexible and customizable solution for deploying fully-configured instances. It encapsulates best practices and provides a range of options to meet various requirements.

## Features

Manages multiple sql databases and elastic pools.

Ability to associate multiple databases within a single elastic pool.

Support for adding virtual network and firewall rules

Utilization of terratest for robust validation.

Integrates seamlessly with private endpoint capabilities for direct and secure connectivity

Supports both system and multiple user assigned identities

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_mssql_database.database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) (resource)
- [azurerm_mssql_elasticpool.elasticpool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_elasticpool) (resource)
- [azurerm_mssql_firewall_rule.firewallrule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) (resource)
- [azurerm_mssql_server.sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) (resource)
- [azurerm_mssql_virtual_network_rule.vnetrule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_virtual_network_rule) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_instance"></a> [instance](#input\_instance)

Description: Contains all mssql server configuration

Type:

```hcl
object({
    name                                         = string
    resource_group_name                          = optional(string, null)
    location                                     = optional(string, null)
    version                                      = optional(string, "12.0")
    public_network_access_enabled                = optional(bool, true)
    primary_user_assigned_identity_id            = optional(string, null)
    administrator_login                          = optional(string, "adminLogin")
    administrator_login_password                 = optional(string, null)
    administrator_login_password_wo              = optional(string, null)
    administrator_login_password_wo_version      = optional(string, null)
    connection_policy                            = optional(string, "Default")
    express_vulnerability_assessment_enabled     = optional(bool, false)
    minimum_tls_version                          = optional(string, "1.2")
    outbound_network_restriction_enabled         = optional(bool, false)
    transparent_data_encryption_key_vault_key_id = optional(string, null)
    tags                                         = optional(map(string))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), [])
    }), null)
    azuread_administrator = optional(object({
      login_username              = optional(string, null)
      object_id                   = optional(string, null)
      tenant_id                   = optional(string, null)
      azuread_authentication_only = optional(bool, null)
    }), null)
    network_rules = optional(map(object({
      subnet_id                            = string
      ignore_missing_vnet_service_endpoint = optional(bool, false)
    })), {})
    fw_rules = optional(map(object({
      start_ip_address = string
      end_ip_address   = string
    })), {})
    elasticpools = optional(map(object({
      name                           = optional(string, null)
      server_name                    = string
      license_type                   = optional(string, "LicenseIncluded")
      max_size_gb                    = optional(number, 4)
      zone_redundant                 = optional(bool, false)
      enclave_type                   = optional(string, null)
      maintenance_configuration_name = optional(string, null)
      max_size_bytes                 = optional(number, null)
      tags                           = optional(map(string))
      sku                            = optional(string, "StandardPool")
      tier                           = optional(string, "Standard")
      capacity                       = optional(number, 200)
      family                         = optional(string, null)
      per_database_settings = object({
        min_capacity = optional(number, 0)
        max_capacity = optional(number, 10)
      })
    })), {})
    databases = optional(map(object({
      name                                                       = optional(string, null)
      collation                                                  = optional(string, "SQL_Latin1_General_CP1_CI_AS")
      max_size_gb                                                = optional(number, 100)
      read_scale                                                 = optional(bool, false)
      zone_redundant                                             = optional(bool, false)
      sku                                                        = optional(string, "S0")
      # elasticpool                                                = optional(string, null)
      min_capacity                                               = optional(number, null)
      create_mode                                                = optional(string, "Default")
      license_type                                               = optional(string, null)
      ledger_enabled                                             = optional(bool, false)
      geo_backup_enabled                                         = optional(bool, true)
      sample_name                                                = optional(string, null)
      read_replica_count                                         = optional(number, null)
      storage_account_type                                       = optional(string, null)
      transparent_data_encryption_enabled                        = optional(bool, true)
      enclave_type                                               = optional(string, null)
      transparent_data_encryption_key_vault_key_id               = optional(string, null)
      transparent_data_encryption_key_automatic_rotation_enabled = optional(bool, null)
      maintenance_configuration_name                             = optional(string, null)
      recover_database_id                                        = optional(string, null)
      recovery_point_id                                          = optional(string, null)
      restore_point_in_time                                      = optional(string, null)
      auto_pause_delay_in_minutes                                = optional(number, null)
      creation_source_database_id                                = optional(string, null)
      restore_dropped_database_id                                = optional(string, null)
      secondary_type                                             = optional(string, null)
      tags                                                       = optional(map(string))
      identity = optional(object({
        type         = string
        identity_ids = optional(list(string), [])
      }), null)
      import = optional(object({
        storage_uri                  = string
        storage_key                  = string
        storage_key_type             = string
        administrator_login          = string
        administrator_login_password = string
        authentication_type          = string
        storage_account_id           = optional(string, null)
      }), null)
      threat_detection_policy = optional(object({
        state                      = optional(string, "Disabled")
        disabled_alerts            = optional(list(string), null)
        email_account_admins       = optional(string, "Disabled")
        email_addresses            = optional(list(string), null)
        retention_days             = optional(number, null)
        storage_account_access_key = optional(string, null)
        storage_endpoint           = optional(string, null)
      }), null)
      long_term_retention_policy = optional(object({
        weekly_retention  = optional(string, null)
        monthly_retention = optional(string, null)
        yearly_retention  = optional(string, null)
        week_of_year      = optional(number, null)
      }), null)
      short_term_retention_policy = optional(object({
        retention_days           = optional(number, null)
        backup_interval_in_hours = optional(number, 12)
      }), null)
    })), {})
  })
```

### <a name="input_naming"></a> [naming](#input\_naming)

Description: used for naming purposes

Type: `map(string)`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_databases"></a> [databases](#output\_databases)

Description: contains databases

### <a name="output_elasticpools"></a> [elasticpools](#output\_elasticpools)

Description: contains elastic pools

### <a name="output_server"></a> [server](#output\_server)

Description: contains all sql server details
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-sql/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-sql" />
</a>


## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview?view=azuresql)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/sql/)
