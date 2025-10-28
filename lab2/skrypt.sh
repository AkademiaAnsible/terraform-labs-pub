#!/bin/bash

set -euo pipefail

# Zmienne backendu (możesz nadpisać przez env)
BACKEND_RG=${BACKEND_RG:-"tf-backend-rg"}
BACKEND_SA_NAME=${BACKEND_SA_NAME:-"tfbackendsa$RANDOM"}
BACKEND_CONTAINER_NAME=${BACKEND_CONTAINER_NAME:-"tfstate"}
LOCATION=${LOCATION:-"West Europe"}
STATE_KEY=${STATE_KEY:-"lab2.terraform.tfstate"}

# Logowanie do Azure (jeśli potrzeba)
if ! az account show >/dev/null 2>&1; then
	echo "Nie zalogowano do Azure — uruchamiam az login..."
	az login >/dev/null
fi

# Tworzenie RG
echo "[backend] Tworzenie RG: $BACKEND_RG"
az group create --name "$BACKEND_RG" --location "$LOCATION" >/dev/null

# Tworzenie Storage Account (idempotentnie)
if ! az storage account show -n "$BACKEND_SA_NAME" -g "$BACKEND_RG" >/dev/null 2>&1; then
	echo "[backend] Tworzenie Storage Account: $BACKEND_SA_NAME"
	az storage account create --name "$BACKEND_SA_NAME" --resource-group "$BACKEND_RG" --location "$LOCATION" --sku Standard_LRS >/dev/null
fi

# Tworzenie kontenera tfstate
ACCOUNT_KEY=$(az storage account keys list -g "$BACKEND_RG" -n "$BACKEND_SA_NAME" --query "[0].value" -o tsv)
az storage container create --name "$BACKEND_CONTAINER_NAME" --account-name "$BACKEND_SA_NAME" --account-key "$ACCOUNT_KEY" >/dev/null

# Tworzenie dodatkowego kontenera 'mojstan' (na potrzeby ćwiczenia)
az storage container create --name "mojstan" --account-name "$BACKEND_SA_NAME" --account-key "$ACCOUNT_KEY" >/dev/null || true
echo "[backend] Utworzono (lub już istnieje) kontener: mojstan"

# Inicjalizacja backendu z parametrami
echo "Running terraform init (backend)..."
terraform init -reconfigure \
	-backend-config="resource_group_name=$BACKEND_RG" \
	-backend-config="storage_account_name=$BACKEND_SA_NAME" \
	-backend-config="container_name=$BACKEND_CONTAINER_NAME" \
	-backend-config="key=$STATE_KEY"

echo "Running terraform validate..."
terraform validate

echo "Running terraform plan..."
terraform plan "$@"

echo "Running terraform apply..."
terraform apply -auto-approve "$@"


##############
 export ARM_SUBSCRIPTION_ID=xxxx
 az account show
 export ARM_TENANT_ID=xxxx
 terraform init -backend-config=backend.hcl -upgrade
 terraform plan
