variable "environment" {
  type = string
}
variable "container_name" {
  type    = string
  default = "ecommerce-postgres"
}
variable "image" {
  type    = string
  default = "postgres:15-alpine"
}
variable "host_port" {
  type    = number
  default = 5432
}
variable "db_name" {
  type    = string
  default = "ecommerce"
}
variable "db_user" {
  type    = string
  default = "ecommerce_user"
}
variable "db_password" {
  type      = string
  sensitive = true
  default   = "ecommerce_pass"
}
variable "data_path" {
  type    = string
  default = "/tmp/ecommerce-db-data"
}
variable "tags" {
  type    = map(string)
  default = {}
}
