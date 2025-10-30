resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}${random_string.suffix.result}"
  location = var.location
  tags = {
    createdby = "jakumuszynski@pzu.pl"
  }
}