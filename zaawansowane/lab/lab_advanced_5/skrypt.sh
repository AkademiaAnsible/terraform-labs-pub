#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$DIR"

terraform fmt -recursive
terraform init -backend-config=backend.hcl
terraform validate
terraform plan -var-file=dev.tfvars
