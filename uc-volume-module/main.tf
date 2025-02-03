/*
################################################################################
* Owner:  Erik Nor

* Usage:
*  These are all the volumes that are created in Databricks
*  https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/volume
*
*   The following arguments are currently supported:
*     name - Name of the Volume
*     catalog_name - Name of parent Catalog. Change forces creation of a new resource.
*     schema_name - Name of parent Schema relative to parent Catalog. Change forces creation of a new resource.
*     volume_type - Volume type. EXTERNAL or MANAGED. Change forces creation of a new resource.
*     owner - (Optional) Name of the volume owner.
*     storage_location - (Optional) Path inside an External Location. Only used for EXTERNAL Volumes. Change forces creation of a new resource.
*     comment - (Optional) Free-form text.
*
################################################################################
*/

resource "databricks_volume" "new_volume" {
  for_each         = var.volume_list == null ? {} : var.volume_list
  catalog_name     = var.catalog_name
  schema_name      = var.schema_name
  volume_type      = each.value.volume_type
  storage_location = try(each.value.storage_location, null)
  owner            = try(each.value.owner, null)
  name             = each.key
  comment          = try(each.value.comment, null)
}


module "databricks_grants" {
  # depends_on = [time_sleep.wait-for-schema-creation]
  for_each   = var.volume_list == null ? {} : var.volume_list
  source     = "../uc-grant-module"
  volume_id  = "${var.catalog_name}.${var.schema_name}.${each.key}"
  grant_list = try(each.value.grant-list, {})
}



output "databricks_volumes" {
  value = tomap({
    for k, new_volume in databricks_volume.new_volume : k => new_volume
  })
}
