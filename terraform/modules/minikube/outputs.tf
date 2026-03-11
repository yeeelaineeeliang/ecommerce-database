output "cluster_url" {
  value = "https://127.0.0.1:8443"
}
output "cluster_status" {
  value = "profile:ecommerce-${var.environment}"
}
output "namespaces_created" {
  value = var.namespaces
}
output "kubeconfig_context" {
  value = "ecommerce-${var.environment}"
}
