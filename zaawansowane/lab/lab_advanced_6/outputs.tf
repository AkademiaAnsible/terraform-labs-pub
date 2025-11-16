output "vnet_id" {
  value       = module.network.vnet_id
  description = "ID utworzonego VNet"
}

output "subnet_ids" {
  value       = module.network.subnet_ids
  description = "ID utworzonych podsieci"
}
