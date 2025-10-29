# Lab 14: VM with password from Key Vault secret

## Goal
Provision a VM whose admin password is read from a Key Vault secret (created in lab13).

## Steps

1. Ensure lab13 is applied and a secret (e.g., `vm-password`) exists in Key Vault.
2. You can provide either:
	- `key_vault_id` (recommended, from lab13 output), or
	- `key_vault_name` and `resource_group_name` (if you don't know the ID).
	- Always set `secret_name` to match the secret in Key Vault.
3. Run `./skrypt.sh` to validate and plan.
4. Apply to create the VM.

## Validation
- VM is created in the resource group.
- VM admin password is set from the Key Vault secret.
- Output `vm_admin_password` is sensitive and matches the secret value.

## Cleanup
Run `terraform destroy -var-file=dev.tfvars` to remove resources.

## Notes
- You must have access to the Key Vault and secret.
- The secret must be a valid password for Linux VM (min 12 chars, complexity).
