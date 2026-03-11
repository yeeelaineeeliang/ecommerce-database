locals {
  profile_name = "ecommerce-${var.environment}"
}

resource "null_resource" "minikube_config" {
  triggers = {
    cpus      = var.cpus
    memory    = var.memory
    disk_size = var.disk_size
    driver    = var.driver
    profile   = local.profile_name
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-CMD
      minikube config set cpus ${var.cpus} -p ${local.profile_name} 2>/dev/null || true
      minikube config set memory ${var.memory} -p ${local.profile_name} 2>/dev/null || true
      minikube config set disk-size ${var.disk_size} -p ${local.profile_name} 2>/dev/null || true
      minikube config set driver ${var.driver} -p ${local.profile_name} 2>/dev/null || true
      STATUS=$(minikube status -p ${local.profile_name} --format='{{.Host}}' 2>/dev/null || echo "Stopped")
      if [ "$STATUS" != "Running" ]; then
        echo "Starting Minikube"
        minikube start --cpus=${var.cpus} --memory=${var.memory} --disk-size=${var.disk_size} --driver=${var.driver} -p ${local.profile_name}
      else
        echo "Minikube already running."
      fi
    CMD
  }
}

resource "null_resource" "k8s_namespaces" {
  depends_on = [null_resource.minikube_config]
  for_each   = toset(var.namespaces)
  triggers = {
    namespace    = each.value
    profile      = local.profile_name
    cpu_limit    = var.cpu_limit
    memory_limit = var.memory_limit
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-CMD
      kubectl create namespace ${each.value} --context=${local.profile_name} 2>/dev/null || echo "Namespace ${each.value} already exists"
      cat <<QUOTA | kubectl apply -f - --context=${local.profile_name}
apiVersion: v1
kind: ResourceQuota
metadata:
  name: ${each.value}-quota
  namespace: ${each.value}
spec:
  hard:
    limits.cpu: "${var.cpu_limit}"
    limits.memory: "${var.memory_limit}"
    pods: "20"
QUOTA
    CMD
  }
}

resource "null_resource" "kubeconfig_info" {
  depends_on = [null_resource.minikube_config]
  triggers = {
    profile = local.profile_name
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "minikube ip -p ${local.profile_name} 2>/dev/null || echo '127.0.0.1'"
  }
}
