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

terraform init -reconfigure "$@"
terraform validate
terraform plan ${VAR_FILE} "$@"
terraform apply -auto-approve ${VAR_FILE} "$@"

FQDN=$(terraform output -raw container_app_fqdn || true)
if [[ -n "${FQDN}" ]]; then
  echo "Open: https://${FQDN}"
fi
