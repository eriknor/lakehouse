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
    force_destroy                  = optional(string)
    # options                       = optional(string)
    # connection_name               = optional(string)
    grant-list = map(list(string))
    schema-list = map(object({
      storage_root                   = optional(string)
      owner                          = optional(string)
      comment                        = optional(string)
      properties                     = optional(map(string))
      enable_predictive_optimization = optional(string)
      force_destroy                  = optional(string)
      grant-list                     = map(list(string))
      volume-list = map(object({
        volume_type      = optional(string)
        owner            = optional(string)
        storage_location = optional(string)
        comment          = optional(string)
        grant-list       = map(list(string))
      }))
    }))
  })) #map(any)
  default     = {}
  description = "A map of objects which represent Catalogs including all of the required settings to create."
  validation {
    condition = alltrue([
      for v in values(var.catalog_list) : (
        (v.enable_predictive_optimization == null || v.enable_predictive_optimization == "ENABLE" || v.enable_predictive_optimization == "DISABLE" || v.enable_predictive_optimization == "INHERIT")
        &&
        (v.isolation_mode == null || v.isolation_mode == "ISOLATED" || v.isolation_mode == "OPEN")
      )
    ])
    error_message = "The optional enable_predictive_optimization must be ENABLE, DISABLE, or INHERIT if included.  The optional isolation_mode must be ISOLATED or OPEN if included."
  }
  #nullable = false
}



# variable "metastore_id" {
#   type = string
# }