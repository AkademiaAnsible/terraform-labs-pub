# Lab Advanced 8: Pipeline CI/CD dla Terraform

## Cel laboratorium
- Przećwiczyć budowę pipeline CI/CD dla Terraform (np. GitHub Actions).
- Zautomatyzować walidację, planowanie i testy kodu przy każdym PR.

## Krok po kroku
1. Skonfiguruj repozytorium z przykładowym kodem Terraform (`main.tf`, `variables.tf`, `dev.tfvars`).
2. Dodaj przykładowy workflow GitHub Actions (`.github/workflows/terraform.yml`).
3. Przetestuj pipeline: commit, push, utwórz PR.
4. Sprawdź automatyczną walidację, plan i testy.
5. (Opcjonalnie) Dodaj narzędzia: tflint, checkov, approval flow.

### Wymagane sekrety w repozytorium GitHub
Aby akcje mogły uwierzytelnić się w Azure, ustaw sekrety w ustawieniach repozytorium (Settings → Secrets and variables → Actions):
- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

Upewnij się, że aplikacja (Service Principal) ma uprawnienia do odczytu / tworzenia zasobów używanych w laboratoriach (np. rola Contributor na subskrypcji lub grupie zasobów).

## Wyjaśnienia
- Pipeline CI/CD automatyzuje walidację i wdrożenia.
- Approval flow i testy PR zwiększają bezpieczeństwo zmian.
- Sekrety przechowuj w GitHub Secrets lub Azure Key Vault.

## Efekt końcowy
- Działający pipeline CI/CD dla Terraform.
- Automatyczna walidacja i testy kodu przy każdym PR.
