environment = "staging"

# Minikube — more resources for staging parity with prod
minikube_cpus      = 3
minikube_memory    = 6144
minikube_disk_size = "30g"
minikube_driver    = "docker"

k8s_namespaces = ["dev", "staging", "prod", "monitoring"]

# Quotas
namespace_cpu_limit    = "1500m"
namespace_memory_limit = "1536Mi"

# Database
db_container_name = "ecommerce-postgres-staging"
db_image          = "postgres:15-alpine"
db_port           = 5433
db_name           = "ecommerce_staging"
db_user           = "staging_user"
db_password       = "staging_pass_2024"
db_data_path      = "/tmp/ecommerce-db-staging"

# Jenkins
jenkins_container_name = "jenkins"
jenkins_image          = "jenkins/jenkins:lts"
jenkins_port           = 8080
jenkins_agent_port     = 50000
jenkins_home_volume    = "jenkins_home"

# NodePort
frontend_nodeport        = 30180
product_service_nodeport = 30181
order_service_nodeport   = 30182

# Docker Hub
docker_hub_username = "yeelaine"
docker_registry     = "registry.hub.docker.com"
