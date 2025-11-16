# Rozdział 1: Wprowadzenie i przygotowanie środowiska

## Cel rozdziału
- Poznasz cele szkolenia i zakres materiału.
- Przygotujesz środowisko do pracy z Terraform na platformie Azure.
- Skonfigurujesz narzędzia, repozytorium oraz dostęp do subskrypcji.

## Dlaczego to ważne?
Solidne przygotowanie eliminuje „hałas” techniczny podczas dalszych modułów. Ujednolicone wersje narzędzi i wspólny model uwierzytelniania (OIDC / Azure CLI) zapobiegają niespójnym wynikom `plan` między uczestnikami.

## Zakres tematyczny
- Omówienie agendy i celów szkolenia.
- Wymagania wstępne: konto Azure, uprawnienia, narzędzia (Terraform, Azure CLI, edytor kodu).
- Instalacja i konfiguracja narzędzi.
- Klonowanie repozytorium z ćwiczeniami.
- Logowanie do Azure i weryfikacja dostępu.
- Struktura katalogów i plików w repozytorium.
- Przykładowy workflow: `terraform init`, `terraform plan`.

## Komponenty środowiska
| Element | Rekomendowana wersja | Uzasadnienie |
|---------|----------------------|--------------|
| Terraform | >= 1.13.x | Stabilne meta-argumenty, możliwość użycia nowszych funkcji (dynamic ulepszenia) |
| AzureRM Provider | Najnowsza 3.x | Obsługa aktualnych zasobów i atrybutów, mniej deprecated fields |
| Azure CLI | Aktualna | Spójne auth dla CLI backend / provider |
| VS Code + Terraform ext | Najnowsza | Fmt, syntax highlight, podstawowe lint |

## Instalacja (przykład na Linux)
```bash
curl -fsSL https://aka.ms/install-terraform.sh | bash   # hipotetyczny skrypt org, lub pobranie binarki
terraform -version
az upgrade --yes
az login
```

## Struktura repo (fragment)
```text
terraform-labs/
	lab0/        # pierwsze ćwiczenia
	zaawansowane/rozdzialy/  # materiały teoretyczne
	scripts/     # narzędzia pomocnicze
```

## Minimalny przykład konfiguracji
`main.tf`:
```hcl
terraform {
	required_version = ">= 1.13.0"
	required_providers {
		azurerm = {
			source  = "hashicorp/azurerm"
			version = "~> 3.99"
		}
	}
}

provider "azurerm" {
	features {}
}

resource "azurerm_resource_group" "demo" {
	name     = "rg-demo-intro"
	location = "westeurope"
}
```

## Kroki weryfikacji
1. `terraform init` – pobranie providera.
2. `terraform plan` – powinien pokazać 1 zasób do utworzenia.
3. Brak ostrzeżeń o wersjach.

## Typowe problemy i rozwiązania
| Problem | Przyczyna | Rozwiązanie |
|---------|-----------|-------------|
| Błąd autoryzacji | Nie zalogowano `az login` | Wykonaj ponownie logowanie, sprawdź `az account show` |
| Niezgodna wersja provider | Stara cache `.terraform` | `terraform init -upgrade` |
| Brak subskrypcji | Uprawnienia niedodane | Poproś admina o rolę / przypisanie subskrypcji |

## Ćwiczenie
1. Zmień nazwę RG na zawierającą swoje inicjały.
2. Uruchom `terraform apply`.
3. Sprawdź w Azure Portal czy zasób się pojawił.

## Dobre praktyki startowe
- Pinuj wersje providerów (semver z ~>).
- Nie rozpoczynaj od tworzenia wielu zasobów naraz – najpierw prosty RG.
- Zapisuj notatki zmian środowiska (audyt konfiguracji).

## Efekt końcowy (rozszerzony)
- Działające narzędzia (Terraform, Azure CLI, edytor).
- Utworzone pierwsze zasoby testowe.
- Zrozumienie roli plików: root module vs przyszłe moduły.

## Następny krok
Przejście do mechanizmów modularności (`Rozdział 2`).

## Wskazówki
- Upewnij się, że masz zainstalowane: Terraform (>=1.5), Azure CLI, edytor (np. VS Code).
- Zaloguj się do Azure: `az login`.
- Sprawdź subskrypcję: `az account show`.
- Skonfiguruj zmienne środowiskowe, jeśli to konieczne (np. ARM_SUBSCRIPTION_ID).

## Efekt końcowy
- Gotowe środowisko do dalszych ćwiczeń.
- Zweryfikowany dostęp do Azure i repozytorium.
- Umiejętność uruchomienia podstawowych komend Terraform.
