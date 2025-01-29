resource "databricks_grants" "catalog_grants" {
  count   = var.grant_list == null ? 0 : var.catalog_name == null ? 0 : length(var.grant_list) > 0 ? 1 : 0
  catalog = var.catalog_name

  dynamic "grant" {
    for_each = var.grant_list
    content {
      principal  = grant.key
      privileges = toset([for i in grant.value : i])
    }
  }
}


resource "databricks_grants" "schema_grants" {
  count  = var.grant_list == null ? 0 : var.schema_id == null ? 0 : length(var.grant_list) > 0 ? 1 : 0
  schema = var.schema_id

  dynamic "grant" {
    for_each = var.grant_list
    content {
      principal  = grant.key
      privileges = toset([for i in grant.value : i])

    }
  }
}


resource "databricks_grants" "volume_grants" {
  count  = var.grant_list == null ? 0 : var.volume_id == null ? 0 : length(var.grant_list) > 0 ? 1 : 0
  volume = var.volume_id

  dynamic "grant" {
    for_each = var.grant_list
    content {
      principal  = grant.key
      privileges = toset([for i in grant.value : i])

    }
  }
}



