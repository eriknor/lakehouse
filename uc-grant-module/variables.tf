variable "grant_list" {
  # type = map(object({
  #   grant-list = map(list(string))
  #   schema-list = map(object({
  #     grant-list = map(list(string))
  #   }))
  # })) 
  type    = map(any)
  default = {}
  #nullable = false
}

variable "catalog_name" {
  type    = string
  default = null
}

variable "schema_id" {
  type    = string
  default = null
}

variable "volume_id" {
  type    = string
  default = null
}
