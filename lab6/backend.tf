terraform {
  # Remote backend: Azure Storage Account
  # NOTE: Backend blocks cannot reference variables or expressions.
  # Configure via:
  #   terraform init \
  #     -backend-config="storage_account_name=<name>" \
  #     -backend-config="container_name=<container>" \
  #     -backend-config="key=lab6.terraform.tfstate" \
  #     [-backend-config="resource_group_name=<rg>" if lookup needed]
  # Or with a backend.hcl file: terraform init -backend-config=backend.hcl
  #backend "azurerm" {}

  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
  }
}

provider "azurerm" {
  features {}
}
