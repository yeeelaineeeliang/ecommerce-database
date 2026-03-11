output "docker_registry_url" {
  value = var.docker_registry
}
output "docker_image_prefix" {
  value = "${var.docker_hub_username}/ecommerce"
}
output "frontend_url" {
  value = "http://127.0.0.1:${var.frontend_nodeport}"
}
output "product_service_url" {
  value = "http://127.0.0.1:${var.product_service_nodeport}"
}
output "order_service_url" {
  value = "http://127.0.0.1:${var.order_service_nodeport}"
}
output "env_config_path" {
  value = "/tmp/ecommerce-env-${var.environment}.env"
}
