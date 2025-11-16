# Rozdział 11: Terragrunt, Terramate i inne narzędzia

## Cel rozdziału
- Poznasz narzędzia wspierające zarządzanie infrastrukturą na dużą skalę: Terragrunt, Terramate, inne alternatywy.
- Nauczysz się podstawowych funkcji, zalet i ograniczeń tych narzędzi.
- Zrozumiesz, kiedy i jak warto je stosować w projektach.

## Zakres tematyczny
- Czym jest Terragrunt? Przegląd funkcji, use-case'y, przykłady.
- Czym jest Terramate? Różnice i podobieństwa do Terragrunt.
- Inne narzędzia: Atmos, Spacelift, OpenTofu, HCP Terraform.
- Przykłady integracji z pipeline CI/CD.
- Best practices: modularność, DRY, zarządzanie środowiskami.

## Wskazówki
- Terragrunt ułatwia zarządzanie wieloma środowiskami i kodem DRY.
- Terramate pozwala generować katalogi, automatyzować workflow.
- Wybierz narzędzie dopasowane do potrzeb i skali projektu.
- Testuj narzędzia na małych przykładach przed wdrożeniem w organizacji.

## Efekt końcowy
- Świadomość narzędzi wspierających zarządzanie infrastrukturą.
- Umiejętność wyboru i wdrożenia odpowiedniego narzędzia w projekcie.
- Gotowość do pracy z dużymi, złożonymi środowiskami Terraform.

## Porównanie narzędzi (skrót)
| Narzędzie | Główne zalety | Use‑case |
|-----------|---------------|---------|
| Terragrunt | DRY dla wielu środowisk, wrapper nad Terraform | Duże portfolio environmentów |
| Terramate | Generacja scaffold, orchestracja komend | Standaryzacja struktury repo |
| Atmos | Zarządzanie konfiguracją (YAML) | Scentralizowana konfiguracja |
| Spacelift/HCP Terraform | Platforma zarządzania, policy sets | Enterprise governance |

## Terragrunt przykład konfiguracyjny (zarys)
`terragrunt.hcl`:
```hcl
remote_state {
	backend = "azurerm"
	config = {
		container_name       = "tfstate"
		key                  = "${path_relative_to_include()}/terraform.tfstate"
		storage_account_name = "stsharedstate"
	}
}

include "root" {
	path = find_in_parent_folders()
}
```

## Kiedy NIE używać
- Mały projekt z jednym środowiskiem – dodatkowa warstwa złożoności.

## Ćwiczenie (teoretyczne)
Przeanalizuj czy 5 środowisk (dev, test, qa, preprod, prod) uzasadnia Terragrunt vs czysty Terraform z mapą.

## Efekt końcowy
- Świadomość narzędzi i kiedy inwestycja się zwraca.

## Następny krok
Budowa złożonego środowiska (`Rozdział 12`).
