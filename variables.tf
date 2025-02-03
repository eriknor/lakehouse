/*
################################################################################
Variables used in this module that come from parent module

          terraform apply\
            -var env="${{vars.ENVIRONMENT}}" \
################################################################################
*/

variable "databricks_host_url" {
  type        = string
  description = "The host url for the databricks instance"
  nullable    = false
}
variable "env" {
  type        = string
  description = "The environment (dev/stg/prod)"
  nullable    = false
}

variable "databricks_account_id" {
  type        = string
  description = "The databricks account id"
  nullable    = false
}
variable "cicd_sp_application_id" {
  type        = string
  description = "The workspace service principle id"
  nullable    = false
}
variable "cicd_sp_secret" {
  type        = string
  description = "The workspace service principle secret"
  nullable    = false
}

variable "databricks_serviceprincipal_clientid" {
  type        = string
  description = "The account service principle id"
  nullable    = false
}
variable "databricks_serviceprincipal_secret" {
  type        = string
  description = "The account service principle secret"
  nullable    = false
}

