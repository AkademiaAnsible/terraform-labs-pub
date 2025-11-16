#!/bin/bash
# Skrypt pomocniczy dla Lab Advanced 13

set -e

echo "=== Lab Advanced 13: Logic App Standard z Private VNet Integration ==="
echo ""

# Kolory
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Funkcje pomocnicze
function step() {
  echo -e "${GREEN}[KROK]${NC} $1"
}

function warning() {
  echo -e "${YELLOW}[UWAGA]${NC} $1"
}

# 1. Sprawdzenie środowiska
step "Sprawdzanie środowiska..."
if ! command -v terraform &> /dev/null; then
  echo "Terraform nie jest zainstalowany!"
  exit 1
fi

if ! command -v az &> /dev/null; then
  echo "Azure CLI nie jest zainstalowane!"
  exit 1
fi

terraform version
az version --output tsv | head -n 1

# 2. Weryfikacja logowania
step "Weryfikacja logowania do Azure..."
az account show || { echo "Zaloguj się: az login"; exit 1; }

# 3. Konfiguracja backendu
if [ ! -f "backend.hcl" ]; then
  warning "Brak pliku backend.hcl - skopiuj z backend.hcl.example i dostosuj"
  echo "cp backend.hcl.example backend.hcl"
  echo "nano backend.hcl"
  exit 1
fi

# 4. Inicjalizacja
step "Inicjalizacja Terraform..."
terraform init -backend-config=backend.hcl

# 5. Walidacja
step "Walidacja konfiguracji..."
terraform validate

# 6. Formatowanie
step "Formatowanie kodu..."
terraform fmt -recursive

# 7. Planowanie
step "Planowanie zmian..."
terraform plan -var-file=dev.tfvars -out=tfplan

# 8. Potwierdzenie
echo ""
warning "Przed zastosowaniem sprawdź plan powyżej!"
echo "Aby wdrożyć, uruchom: terraform apply tfplan"
echo ""
echo "Aby wyczyścić zasoby: terraform destroy -var-file=dev.tfvars"
