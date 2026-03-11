variable "environment" {
  type = string
}
variable "cpus" {
  type    = number
  default = 2
}
variable "memory" {
  type    = number
  default = 4096
}
variable "disk_size" {
  type    = string
  default = "20g"
}
variable "driver" {
  type    = string
  default = "docker"
}
variable "namespaces" {
  type    = list(string)
  default = ["dev", "staging", "prod", "monitoring"]
}
variable "cpu_limit" {
  type    = string
  default = "2"
}
variable "memory_limit" {
  type    = string
  default = "2Gi"
}
variable "tags" {
  type    = map(string)
  default = {}
}
