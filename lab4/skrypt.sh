#!/bin/bash

set -euo pipefail

# Inicjalizacja Terraform (pobierze moduły)
echo "Running terraform init..."
terraform init "$@"

# Walidacja kodu
echo "Running terraform validate..."
terraform validate

# Wyświetlenie planu
echo "Running terraform plan..."
terraform plan "$@"

# Wdrożenie zasobów
echo "Running terraform apply..."
terraform apply -auto-approve "$@"

# Aby usunąć zasoby, odkomentuj poniższą linię
# echo "Running terraform destroy..."
# terraform destroy -auto-approve
