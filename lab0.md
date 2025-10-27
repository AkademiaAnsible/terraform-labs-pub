# Lab 0: Pure Terraform (local backend)

This warm-up lab uses only the `random` provider to generate a string. No Azure resources and only the default local backend.

## Run
```
cd lab0
./skrypt.sh -f dev.tfvars
```

## Notes
- No backend block is defined, so Terraform uses the local backend (state file: `terraform.tfstate` in the folder).
- Tweak `variables.tf` to change length or character sets; use `prefix` to prepend a value.
