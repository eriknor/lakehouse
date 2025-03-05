variable "volume_list" {
  type = map(object({
    volume_type      = optional(string)
    owner            = optional(string)
    storage_location = optional(string)
    comment          = optional(string)
    grant-list       = map(list(string))
  }))
  default = {}
  #nullable = false
  description = "A map of objects which represent Schemas beneath a Catalog including all of the required settings to create."
  validation {
    condition = alltrue([
      for v in values(var.volume_list) : (
        (v.volume_type == "EXTERNAL" || v.volume_type == "MANAGED")
        &&
        ((v.volume_type == "EXTERNAL" && v.storage_location != null)
        ||
        (v.volume_type == "MANAGED" && v.storage_location == null))

      )
    ])
    error_message = "The volume_type must be EXTERNAL or MANAGED.  storage_location must only be set if the volume_type is external."
  }

}
variable "schema_name" {
  type        = string
  description = "The parent Schemas for all of the Volumes in this map."

}
variable "catalog_name" {
  type        = string
  description = "The parent Catalog for all of the Volumes in this map."
}
