#!/bin/bash

set -euo pipefail

# Zaloguj się do Azure (jeśli nie jesteś zalogowany)
if ! az account show >/dev/null 2>&1; then
	echo "Nie zalogowano do Azure — uruchamiam az login..."
	az login >/dev/null
fi

# Inicjalizacja Terraform
echo "Running terraform init..."
terraform init

# Walidacja kodu
echo "Running terraform validate..."
terraform validate

# Wyświetlenie planu
echo "Running terraform plan..."
terraform plan "$@"

# Wdrożenie zasobów (wymaga potwierdzenia "yes")
echo "Running terraform apply..."
terraform apply -auto-approve "$@"

# Wyświetlenie outputów
echo "Running terraform output..."
terraform output

# Aby usunąć zasoby, odkomentuj poniższą linię
# echo "Running terraform destroy..."
# terraform destroy -auto-approve
