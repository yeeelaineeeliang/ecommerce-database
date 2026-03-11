resource "null_resource" "db_data_dir" {
  triggers = {
    data_path = var.data_path
  }
  provisioner "local-exec" {
    command = "mkdir -p ${var.data_path}"
  }
}

resource "null_resource" "postgres_container" {
  depends_on = [null_resource.db_data_dir]
  triggers = {
    container_name = var.container_name
    image          = var.image
    host_port      = var.host_port
    db_name        = var.db_name
    db_user        = var.db_user
    data_path      = var.data_path
    environment    = var.environment
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-CMD
      RUNNING=$(docker inspect --format='{{.State.Running}}' ${var.container_name} 2>/dev/null || echo "false")
      if [ "$RUNNING" = "true" ]; then
        echo "Already running. Skipping."
      else
        docker rm -f ${var.container_name} 2>/dev/null || true
        docker run -d \
          --name ${var.container_name} \
          --restart unless-stopped \
          -e POSTGRES_DB=${var.db_name} \
          -e POSTGRES_USER=${var.db_user} \
          -e POSTGRES_PASSWORD=${var.db_password} \
          -p ${var.host_port}:5432 \
          -v ${var.data_path}:/var/lib/postgresql/data \
          --label environment=${var.environment} \
          --label managed_by=terraform \
          ${var.image}
        echo "Waiting for PostgreSQL"
        for i in $(seq 1 30); do
          docker exec ${var.container_name} pg_isready -U ${var.db_user} -d ${var.db_name} 2>/dev/null && echo "Ready!" && break
          echo "Attempt $i/30..."
          sleep 2
        done
      fi
      docker inspect --format='{{.State.Status}}' ${var.container_name}
    CMD
  }
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/bash", "-c"]
    command     = "docker stop ${self.triggers.container_name} 2>/dev/null || true"
  }
}

resource "null_resource" "db_schema" {
  depends_on = [null_resource.postgres_container]
  triggers = {
    container_name = var.container_name
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-CMD
      sleep 3
      docker exec ${var.container_name} psql -U ${var.db_user} -d ${var.db_name} -c "
        CREATE TABLE IF NOT EXISTS products (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          price DECIMAL(10,2),
          stock INTEGER DEFAULT 0,
          created_at TIMESTAMP DEFAULT NOW()
        );
        CREATE TABLE IF NOT EXISTS orders (
          id SERIAL PRIMARY KEY,
          product_id INTEGER REFERENCES products(id),
          quantity INTEGER NOT NULL,
          status VARCHAR(50) DEFAULT 'pending',
          created_at TIMESTAMP DEFAULT NOW()
        );
        SELECT 'Schema ready' AS result;
      " 2>/dev/null || echo "Schema already exists"
    CMD
  }
}
