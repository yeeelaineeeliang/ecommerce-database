# Terraform State Management

## Working With Workspaces

```bash
terraform workspace list

# Create workspaces
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# Switch workspaces
terraform workspace select dev
terraform workspace select staging
terraform workspace select prod

# Show current workspace
terraform workspace show
```

## Applying Per Environment

```bash
# Dev
terraform workspace select dev
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"

# Staging
terraform workspace select staging
terraform plan -var-file="staging.tfvars"
terraform apply -var-file="staging.tfvars"

# Prod
terraform workspace select prod
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

## Viewing Outputs (Jenkins Integration)

```bash
terraform output

# Get a specific value (used in Jenkins pipelines)
terraform output -raw minikube_cluster_url
terraform output -raw jenkins_url
terraform output -raw frontend_url
terraform output -json environment_summary
```

## State Backup Procedure

Run `./backup-state.sh` before any destructive operations.

Backups are stored in `~/.terraform-state-backups/ecommerce/`.

Manual backup:
```bash
cp -r terraform.tfstate.d/ ~/.terraform-state-backups/ecommerce/$(date +%Y%m%d-%H%M%S)/
```

## State Locking

Local backend does not support concurrent locking (no `.terraform.lock.hcl` for state).
**Rule:** Only one person runs `terraform apply` at a time in this local setup.

## Recovering From Bad State

```bash
terraform state list

# Remove a resource from state
terraform state rm null_resource.postgres_container

# Force unlock
terraform force-unlock <LOCK_ID>

# Refresh state from real infrastructure
terraform refresh -var-file="dev.tfvars"
```

## .gitignore Rules

The following are already in `.gitignore` and must NEVER be committed:
- `terraform.tfstate`
- `terraform.tfstate.d/`
- `.terraform/`
- `*.tfvars` (if they contain passwords — use environment variables for secrets in prod)
