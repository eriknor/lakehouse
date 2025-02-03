
/*
################################################################################
* Owner:  Erik Nor

* Usage:
*   These are all the schemas that are created in Databricks
*   https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/schema
*
*   The following arguments are currently supported:
*   
*     name - Name of Schema relative to parent catalog. Change forces creation of a new resource.
*     catalog_name - Name of parent catalog. Change forces creation of a new resource.
*     storage_root - (Optional) Managed location of the schema. Location in cloud storage where data for managed tables will be stored. If not specified, the location will default to the catalog root location. Change forces creation of a new resource.
*     owner - (Optional) Username/groupname/sp application_id of the schema owner.
*     comment - (Optional) User-supplied free-form text.
*     properties - (Optional) Extensible Schema properties.
*     enable_predictive_optimization - (Optional) Whether predictive optimization should be enabled for this object and objects under it. Can be ENABLE, DISABLE or INHERIT
*     force_destroy - (Optional) Delete schema regardless of its contents.
################################################################################
*/

resource "databricks_schema" "new_schema" {
  for_each                       = var.schema_list == null ? {} : var.schema_list
  catalog_name                   = var.catalog_name
  storage_root                   = try(each.value.storage_root, null)
  owner                          = try(each.value.owner, null)
  name                           = each.key
  comment                        = try(each.value.comment, null)
  properties                     = try(each.value.properties, null)
  force_destroy                  = try(each.value.force_destroy, null)
  enable_predictive_optimization = try(each.value.enable_predictive_optimization, null)
}


module "databricks_grants" {
  # depends_on = [time_sleep.wait-for-schema-creation]
  for_each   = var.schema_list == null ? {} : var.schema_list
  source     = "../uc-grant-module"
  schema_id  = "${var.catalog_name}.${each.key}"
  grant_list = try(each.value.grant-list, {})
}


module "databricks_volumes" {
  # depends_on   = [time_sleep.wait-for-catalog-creation]
  for_each     = var.schema_list == null ? {} : var.schema_list
  source       = "../uc-volume-module"
  catalog_name = var.catalog_name
  schema_name  = each.key
  volume_list  = try(each.value.schema-list, {})

}


output "databricks_schemas" {
  value = tomap({
    for k, new_schema in databricks_schema.new_schema : k => new_schema
  })
}
