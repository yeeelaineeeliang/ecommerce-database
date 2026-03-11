variable "environment" {
  type = string
}
variable "docker_hub_username" {
  type    = string
  default = "yeelaine"
}
variable "docker_registry" {
  type    = string
  default = "registry.hub.docker.com"
}
variable "frontend_nodeport" {
  type    = number
  default = 30080
}
variable "product_service_nodeport" {
  type    = number
  default = 30081
}
variable "order_service_nodeport" {
  type    = number
  default = 30082
}
variable "minikube_status" {
  type    = string
  default = ""
}
variable "tags" {
  type    = map(string)
  default = {}
}
