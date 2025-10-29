variable "project" {
  description = "Project name prefix"
  type        = string
  default     = "tfca"
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

variable "image" {
  description = "Container image for Container App"
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "target_port" {
  description = "Target port exposed by the container"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "vCPU for container"
  type        = number
  default     = 0.5
}

variable "memory" {
  description = "Memory (Gi) for container"
  type        = number
  default     = 1.0
}

variable "env" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "second_image" {
  description = "Optional image for the second Container App (from ACR). When set, a second ACA is deployed."
  type        = string
  default     = ""
}

variable "build_and_push" {
  description = "When true, build the sample app image and push to the created ACR, then deploy as app2. Requires local Docker or az acr build depending on build_method."
  type        = bool
  default     = false
}

variable "build_method" {
  description = "Build method: 'docker' (local docker build+push) or 'acr' (use az acr build)."
  type        = string
  default     = "docker"
  validation {
    condition     = contains(["docker", "acr"], var.build_method)
    error_message = "build_method must be 'docker' or 'acr'"
  }
}

variable "image_repo" {
  description = "Repository name in ACR for the sample image (e.g., 'przykladowa-aplikacja')."
  type        = string
  default     = "przykladowa-aplikacja"
}

variable "image_tag" {
  description = "Tag for the built image. Defaults to 'latest' if empty."
  type        = string
  default     = "latest"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    CreatedBy = "terraform"
    Lab       = "9"
  }
}
