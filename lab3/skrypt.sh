#!/bin/bash

set -euo pipefail

# Zakłada użycie tego samego backendu co w Lab 2; w razie potrzeby przekaż -backend-config jak w lab2.

echo "Running terraform init..."
terraform init -reconfigure "$@"

echo "Running terraform validate..."
terraform validate

echo "Running terraform plan..."
terraform plan "$@"

echo "Running terraform apply..."
terraform apply -auto-approve "$@"

# echo "Running terraform destroy..."
# terraform destroy -auto-approve
