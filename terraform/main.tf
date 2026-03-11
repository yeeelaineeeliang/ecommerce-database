locals {
  workspace = terraform.workspace
  env       = var.environment

  common_tags = {
    project     = "ecommerce"
    environment = local.env
    managed_by  = "terraform"
    workspace   = local.workspace
  }
}

# Module 1: Minikube 
module "minikube" {
  source = "./modules/minikube"

  environment        = local.env
  cpus               = var.minikube_cpus
  memory             = var.minikube_memory
  disk_size          = var.minikube_disk_size
  driver             = var.minikube_driver
  namespaces         = var.k8s_namespaces
  cpu_limit          = var.namespace_cpu_limit
  memory_limit       = var.namespace_memory_limit
  tags               = local.common_tags
}

# Module 2: Database
module "database" {
  source = "./modules/database"

  environment    = local.env
  container_name = var.db_container_name
  image          = var.db_image
  host_port      = var.db_port
  db_name        = var.db_name
  db_user        = var.db_user
  db_password    = var.db_password
  data_path      = var.db_data_path
  tags           = local.common_tags
}

# Module 3: Jenkins
module "jenkins" {
  source = "./modules/jenkins"

  environment        = local.env
  container_name     = var.jenkins_container_name
  image              = var.jenkins_image
  web_port           = var.jenkins_port
  agent_port         = var.jenkins_agent_port
  home_volume        = var.jenkins_home_volume
  tags               = local.common_tags
}

# Module 4: Dev Env
module "dev_env" {
  source = "./modules/dev-env"

  environment              = local.env
  docker_hub_username      = var.docker_hub_username
  docker_registry          = var.docker_registry
  frontend_nodeport        = var.frontend_nodeport
  product_service_nodeport = var.product_service_nodeport
  order_service_nodeport   = var.order_service_nodeport
  tags                     = local.common_tags

  minikube_status = module.minikube.cluster_status
}
