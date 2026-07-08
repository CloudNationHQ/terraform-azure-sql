This example shows how to configure Azure SQL Server with Entra-only authentication.

Setting `azuread_authentication_only = true` disables SQL password login entirely. The server requires a `SystemAssigned` identity so the module can grant it the **Directory Readers** Entra role, which is needed to resolve user identities at login time.

**Note**: The Terraform principal running this must have either the `RoleManagement.ReadWrite.Directory` application role (for a Service Principal) or the `Privileged Role Administrator` / `Global Administrator` directory role (for a User Principal) to assign Directory Readers to the managed identity.
