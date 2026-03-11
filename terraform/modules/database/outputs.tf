output "db_host" {
  value = "localhost"
}
output "db_port" {
  value = var.host_port
}
output "db_name" {
  value = var.db_name
}
output "container_name" {
  value = var.container_name
}
output "container_status" {
  value = "managed:${var.container_name}:${var.host_port}"
}
output "connection_string" {
  value = "postgresql://${var.db_user}@localhost:${var.host_port}/${var.db_name}"
}
