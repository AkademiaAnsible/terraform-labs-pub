terraform {
  required_version = ">= 1.5.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
  }
}

# Local backend only (default). Intentionally no backend block defined.

resource "random_string" "example" {
  length  = var.length
  upper   = var.upper
  lower   = var.lower
  numeric = var.numeric
  special = var.special
}

locals {
  prefix = var.prefix != null && var.prefix != "" ? "${var.prefix}-" : ""
}

output "random_value" {
  description = "Generated random string value"
  value       = "${local.prefix}${random_string.example.result}"
}
