resource "null_resource" "jenkins_volume" {
  triggers = {
    volume_name = var.home_volume
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "docker volume inspect ${var.home_volume} > /dev/null 2>&1 || docker volume create ${var.home_volume}"
  }
}

resource "null_resource" "jenkins_container" {
  depends_on = [null_resource.jenkins_volume]
  triggers = {
    container_name = var.container_name
    image          = var.image
    web_port       = var.web_port
    agent_port     = var.agent_port
    home_volume    = var.home_volume
    environment    = var.environment
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-CMD
      RUNNING=$(docker inspect --format='{{.State.Running}}' ${var.container_name} 2>/dev/null || echo "false")
      if [ "$RUNNING" = "true" ]; then
        echo "Jenkins already running at http://localhost:${var.web_port}"
      else
        EXISTS=$(docker inspect ${var.container_name} 2>/dev/null | grep -c '"Id"' || echo "0")
        if [ "$EXISTS" -gt "0" ]; then
          docker start ${var.container_name}
        else
          docker run -d \
            --name ${var.container_name} \
            --restart unless-stopped \
            -p ${var.web_port}:8080 \
            -p ${var.agent_port}:50000 \
            -v ${var.home_volume}:/var/jenkins_home \
            -v /var/run/docker.sock:/var/run/docker.sock \
            --label environment=${var.environment} \
            --label managed_by=terraform \
            ${var.image}
        fi
        for i in $(seq 1 30); do
          CODE=$(curl -s -o /dev/null -w '%%{http_code}' http://localhost:${var.web_port}/login 2>/dev/null || echo "000")
          [ "$CODE" = "200" ] || [ "$CODE" = "403" ] && echo "Jenkins up!" && break
          echo "Waiting... ($i/30)"
          sleep 5
        done
      fi
      docker inspect --format='{{.State.Status}}' ${var.container_name}
    CMD
  }
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/bash", "-c"]
    command     = "echo 'Jenkins container preserved. To stop: docker stop ${self.triggers.container_name}'"
  }
}

resource "null_resource" "jenkins_health_check" {
  depends_on = [null_resource.jenkins_container]
  triggers = {
    always = timestamp()
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-CMD
      CODE=$(curl -s -o /dev/null -w '%%{http_code}' http://localhost:${var.web_port}/login 2>/dev/null || echo "000")
      echo "Jenkins HTTP status: $CODE"
    CMD
  }
}
