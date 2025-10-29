output "storage_outputs" {
  description = "Wartości wyjściowe z modułów storage."
  value = {
    for key, env in module.storage_env : key => {
      resource_group_name  = env.resource_group_name
      storage_account_name = env.storage_account_name
    }
  }
}
