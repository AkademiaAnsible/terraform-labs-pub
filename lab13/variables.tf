variable "project" {
  description = "Project name prefix"
  type        = string
  default     = "tfkv"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "Existing RG name to reuse; if null, a new RG is created"
  type        = string
  default     = null
}

variable "current_user_object_id" {
  description = "Object ID (GUID) użytkownika lub SP, któremu nadać rolę Key Vault Secrets Officer. Jeśli null, spróbujemy wykryć przez data.azurerm_client_config."
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    CreatedBy = "terraform"
    Lab       = "13"
  }
}
