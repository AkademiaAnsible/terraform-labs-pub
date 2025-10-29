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

variable "kv_sku" {
  description = "Key Vault SKU (standard or premium)"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], lower(var.kv_sku))
    error_message = "kv_sku must be 'standard' or 'premium'"
  }
}

variable "assignee_object_id" {
  description = "Object ID (GUID) of user/service principal to assign 'Key Vault Secrets Officer'. Default: current caller."
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    CreatedBy = "terraform"
    Lab       = "10"
  }
}
variable "project" {
  description = "Project name prefix"
  type        = string
  default     = "tflab10"
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
  description = "Existing RG name to reuse; if null, new RG will be created"
  type        = string
  default     = null
}

variable "vnet_cidr" {
  description = "VNet address space"
  type        = string
  default     = "10.60.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet address space"
  type        = string
  default     = "10.60.1.0/24"
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "storage_account_prefix" {
  description = "Lowercase prefix for Storage Account (3-11 chars)"
  type        = string
  default     = "tf10sa"
  validation {
    condition     = can(regex("^[a-z0-9]{3,11}$", var.storage_account_prefix))
    error_message = "Prefix must be 3-11 chars: lowercase letters and digits."
  }
}

variable "blob_container_name" {
  description = "Name of blob container mounted via blobfuse2"
  type        = string
  default     = "data"
}

variable "mount_dir" {
  description = "Mount directory on the VM for the blob container"
  type        = string
  default     = "/mnt/blobdata"
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default = {
    CreatedBy = "terraform"
    Lab       = "10"
  }
}
