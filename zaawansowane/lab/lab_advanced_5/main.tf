# Lab Advanced 5: Import zasobów do Terraform

provider "azurerm" {
  features {}
}

# Przykład: Import istniejącej grupy zasobów
resource "azurerm_resource_group" "imported" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
