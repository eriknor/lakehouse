/*
################################################################################
* Owner:  Erik Nor

* Usage:
*   Create catalogs and any child objects within them.
*   https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/catalog
*
*   The following arguments are currently supported:
*   
*     name - Name of Catalog relative to parent metastore.
*     storage_root - (Optional if storage_root is specified for the metastore) Managed location of the catalog. Location in cloud storage where data for managed tables will be stored. If not specified, the location will default to the metastore root location. Change forces creation of a new resource.
*     provider_name - (Optional) For Delta Sharing Catalogs: the name of the delta sharing provider. Change forces creation of a new resource.
*     share_name - (Optional) For Delta Sharing Catalogs: the name of the share under the share provider. Change forces creation of a new resource.
*     owner - (Optional) Username/groupname/sp application_id of the catalog owner.
*     isolation_mode - (Optional) Whether the catalog is accessible from all workspaces or a specific set of workspaces. Can be ISOLATED or OPEN. Setting the catalog to ISOLATED will automatically allow access from the current workspace.
*     enable_predictive_optimization - (Optional) Whether predictive optimization should be enabled for this object and objects under it. Can be ENABLE, DISABLE or INHERIT
*     comment - (Optional) User-supplied free-form text.
*     properties - (Optional) Extensible Catalog properties.
*   Not currently supported:
*     connection_name - (Optional) For Foreign Catalogs: the name of the connection to an external data source. Changes forces creation of a new resource.
*     options - (Optional) For Foreign Catalogs: the name of the entity from an external data source that maps to a catalog. For example, the database name in a PostgreSQL server.
*     force_destroy - (Optional) Delete catalog regardless of its contents.
*     
################################################################################
*/

resource "databricks_catalog" "new_catalog" {
  for_each                       = var.catalog_list == null ? {} : var.catalog_list
  name                           = each.key
  storage_root                   = each.value.storage_root
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



