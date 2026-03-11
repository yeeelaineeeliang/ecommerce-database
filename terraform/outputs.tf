# Minikube
output "minikube_cluster_url" {
  description = "Minikube API server URL for kubectl/Jenkins"
  value       = module.minikube.cluster_url
}

output "minikube_cluster_status" {
  description = "Current status of the Minikube cluster"
  value       = module.minikube.cluster_status
}

output "k8s_namespaces" {
  description = "List of Kubernetes namespaces provisioned"
  value       = module.minikube.namespaces_created
}

# Docker Registry
output "docker_registry_url" {
  description = "Docker registry URL for image pushes"
  value       = module.dev_env.docker_registry_url
}

output "docker_image_prefix" {
  description = "Image name prefix (registry/username)"
  value       = module.dev_env.docker_image_prefix
}

# Service URLs
output "frontend_url" {
  description = "Frontend service external URL"
  value       = module.dev_env.frontend_url
}

output "product_service_url" {
  description = "Product service external URL"
  value       = module.dev_env.product_service_url
}

output "order_service_url" {
  description = "Order service external URL"
  value       = module.dev_env.order_service_url
}

# Database
output "database_host" {
  description = "PostgreSQL host for application config"
  value       = module.database.db_host
}

output "database_port" {
  description = "PostgreSQL port"
  value       = module.database.db_port
}

output "database_name" {
  description = "PostgreSQL database name"
  value       = module.database.db_name
}

output "database_container_status" {
  description = "Status of the PostgreSQL Docker container"
  value       = module.database.container_status
}

# Jenkins
output "jenkins_url" {
  description = "Jenkins web UI URL"
  value       = module.jenkins.jenkins_url
}

output "jenkins_container_status" {
  description = "Status of the Jenkins Docker container"
  value       = module.jenkins.container_status
}

output "environment_summary" {
  description = "Full environment configuration summary for CI/CD"
  value = {
    environment          = var.environment
    workspace            = terraform.workspace
    minikube_url         = module.minikube.cluster_url
    docker_registry      = module.dev_env.docker_registry_url
    frontend_url         = module.dev_env.frontend_url
    product_service_url  = module.dev_env.product_service_url
    order_service_url    = module.dev_env.order_service_url
    jenkins_url          = module.jenkins.jenkins_url
    db_host              = module.database.db_host
  }
}
