/*
################################################################################
* Owner:  Erik Nor

* Usage:
*   These are all the catalogs that are created in Databricks
################################################################################
*/


locals {
  catalog_list_v2 = try(lookup(lookup(local.catalog_list_yaml, "catalogs-list"), var.env), {})

}

module "uc-catalogs" {
  source = "./uc-catalog-module"
  catalog_list = {
    for k, v in local.catalog_list_v2 : k => merge(v, {
      grant-list = merge(v["grant-list"], {
        #Add the service principals that need access to the catalog
        # (databricks_service_principal.xxxRWxxx.application_id) = ["USE_CATALOG", "USE_SCHEMA", "CREATE_SCHEMA", "CREATE_TABLE", "MODIFY", "READ_VOLUME", "WRITE_VOLUME", "SELECT"],
        # (databricks_service_principal.yyyROyyy.application_id) = ["USE_CATALOG", "USE_SCHEMA", "SELECT", "READ_VOLUME"]
      })
    })
  } #local.catalog_list_w_sp_permissions 
  providers = {
    databricks = databricks
  }
  # depends_on = [databricks_external_location.external_metastore]


}
