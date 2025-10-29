#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="dev.tfvars"

if [ ! -f "$ENV_FILE" ]; then
  echo "Brak pliku $ENV_FILE" >&2
  exit 1
fi

terraform init -upgrade
terraform validate
terraform plan -var-file="$ENV_FILE" -out=lab10.tfplan
terraform apply lab10.tfplan

# Pokazanie mount na VM (przykład komendy do ręcznego wykonania):
echo "Po utworzeniu zasobów wykonaj na VM: ls -l /mnt/blobdata" 
