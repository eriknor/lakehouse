variable "volume_list" {
  type    = map(any)
  default = {}
  #nullable = false
}
variable "schema_name" {
  type = string
}
variable "catalog_name" {
  type = string
}
