variable "catalog_list" {

  type = map(object({
  storage_root                   = optional(string)
  provider_name                  = optional(string)
  share_name                     = optional(string)
  owner                          = optional(string)
  isolation_mode                 = optional(string)
  enable_predictive_optimization = optional(string)
  comment                        = optional(string)
  properties                     = optional(map(string))
  # options                       = optional(string)
  # connection_name               = optional(string)
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