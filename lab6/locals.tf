locals {
  name_suffix       = substr(replace(lower(var.project_name), " ", "-"), 0, 12)
  rg_name_effective = coalesce(var.resource_group_name != "" ? var.resource_group_name : null, "${local.name_suffix}-rg")
  tags = {
    Project     = var.project_name
    Environment = "lab6"
    CreatedBy   = "terraform"
  }
}
