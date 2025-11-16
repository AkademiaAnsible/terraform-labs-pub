# Global TFLint configuration
# Docs: https://github.com/terraform-linters/tflint

plugin "azurerm" {
  enabled = true
  version = "0.29.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# Enable module inspection when running in root of labs
# Can be overridden per-run using --module flag
config {
  module = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = false
}

## Exclude vendored or generated directories
#ignore_paths = [
#  ".terraform",
#  "**/.terraform/**",
#]
