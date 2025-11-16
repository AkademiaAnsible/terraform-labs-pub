# Rozdział 8: Integracja z CI/CD, pipelines, walidacja kodu, approval flow, testy PR

## Cel rozdziału
- Poznasz zasady integracji Terraform z pipeline CI/CD (np. GitHub Actions, Azure Pipelines).
- Nauczysz się automatyzować walidację, testy i wdrożenia kodu.
- Zrozumiesz procesy approval flow i testów PR.

## Etapy Pipeline (przykład GitHub Actions)
1. Checkout kodu.
2. Fmt / Validate.
3. Static analiza (tflint, checkov).
4. Plan (z artefaktem planu).
5. Manual approve (environment protection / PR review).
6. Apply (OIDC, minimalne uprawnienia).

## Przykładowy workflow (fragment)
```yaml
jobs:
	plan:
		runs-on: ubuntu-latest
		permissions:
			id-token: write
			contents: read
		steps:
			- uses: actions/checkout@v4
			- name: Setup Terraform
				uses: hashicorp/setup-terraform@v2
				with:
					terraform_version: 1.13.6
			- name: Terraform Init
				run: terraform init -backend-config="storage_account_name=$STATE_SA" -backend-config="container_name=tfstate" -backend-config="key=prod.tfstate"
			- name: Terraform Plan
				run: terraform plan -out plan.bin
			- name: Show Plan
				run: terraform show -no-color plan.bin | tee plan.txt
			- name: Upload Plan
				uses: actions/upload-artifact@v4
				with:
					name: plan
					path: plan.bin
```

## Approval Flow
Zastosuj zabezpieczenia: wymagane review przed merge / environment protection (`production` environment wymaga zatwierdzenia).

## Bezpieczeństwo w pipeline
- OIDC zamiast statycznych sekretów.
- Brak wycieku state: backend remote.
- Maskowanie w logach (narzędzia CI zwykle automatyczne).

## Ćwiczenie
Dodaj krok `tflint` oraz warunek zatrzymujący pipeline gdy znajdzie ostrzeżenia wysokiego priorytetu.

## Pułapki
- Uruchamianie `apply` w gałęzi feature – ryzyko nieautoryzowanych zmian.
- Przechowywanie plan.bin w repo – niepotrzebne, może zawierać wrażliwe dane.
- Zbyt szerokie uprawnienia identyfikatora OIDC (Contributor vs specyficzne role).

## Efekt końcowy
- Zautomatyzowany proces zapewniający jakość i kontrolę.

## Następny krok
Standardy bezpieczeństwa (`Rozdział 9`).

## Zakres tematyczny
- Przegląd narzędzi CI/CD dla Terraform (GitHub Actions, Azure Pipelines, GitLab CI).
- Automatyzacja: terraform fmt, validate, tflint, checkov, plan, apply.
- Approval flow: review, zatwierdzanie zmian, ochrona gałęzi.
- Testy PR: automatyczne uruchamianie walidacji i planu na pull request.
- Przykładowe workflow i szablony pipeline.
- Najlepsze praktyki: bezpieczeństwo, przechowywanie sekretów, minimalizacja uprawnień.

## Wskazówki
- Rozdzielaj etapy walidacji, planowania i wdrożenia.
- Wykorzystuj narzędzia do analizy statycznej (tflint, checkov).
- Stosuj approval flow i ochronę gałęzi na produkcji.
- Przechowuj sekrety poza repozytorium (np. GitHub Secrets, Azure Key Vault).

## Efekt końcowy
- Umiejętność budowy pipeline CI/CD dla Terraform.
- Automatyczna walidacja i testy kodu przy każdym PR.
- Bezpieczny i powtarzalny proces wdrożeniowy.
