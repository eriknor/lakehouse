variable "schema_list" {
  type = map(object({
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
  default = {}
  #nullable = false
  description = "A map of objects which represent Schemas beneath a Catalog including all of the required settings to create."
  validation {
    condition = alltrue([
      for v in values(var.schema_list) : (
        (v.enable_predictive_optimization == null || v.enable_predictive_optimization == "ENABLE" || v.enable_predictive_optimization == "DISABLE" || v.enable_predictive_optimization == "INHERIT")

      )
    ])
    error_message = "The optional enable_predictive_optimization must be ENABLE, DISABLE, or INHERIT if included. "
  }

}
variable "catalog_name" {
  type        = string
  description = "The parent Catalog for all of the Schemas in this map."
}
