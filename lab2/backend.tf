terraform {
  # Remote backend: Azure Storage Account
  # Backend cannot use variables. Pass values during init or via backend.hcl
  # Example: terraform init \
  #   -backend-config="storage_account_name=<name>" \
  #   -backend-config="container_name=<container>" \
  #   -backend-config="key=lab2.terraform.tfstate"
  backend "azurerm" {}
}
