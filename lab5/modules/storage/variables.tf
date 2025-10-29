variable "resource_group_name" {
  description = "Nazwa grupy zasobów."
  type        = string
}

variable "storage_account_name" {
  description = "Nazwa konta magazynu."
  type        = string
}

variable "location" {
  description = "Region Azure."
  type        = string
}

variable "subnet_id" {
  description = "ID podsieci, w której zostanie umieszczony Private Endpoint."
  type        = string
}

variable "container_name" {
  description = "Nazwa kontenera blob."
  type        = string
}
