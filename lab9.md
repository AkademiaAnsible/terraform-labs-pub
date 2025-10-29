# Lab 9: Azure Container Apps — Hello World

Provision Azure Container Apps Environment and a Container App exposed publicly.

## What it does
- Creates Resource Group
- Creates Container Apps Environment
- Deploys a Container App (Single revision) with public ingress
- Exposes target port and returns a Hello World page

## Prereqs
- Terraform >= 1.5, Azure CLI logged in
- Provider azurerm >= 4.x

## Backend (optional)
```
cd lab9
cp backend.hcl.example backend.hcl
terraform init -backend-config=backend.hcl
```

## Run
```
cd lab9
./skrypt.sh -f dev.tfvars
```

## (Optional) Build and deploy your own app as a second ACA
Option A: Let Terraform build and push for you

Prereqs:
- For build_method=docker: local Docker daemon running and logged in to ACR is not required (Terraform will push using the docker provider)
- For build_method=acr: Azure CLI installed (az) and logged in; no local Docker needed

Run one of:
```
# Local Docker build+push
terraform apply -auto-approve -var-file=dev.tfvars -var="build_and_push=true" -var="build_method=docker" -var="image_repo=hello" -var="image_tag=1.0"

# ACR cloud build (no local Docker)
terraform apply -auto-approve -var-file=dev.tfvars -var="build_and_push=true" -var="build_method=acr" -var="image_repo=hello" -var="image_tag=1.0"
```

Option B: Build and push manually, then point Terraform at the tag
1) Build and push image to ACR:
```
ACR=$(terraform output -raw acr_login_server)
az acr login --name ${ACR%%.*}
docker build -t $ACR/hello:1.0 ./przykladowa_aplikacja
docker push $ACR/hello:1.0
```
2) Re-apply with second image:
```
terraform apply -auto-approve -var-file=dev.tfvars -var="second_image=$ACR/hello:1.0"
```
3) Get second FQDN:
```
terraform output -raw container_app2_fqdn
```

## Test
```
FQDN=$(terraform output -raw container_app_fqdn)
curl -s https://$FQDN | head
```

## Destroy
```
terraform destroy -auto-approve -var-file=dev.tfvars
```
