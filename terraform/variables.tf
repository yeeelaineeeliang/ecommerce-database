variable "environment" {
  description = "Deployment environment (dev | staging | prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod"
  }
}

# minikube
variable "minikube_cpus" {
  description = "Number of CPUs to allocate to Minikube"
  type        = number
  default     = 2
}

variable "minikube_memory" {
  description = "Memory (MB) to allocate to Minikube"
  type        = number
  default     = 4096
}

variable "minikube_disk_size" {
  description = "Disk size for Minikube"
  type        = string
  default     = "20g"
}

variable "minikube_driver" {
  description = "Minikube driver (docker | virtualbox | hyperkit)"
  type        = string
  default     = "docker"
}

# K8 Namespaces
variable "k8s_namespaces" {
  description = "List of Kubernetes namespaces to create"
  type        = list(string)
  default     = ["dev", "staging", "prod", "monitoring"]
}

variable "namespace_cpu_limit" {
  description = "CPU resource quota limit per namespace"
  type        = string
  default     = "2"
}

variable "namespace_memory_limit" {
  description = "Memory resource quota limit per namespace"
  type        = string
  default     = "2Gi"
}

# Database
variable "db_container_name" {
  description = "Name of the PostgreSQL Docker container"
  type        = string
  default     = "ecommerce-postgres"
}

variable "db_image" {
  description = "PostgreSQL Docker image"
  type        = string
  default     = "postgres:15-alpine"
}

variable "db_port" {
  description = "Host port mapped to PostgreSQL container"
  type        = number
  default     = 5432
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "ecommerce"
}

variable "db_user" {
  description = "PostgreSQL user"
  type        = string
  default     = "ecommerce_user"
}

variable "db_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
  default     = "ecommerce_pass"
}

variable "db_data_path" {
  description = "Host path for PostgreSQL data persistence"
  type        = string
  default     = "/tmp/ecommerce-db-data"
}

# Jenkins
variable "jenkins_container_name" {
  description = "Name of the Jenkins Docker container"
  type        = string
  default     = "jenkins"
}

variable "jenkins_image" {
  description = "Jenkins Docker image"
  type        = string
  default     = "jenkins/jenkins:lts"
}

variable "jenkins_port" {
  description = "Host port for Jenkins web UI"
  type        = number
  default     = 8080
}

variable "jenkins_agent_port" {
  description = "Host port for Jenkins agent connections"
  type        = number
  default     = 50000
}

variable "jenkins_home_volume" {
  description = "Docker volume name for Jenkins home directory"
  type        = string
  default     = "jenkins_home"
}

# Service
variable "frontend_nodeport" {
  description = "NodePort for frontend service"
  type        = number
  default     = 30080
}

variable "product_service_nodeport" {
  description = "NodePort for product service"
  type        = number
  default     = 30081
}

variable "order_service_nodeport" {
  description = "NodePort for order service"
  type        = number
  default     = 30082
}

# Docker Hub
variable "docker_registry" {
  description = "Docker registry URL"
  type        = string
  default     = "registry.hub.docker.com"
}

variable "docker_hub_username" {
  description = "Docker Hub username"
  type        = string
  default     = "yeelaine"
}
