output "jenkins_url" {
  value = "http://localhost:${var.web_port}"
}
output "jenkins_agent_url" {
  value = "http://localhost:${var.agent_port}"
}
output "container_name" {
  value = var.container_name
}
output "container_status" {
  value = "managed:${var.container_name}:${var.web_port}"
}
output "home_volume" {
  value = var.home_volume
}
