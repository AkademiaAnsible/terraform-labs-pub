#!/bin/bash
set -euo pipefail

# Usage: ./skrypt.sh [-f varfile] [extra terraform args]
# Examples:
#   ./skrypt.sh -f dev.tfvars

VAR_FILE=""
if [[ ${1:-} == "-f" || ${1:-} == "--var-file" ]]; then
  VAR_FILE="-var-file=${2:-}"
  shift 2
fi

terraform init "$@"
terraform validate
terraform plan ${VAR_FILE} "$@"
terraform apply -auto-approve ${VAR_FILE} "$@"

echo "Output random_value:" 
terraform output random_value || true
