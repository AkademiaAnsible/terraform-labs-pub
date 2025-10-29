# Lab 13: Azure Key Vault + rola Secrets Officer

Cel: Utworzyć Key Vault i nadać sobie uprawnienia do sekretów (Key Vault Secrets Officer).

## Co tworzy
- Resource Group (jeśli nie podano istniejącej)
- Key Vault (SKU: standard, soft-delete 7 dni)
- Access policy na KV (sekrety: Get/List/Set/Delete/…)
- Role Assignment: Key Vault Secrets Officer na scope Key Vault

## Wymagania
- Terraform >= 1.5
- Azure CLI zalogowane (lub SP/Managed Identity)

## Backend (opcjonalnie)
```
cd lab13
cp backend.hcl.example backend.hcl
terraform init -backend-config=backend.hcl
```

## Uruchomienie
```
cd lab13
./skrypt.sh -f dev.tfvars
```

## Weryfikacja
- Sprawdź w Azure Portal: Key Vault > Access control (IAM) – rola Secrets Officer
- spróbuj dodać sekret (Portal lub az cli):
```
az keyvault secret set --vault-name <kv_name> --name test --value 123
```

## Sprzątanie
```
terraform destroy -auto-approve -var-file=dev.tfvars
```
