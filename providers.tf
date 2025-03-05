/*
################################################################################
Provider versions

Use provider databricks to point to specific workspace
################################################################################
*/

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
  #required_version = ">= 1.9.0"
}

# Default provider - used to deploy virtually everything in our workspace
provider "databricks" {
  account_id    = var.databricks_account_id
  host          = var.databricks_host_url
  client_id     = var.cicd_sp_application_id
  client_secret = var.cicd_sp_secret
}

# Workspace-level provider of the account-level Admin SP. This is used in exceedingly rare cases where the account-level
# provider cannot access resources at the account-level. Reading metastore grants is the only accepted use case
# for this platform.
provider "databricks" {
  alias         = "account-sp-at-workspace"
  host          = var.databricks_host_url
  client_id     = var.databricks_serviceprincipal_clientid
  client_secret = var.databricks_serviceprincipal_secret
  account_id    = var.databricks_account_id
}
