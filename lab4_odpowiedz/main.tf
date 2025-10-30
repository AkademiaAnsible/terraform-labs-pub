#resource "random_string" "suffix" {
#  length  = 6
#  special = false
#  upper   = false
#}

module "naszaresourcegroup" {
  source = "./modules/rg"

  location            = var.location
  resource_group_name = "rg-lab4-kuba"

}

module "naszstorage" {
  source = "./modules/storage_account"

  random_postfix_z_rg = module.naszaresourcegroup.random_postfix
  resource_group_name = module.naszaresourcegroup.rg_name
}