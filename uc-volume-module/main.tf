resource "databricks_volume" "new_volume" {
  for_each      = var.schema_list == null ? {} : var.schema_list
  catalog_name  = var.catalog_name
  schema_name   = var.schema_name
  volume_type   = each.value.volume_type
  storage_location  = try(each.value.storage_location, null)
  owner         = try(each.value.owner, null)
  name          = each.key
  comment       = try(each.value.comment, null)
}


module "databricks_grants" {
  # depends_on = [time_sleep.wait-for-schema-creation]
  for_each   = var.volume_list == null ? {} : var.volume_list
  source     = "../uc-grant-module"
  volume_id = "${var.catalog_name}.${var.schema_name}.${each.key}"
  grant_list = try(each.value.grant-list, {})
}



output "databricks_volumes" {
  value = tomap({
    for k, new_volume in databricks_volume.new_volume : k => new_volume
  })
}
