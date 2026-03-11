environment = "dev"

# Minikube
minikube_cpus      = 2
minikube_memory    = 4096
minikube_disk_size = "20g"
minikube_driver    = "docker"

# Namespaces
k8s_namespaces = ["dev", "staging", "prod", "monitoring"]

# Quotas 
namespace_cpu_limit    = "2"
namespace_memory_limit = "2Gi"

# Database 
db_container_name = "ecommerce-postgres-dev"
db_image          = "postgres:15-alpine"
db_port           = 5432
db_name           = "ecommerce_dev"
db_user           = "dev_user"
db_password       = "dev_pass_2024"
db_data_path      = "/tmp/ecommerce-db-dev"

# Jenkins
jenkins_container_name = "jenkins"
jenkins_image          = "jenkins/jenkins:lts"
jenkins_port           = 8080
jenkins_agent_port     = 50000
jenkins_home_volume    = "jenkins_home"

# NodePorts
frontend_nodeport        = 30080
product_service_nodeport = 30081
order_service_nodeport   = 30082

# Docker Hub
docker_hub_username = "yeelaine"
docker_registry     = "registry.hub.docker.com"
