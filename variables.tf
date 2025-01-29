/*
################################################################################
Variables used in this module that come from parent module
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
variable "required_tags" {
  type        = map(any)
  description = "value for required tags"
  nullable    = false
}
