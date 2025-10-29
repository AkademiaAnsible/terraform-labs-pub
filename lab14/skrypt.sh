#!/bin/bash
set -e
TERRAFORM_BIN=${TERRAFORM_BIN:-terraform}
$TERRAFORM_BIN fmt
$TERRAFORM_BIN init -backend-config=backend.hcl
$TERRAFORM_BIN validate
$TERRAFORM_BIN plan -var-file=dev.tfvars
# Uncomment to apply
# $TERRAFORM_BIN apply -var-file=dev.tfvars
