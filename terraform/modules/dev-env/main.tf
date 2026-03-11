locals {
  minikube_ip        = "127.0.0.1"
  image_prefix       = "${var.docker_hub_username}/ecommerce"
  env_config_path    = "/tmp/ecommerce-env-${var.environment}.env"
}

resource "null_resource" "env_config_file" {
  triggers = {
    environment              = var.environment
    frontend_nodeport        = var.frontend_nodeport
    product_service_nodeport = var.product_service_nodeport
    order_service_nodeport   = var.order_service_nodeport
    docker_hub_username      = var.docker_hub_username
    minikube_status          = var.minikube_status
  }

  provisioner "local-exec" {
    command = <<-EOT
      cat > ${local.env_config_path} <<ENVFILE

ENVIRONMENT=${var.environment}
DOCKER_HUB_USERNAME=${var.docker_hub_username}
DOCKER_REGISTRY=${var.docker_registry}
IMAGE_PREFIX=${local.image_prefix}

FRONTEND_URL=http://${local.minikube_ip}:${var.frontend_nodeport}
PRODUCT_SERVICE_URL=http://${local.minikube_ip}:${var.product_service_nodeport}
ORDER_SERVICE_URL=http://${local.minikube_ip}:${var.order_service_nodeport}

FRONTEND_NODEPORT=${var.frontend_nodeport}
PRODUCT_SERVICE_NODEPORT=${var.product_service_nodeport}
ORDER_SERVICE_NODEPORT=${var.order_service_nodeport}
ENVFILE
      echo "Environment config written to ${local.env_config_path}"
      cat ${local.env_config_path}
    EOT
  }
}

resource "null_resource" "docker_hub_check" {
  triggers = {
    username = var.docker_hub_username
  }

  provisioner "local-exec" {
    command = <<-EOT
      if docker pull hello-world:latest > /dev/null 2>&1; then
        echo "Docker Hub is accessible"
      else
        echo "Warning: Docker Hub may not be accessible. Check network/login."
      fi
    EOT
  }
}

resource "null_resource" "env_summary" {
  depends_on = [
    null_resource.env_config_file,
    null_resource.docker_hub_check
  ]

  triggers = {
    environment = var.environment
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "Ecommerce Dev Environment: ${var.environment}"
      echo "Frontend: http://${local.minikube_ip}:${var.frontend_nodeport}"
      echo "Product Service: http://${local.minikube_ip}:${var.product_service_nodeport}"
      echo "Order Service: http://${local.minikube_ip}:${var.order_service_nodeport}"
      echo "Docker Registry: ${var.docker_registry}"
      echo "Image Prefix: ${local.image_prefix}"
      echo "Config File: ${local.env_config_path}"
    EOT
  }
}
