variable "location" {
  description = "Region Azure, w którym zostaną utworzone zasoby."
  type        = string
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "Nazwa grupy zasobów."
  type        = string
  default     = "tf-lab2-rg"
}

variable "random_postfix_z_rg" {
  description = "losowy ciag znakow"
  type        = string
  default     = "tsdsfdx"
}