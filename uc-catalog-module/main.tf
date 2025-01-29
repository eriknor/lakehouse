resource "databricks_catalog" "new_catalog" {
  for_each                       = var.catalog_list == null ? {} : var.catalog_list
  name                           = each.key
  storage_root                   = try(each.value.storage_root, null)
  provider_name                  = try(each.value.provider_name, null)
  share_name                     = try(each.value.share_name, null)
  owner                          = try(each.value.owner, null)
  isolation_mode                 = try(each.value.isolation_mode, null)
  enable_predictive_optimization = try(each.value.enable_predictive_optimization, null)
  comment                        = try(each.value.comment, null)
  properties                     = try(each.value.properties, null)
  # options                       = try(each.value.options,null)
  # connection_name               = try(each.value.connection_name,null)
}


module "databricks_grants" {
  # depends_on   = [time_sleep.wait-for-catalog-creation]
  for_each     = var.catalog_list == null ? {} : var.catalog_list
  source       = "../uc-grant-module"
  catalog_name = each.key
  grant_list   = try(each.value.grant-list, {})
}


module "databricks_schemas" {
  # depends_on   = [time_sleep.wait-for-catalog-creation]
  for_each     = var.catalog_list == null ? {} : var.catalog_list
  source       = "../uc-schema-module"
  catalog_name = each.key
  schema_list  = try(each.value.schema-list, {})

}

# data "databricks_catalog" "new_catalog" {
#   for_each = var.catalog_list == null ? {} : var.catalog_list
#   name     = each.key
# }

output "databricks_catalog" {
  value = tomap({
    for k, new_catalog in databricks_catalog.new_catalog : k => {
      catalog = new_catalog
      schemas = {
        for ks, v in module.databricks_schemas : ks => v.databricks_schemas
      }
  } })
}



