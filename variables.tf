variable "instance" {
  description = "Contains all mssql server configuration"
  type = object({
    name                                         = string
    resource_group_name                          = optional(string)
    location                                     = optional(string)
    version                                      = optional(string, "12.0")
    public_network_access_enabled                = optional(bool, true)
    primary_user_assigned_identity_id            = optional(string)
    administrator_login                          = optional(string)
    administrator_login_password                 = optional(string)
    administrator_login_password_wo              = optional(string)
    administrator_login_password_wo_version      = optional(string)
    connection_policy                            = optional(string, "Default")
    express_vulnerability_assessment_enabled     = optional(bool, false)
    minimum_tls_version                          = optional(string, "1.2")
    outbound_network_restriction_enabled         = optional(bool, false)
    transparent_data_encryption_key_vault_key_id = optional(string)
    tags                                         = optional(map(string))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), [])
    }))
    azuread_administrator = optional(object({
      login_username              = optional(string)
      object_id                   = optional(string)
      tenant_id                   = optional(string)
      azuread_authentication_only = optional(bool)
    }))
    network_rules = optional(map(object({
      subnet_id                            = string
      ignore_missing_vnet_service_endpoint = optional(bool, false)
    })), {})
    fw_rules = optional(map(object({
      start_ip_address = string
      end_ip_address   = string
    })), {})
    elasticpools = optional(map(object({
      name                           = optional(string)
      license_type                   = optional(string, "LicenseIncluded")
      max_size_gb                    = optional(number, 4)
      zone_redundant                 = optional(bool, false)
      enclave_type                   = optional(string)
      maintenance_configuration_name = optional(string)
      max_size_bytes                 = optional(number)
      tags                           = optional(map(string))
      sku                            = optional(string, "StandardPool")
      tier                           = optional(string, "Standard")
      capacity                       = optional(number, 200)
      family                         = optional(string)
      per_database_settings = optional(object({
        min_capacity = optional(number)
        max_capacity = optional(number)
      }), { min_capacity = 0, max_capacity = 10 }) # default should not be null
    })), {})
    databases = optional(map(object({
      name                                                       = optional(string)
      collation                                                  = optional(string, "SQL_Latin1_General_CP1_CI_AS")
      max_size_gb                                                = optional(number, 100)
      read_scale                                                 = optional(bool, false)
      zone_redundant                                             = optional(bool, false)
      sku                                                        = optional(string, "S0")
      elasticpool                                                = optional(string)
      min_capacity                                               = optional(number)
      create_mode                                                = optional(string, "Default")
      license_type                                               = optional(string)
      ledger_enabled                                             = optional(bool, false)
      geo_backup_enabled                                         = optional(bool, true)
      sample_name                                                = optional(string)
      read_replica_count                                         = optional(number)
      storage_account_type                                       = optional(string)
      transparent_data_encryption_enabled                        = optional(bool, true)
      enclave_type                                               = optional(string)
      transparent_data_encryption_key_vault_key_id               = optional(string)
      transparent_data_encryption_key_automatic_rotation_enabled = optional(bool)
      maintenance_configuration_name                             = optional(string)
      recover_database_id                                        = optional(string)
      recovery_point_id                                          = optional(string)
      restore_point_in_time                                      = optional(string)
      auto_pause_delay_in_minutes                                = optional(number)
      creation_source_database_id                                = optional(string)
      restore_dropped_database_id                                = optional(string)
      secondary_type                                             = optional(string)
      tags                                                       = optional(map(string))
      restore_long_term_retention_backup_id                      = optional(string)
      identity = optional(object({
        type         = string
        identity_ids = optional(list(string), [])
      }))
      import = optional(object({
        storage_uri                  = string
        storage_key                  = string
        storage_key_type             = string
        administrator_login          = string
        administrator_login_password = string
        authentication_type          = string
        storage_account_id           = optional(string)
      }))
      threat_detection_policy = optional(object({
        state                      = optional(string, "Disabled")
        disabled_alerts            = optional(list(string))
        email_account_admins       = optional(string, "Disabled")
        email_addresses            = optional(list(string))
        retention_days             = optional(number)
        storage_account_access_key = optional(string)
        storage_endpoint           = optional(string)
      }))
      long_term_retention_policy = optional(object({
        weekly_retention  = optional(string)
        monthly_retention = optional(string)
        yearly_retention  = optional(string)
        week_of_year      = optional(number)
      }))
      short_term_retention_policy = optional(object({
        retention_days           = optional(number)
        backup_interval_in_hours = optional(number, 12)
      }))
    })), {})
  })
}

variable "naming" {
  description = "used for naming purposes"
  type        = map(string)
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
