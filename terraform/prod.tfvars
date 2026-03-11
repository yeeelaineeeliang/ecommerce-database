environment = "prod"

# Minikube
minikube_cpus      = 4
minikube_memory    = 7000
minikube_disk_size = "40g"
minikube_driver    = "docker"

# Namespaces
k8s_namespaces = ["dev", "staging", "prod", "monitoring"]

# Quotas
namespace_cpu_limit    = "1"
namespace_memory_limit = "1Gi"

# Database
db_container_name = "ecommerce-postgres-prod"
db_image          = "postgres:15-alpine"
db_port           = 5434
db_name           = "ecommerce_prod"
db_user           = "prod_user"
db_password       = "prod_pass_2024"
db_data_path      = "/tmp/ecommerce-db-prod"

# Jenkins
jenkins_container_name = "jenkins"
jenkins_image          = "jenkins/jenkins:lts"
jenkins_port           = 8080
jenkins_agent_port     = 50000
jenkins_home_volume    = "jenkins_home"

# NodePorts
frontend_nodeport        = 30280
product_service_nodeport = 30281
order_service_nodeport   = 30282

# Docker Hub
docker_hub_username = "yeelaine"
docker_registry     = "registry.hub.docker.com"
