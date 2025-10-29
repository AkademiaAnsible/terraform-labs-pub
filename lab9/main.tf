resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

locals {
  base_name       = lower("${var.project}-${var.environment}-${random_string.suffix.result}")
  effective_tag   = trimspace(var.image_tag) == "" ? "latest" : var.image_tag
  built_image_ref = "${azurerm_container_registry.acr.login_server}/${var.image_repo}:${local.effective_tag}"
}

resource "azurerm_resource_group" "rg" {
  name     = coalesce(var.resource_group_name, "${local.base_name}-rg")
  location = var.location
  tags     = var.tags
}

resource "azurerm_container_app_environment" "env" {
  name                = "${local.base_name}-cae"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_container_app" "app" {
  name                         = "${local.base_name}-app"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"
  tags                         = var.tags

  template {
    container {
      name   = "${local.base_name}-hello"
      image  = var.image
      cpu    = var.cpu
      memory = "${var.memory}Gi"

      dynamic "env" {
        for_each = var.env
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = var.target_port
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

output "container_app_fqdn" {
  description = "Public FQDN for the Container App"
  value       = azurerm_container_app.app.latest_revision_fqdn
}

# Optional: Azure Container Registry to host a sample app for a second ACA
resource "azurerm_container_registry" "acr" {
  name                = replace("${local.base_name}acr", "-", "")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
  tags                = var.tags
}

# Give the Container Apps Environment access to pull from ACR via managed identity
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_container_app_environment.env.identity[0].principal_id
  depends_on           = [azurerm_container_app_environment.env]
}

# Optional: Build with Azure ACR Tasks via Azure CLI (no local Docker required)
resource "null_resource" "acr_build" {
  count = var.build_and_push && var.build_method == "acr" ? 1 : 0

  triggers = {
    app_py_hash = filesha256("${path.module}/przykladowa_aplikacja/app.py")
    dockerfile  = filesha256("${path.module}/przykladowa_aplikacja/Dockerfile")
    repo        = var.image_repo
    tag         = local.effective_tag
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
set -euo pipefail
echo "Building image with ACR: ${azurerm_container_registry.acr.name}"
az acr build \
  --registry ${azurerm_container_registry.acr.name} \
  --image ${var.image_repo}:${local.effective_tag} \
  ${path.module}/przykladowa_aplikacja
EOT
  }
}

# Optional: Build and push a sample image to ACR using local Docker
resource "docker_image" "sample" {
  count = var.build_and_push && var.build_method == "docker" ? 1 : 0

  name = "${azurerm_container_registry.acr.login_server}/${var.image_repo}:${local.effective_tag}"

  build {
    context    = "${path.module}/przykladowa_aplikacja"
    dockerfile = "Dockerfile"
    no_cache   = true
    platform   = "linux/amd64"
  }

  triggers = {
    app_py_hash = filesha256("${path.module}/przykladowa_aplikacja/app.py")
    dockerfile  = filesha256("${path.module}/przykladowa_aplikacja/Dockerfile")
  }
}

resource "docker_registry_image" "sample" {
  count = var.build_and_push && var.build_method == "docker" ? 1 : 0

  name = docker_image.sample[0].name
}

# Optional second Container App using either provided second_image or the built image
resource "azurerm_container_app" "app2" {
  count                        = (length(var.second_image) > 0 || var.build_and_push) ? 1 : 0
  name                         = "${local.base_name}-app2"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"
  tags                         = var.tags

  registry {
    server               = azurerm_container_registry.acr.login_server
    username             = azurerm_container_registry.acr.admin_username
    password_secret_name = "acr-pwd"
  }

  secret {
    name  = "acr-pwd"
    value = azurerm_container_registry.acr.admin_password
  }

  template {
    container {
      name   = "${local.base_name}-hello2"
      image  = length(var.second_image) > 0 ? var.second_image : local.built_image_ref
      cpu    = var.cpu
      memory = "${var.memory}Gi"

      dynamic "env" {
        for_each = var.env
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = var.target_port
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  depends_on = [
    azurerm_role_assignment.acr_pull,
    # ensure push is complete before deploy when using docker method
    docker_registry_image.sample,
    # ensure cloud build finished when using ACR method
    null_resource.acr_build
  ]
}

output "built_image" {
  description = "If build_and_push=true, the image reference built by Terraform."
  value       = var.build_and_push ? local.built_image_ref : null
}

output "container_app2_fqdn" {
  description = "Public FQDN for the second Container App (if created)"
  value       = try(azurerm_container_app.app2[0].latest_revision_fqdn, null)
}

output "acr_login_server" {
  description = "Login server for ACR"
  value       = azurerm_container_registry.acr.login_server
}
