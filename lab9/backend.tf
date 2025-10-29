terraform {
  backend "azurerm" {}

  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.2"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Note: The docker provider connects to a local Docker daemon. It is only
# used when build_and_push=true; otherwise no docker resources are created.
provider "docker" {}
