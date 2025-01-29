resource "databricks_schema" "new_schema" {
  for_each      = var.schema_list == null ? {} : var.schema_list
  catalog_name  = var.catalog_name
  storage_root  = try(each.value.storage_root, null)
  owner         = try(each.value.owner, null)
  name          = each.key
  comment       = try(each.value.comment, null)
  properties    = try(each.value.properties, null)
  force_destroy = try(each.value.force_destroy, null)
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
# data "databricks_schema" "new_schema" {
#   for_each = var.schema_list == null ? {} : var.schema_list
#   #   catalog_name  = var.catalog_name
#   #   storage_root  = try(each.value.storage_root, null)
#   #   owner         = try(each.value.owner, null)
#   name = "${var.catalog_name}.${each.key}"
#   #   comment       = try(each.value.comment, null)
#   #   properties    = try(each.value.properties, null)

# }

output "databricks_schemas" {
  value = tomap({
    for k, new_schema in databricks_schema.new_schema : k => new_schema
  })
}
