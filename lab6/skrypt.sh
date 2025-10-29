#!/bin/bash
set -euo pipefail

# Usage: ./skrypt.sh [-f varfile] [extra terraform args]
# Examples:
#   ./skrypt.sh -f dev.tfvars
#   TF_LOG=TRACE TF_LOG_PATH=./tf.log ./skrypt.sh -f dev.tfvars -refresh-only

# parse -f|--var-file convenience
VAR_FILE=""
if [[ ${1:-} == "-f" || ${1:-} == "--var-file" ]]; then
  VAR_FILE="-var-file=${2:-}"
  shift 2
fi

# init with optional backend from env
# To debug backend: export TF_LOG=TRACE TF_LOG_PATH=./tf.log
terraform init -reconfigure "$@"
terraform validate
terraform plan ${VAR_FILE} "$@"
terraform apply -auto-approve ${VAR_FILE} "$@"
