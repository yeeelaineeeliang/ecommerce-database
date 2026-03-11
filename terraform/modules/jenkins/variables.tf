variable "environment" {
  type = string
}
variable "container_name" {
  type    = string
  default = "jenkins"
}
variable "image" {
  type    = string
  default = "jenkins/jenkins:lts"
}
variable "web_port" {
  type    = number
  default = 8080
}
variable "agent_port" {
  type    = number
  default = 50000
}
variable "home_volume" {
  type    = string
  default = "jenkins_home"
}
variable "tags" {
  type    = map(string)
  default = {}
}
