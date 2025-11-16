// Przykładowe testy dla Lab Advanced 13 (Terratest w Go)
// Ten plik jest tylko przykładem - do uruchomienia wymaga środowiska Go + Terratest

package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestLogicAppPrivateIntegration(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		VarFiles:     []string{"dev.tfvars"},
		BackendConfig: map[string]interface{}{
			"storage_account_name": "your-state-storage",
			"container_name":       "tfstate",
			"key":                  "lab13-test.tfstate",
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Test 1: Sprawdź czy Resource Group istnieje
	rgName := terraform.Output(t, terraformOptions, "resource_group_name")
	assert.NotEmpty(t, rgName, "Resource Group name should not be empty")

	// Test 2: Sprawdź czy Storage Account ma odpowiednią nazwę
	storageName := terraform.Output(t, terraformOptions, "storage_account_name")
	assert.Contains(t, storageName, "stlogicdev", "Storage account should contain prefix")

	// Test 3: Sprawdź czy Logic App hostname jest dostępny
	hostname := terraform.Output(t, terraformOptions, "logic_app_default_hostname")
	assert.NotEmpty(t, hostname, "Logic App hostname should not be empty")
	assert.Contains(t, hostname, "azurewebsites.net", "Logic App should have Azure domain")

	// Test 4: Sprawdź czy Private Endpoint ma prywatny IP
	privateIP := terraform.Output(t, terraformOptions, "private_endpoint_blob_ip")
	if privateIP != "" {
		assert.Regexp(t, `^10\.30\.2\.\d+$`, privateIP, "Private IP should be in subnet-pe range")
	}

	// Test 5: Sprawdź czy VNet ID jest poprawny
	vnetID := terraform.Output(t, terraformOptions, "vnet_id")
	assert.Contains(t, vnetID, "/virtualNetworks/", "VNet ID should contain proper path")
}

func TestLogicAppWithoutPrivateEndpoint(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		VarFiles:     []string{"dev.tfvars"},
		Vars: map[string]interface{}{
			"enable_private_endpoint": false,
			"storage_name":            "stlogictest456",
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Sprawdź czy bez PE, private_endpoint_blob_ip jest null
	privateIP := terraform.Output(t, terraformOptions, "private_endpoint_blob_ip")
	assert.Empty(t, privateIP, "Private IP should be empty when PE disabled")
}

func TestStorageAccountValidation(t *testing.T) {
	t.Parallel()

	// Test nieprawidłowej nazwy Storage (powinien failować validation)
	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		VarFiles:     []string{"dev.tfvars"},
		Vars: map[string]interface{}{
			"storage_name": "INVALID_NAME_123", // Uppercase - błąd
		},
	}

	_, err := terraform.InitAndPlanE(t, terraformOptions)
	assert.Error(t, err, "Should fail validation for invalid storage name")
}

func TestAppServicePlanSKUValidation(t *testing.T) {
	t.Parallel()

	// Test nieprawidłowego SKU
	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		VarFiles:     []string{"dev.tfvars"},
		Vars: map[string]interface{}{
			"app_service_plan_sku": "B1", // Nie WS1/WS2/WS3 - błąd
		},
	}

	_, err := terraform.InitAndPlanE(t, terraformOptions)
	assert.Error(t, err, "Should fail validation for invalid SKU")
}
