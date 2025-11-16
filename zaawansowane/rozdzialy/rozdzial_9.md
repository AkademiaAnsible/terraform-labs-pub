# Rozdział 9: Standardy walidacji i bezpieczeństwa kodu

## Cel rozdziału
- Poznasz narzędzia i praktyki walidacji oraz bezpieczeństwa kodu Terraform.
- Nauczysz się wdrażać reguły, polityki i automatyczne testy bezpieczeństwa.
- Zrozumiesz, jak chronić infrastrukturę przed błędami i podatnościami.

## Zakres tematyczny
- Przegląd narzędzi: tflint, checkov, tfsec, pre-commit.
- Tworzenie i egzekwowanie reguł bezpieczeństwa (np. zakaz publicznych IP, wymuszanie tagów).
- Przykłady polityk i reguł (organizacyjne, projektowe).
- Automatyzacja walidacji w pipeline CI/CD.
- Raportowanie i reagowanie na naruszenia.
- Best practices: minimalizacja uprawnień, ochrona sekretów, audyt zmian.

## Wskazówki
- Wdrażaj pre-commit hooks do automatycznej walidacji kodu.
- Regularnie aktualizuj narzędzia i reguły bezpieczeństwa.
- Analizuj raporty i reaguj na ostrzeżenia.
- Dokumentuj polityki i wymagania bezpieczeństwa.

## Efekt końcowy
- Umiejętność wdrażania i egzekwowania standardów bezpieczeństwa kodu.
- Automatyczna walidacja i testy bezpieczeństwa w procesie CI/CD.
- Bezpieczna i zgodna z politykami infrastruktura.

## Narzędzia
| Narzędzie | Funkcja | Przykład użycia |
|-----------|---------|-----------------|
| terraform fmt/validate | Format + składnia | `terraform fmt -recursive` |
| tflint | Lint provider i ogólne | `tflint --config .tflint.hcl` |
| checkov / tfsec | Security i compliance | `checkov -d .` |
| pre-commit | Automatyzacja hooków | Konfiguracja w `.pre-commit-config.yaml` |

## Przykład pre-commit
```yaml
repos:
	- repo: https://github.com/antonbabenko/pre-commit-terraform
		rev: v1.83.0
		hooks:
			- id: terraform_fmt
			- id: terraform_validate
			- id: terraform_tflint
```

## Polityki przykładowe
- Wymagane tagi: `Environment`, `Owner`, `CostCenter`.
- Zakaz publicznych IP dla VM w prod.
- Minimalna wersja TLS w Storage = TLS1_2.

## Raportowanie
Zbieraj wyniki scanów → artefakt pipeline / dashboard (np. Security tab GitHub).

## Reakcja na naruszenia
1. Kategoryzacja (wysokie/krytyczne vs informacyjne).
2. Ticket / issue.
3. Poprawka + ponowne skanowanie.

## Pułapki
- Ignorowanie ostrzeżeń „informational” – mogą stać się realnym ryzykiem później.
- Nadmierne wyciszanie reguł (skip) – zmniejsza skuteczność.

## Ćwiczenie
Uruchom `checkov -d .` i zidentyfikuj pierwszy krytyczny wynik – zaproponuj poprawkę.

## Efekt końcowy
- Ustanowione procesy walidacji i bezpieczeństwa.

## Następny krok
Hardenowanie i validate zasobów (`Rozdział 10`).
