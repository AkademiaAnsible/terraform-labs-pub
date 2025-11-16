variable "resource_group_name" {
  type        = string
  description = "Nazwa istniejącej grupy zasobów do importu"
}

variable "location" {
  type        = string
  description = "Region Azure (zgodny z istniejącym zasobem)"
  default     = "westeurope"
}

variable "tags" {
  type        = map(string)
  description = "Tagi dla zasobów"
  default     = {}
}
