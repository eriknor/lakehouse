variable "catalog_list" {

  type = map(object({
    grant-list = map(list(string))
    schema-list = map(object({
      grant-list = map(list(string))
    }))
  })) #map(any)
  default = {}
  #nullable = false
}



# variable "metastore_id" {
#   type = string
# }