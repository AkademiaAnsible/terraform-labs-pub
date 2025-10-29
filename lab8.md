# Lab 8: Azure Container Instance (ACI)

Provision an Azure Container Instance with a public FQDN and run a sample image.

## What it does
- Creates Resource Group
- Deploys ACI with public IP and DNS label
- Exposes a configurable port (default 80)
- Supports env vars and optional custom command

## Prereqs
- Terraform >= 1.5, Azure CLI logged in

## Backend (optional)
```
cd lab8
cp backend.hcl.example backend.hcl
terraform init -backend-config=backend.hcl
```

## Run
```
cd lab8
./skrypt.sh -f dev.tfvars
```

## Test
```
FQDN=$(terraform output -raw aci_fqdn)
curl -s http://$FQDN | head
```

## Destroy
```
terraform destroy -auto-approve -var-file=dev.tfvars
```
