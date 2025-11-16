# Rozdział 3: Remote backends w Terraform

## Cel rozdziału
- Poznasz ideę backendów zdalnych w Terraform.
- Nauczysz się konfigurować backend Azure Storage.
- Zrozumiesz mechanizmy blokad, bezpieczeństwa i pracy zespołowej.

## Rola backendu
Backend determinuje gdzie i jak przechowywany jest plik stanu (state). Azure Blob Storage zapewnia:
- Locking (zapobieganie równoległym apply konfliktowym).
- Trwałość i dostęp zespołowy.
- Integrację z RBAC (least privilege – rola Blob Data Contributor).

## Metody autoryzacji (skrót – rekomendacje)
| Metoda | Status | Zalety | Wady |
|--------|--------|--------|------|
| OIDC (use_oidc) | Rekomendowana | Brak sekretów, rotacja automatyczna | Wymaga konfiguracji w CI |
| Managed Identity (use_msi) | Dobra | Brak haseł, łatwe przypisanie do VM/runner | Wymaga zasobów Azure dla runnera |
| Azure CLI (use_cli) | Lokalny dev | Szybki start | Nie do CI/CD produkcyjnego |
| Access Key | Nie zalecane | Prosta konfiguracja | Statyczny klucz, ryzyko wycieku |
| SAS Token | Nie zalecane | Granularność | Trudniejsza rotacja, sekret |

## Minimalna konfiguracja backendu (OIDC – GitHub Actions)
```hcl
terraform {
	backend "azurerm" {
		use_oidc             = true
		use_azuread_auth     = true
		tenant_id            = var.tenant_id
		client_id            = var.client_id
		storage_account_name = var.state_sa
		container_name       = var.state_container
		key                  = "prod.tfstate"
	}
}
```

Parametry `tenant_id`, `client_id`, `storage_account_name`, `container_name`, `key` przekazywane jako `-backend-config` lub przez zmienne środowiskowe gdy wspierane.

## Przeniesienie lokalnego stanu
1. Posiadasz `terraform.tfstate` lokalnie.
2. Dodaj blok backend.
3. `terraform init -migrate-state` → przeniesienie blob.
4. Zweryfikuj w portal Azure w kontenerze.

## Locking – symulacja
1. Uruchom `terraform apply -auto-approve` w jednym terminalu.
2. W drugim spróbuj `terraform plan` – powinieneś zobaczyć lock (czasem komunikat o oczekiwaniu).

## Najczęstsze błędy
| Błąd | Powód | Rozwiązanie |
|------|-------|-------------|
| 403 Forbidden | Brak roli Blob Data Contributor | Nadaj rolę na kontener albo storage account |
| Timeout lock | Zerwane połączenie | Ręcznie usuń lock blob (ostrożnie) |
| Wrong key path | Literówka | Sprawdź nazwę blob w kontenerze |
| Recreate state | Usunięty blob | Odtwórz z backupu / snapshot |

## Bezpieczeństwo stanu
- Nie umieszczaj sekretów w księdze: unikaj outputów z wartościami tajnymi.
- Ogranicz dostęp: RBAC + ewentualne Private Endpoint dla Storage.
- Rozważ wersjonowanie / soft delete w kontenerze.

## Ćwiczenie
Skonfiguruj backend w trybie CLI (use_cli) lokalnie, a następnie zmień na OIDC (omów różnice w parametrach).

## Dobre praktyki
- W PIerwszej kolejności wdroż OIDC w pipeline – redukcja sekretów.
- Podziel klucze stanu per logical environment (dev.tfstate, prod.tfstate).
- Taguj storage account (Environment, Owner, TerraformState = true).

## Efekt końcowy (rozszerzony)
- Zdalny, bezpieczny backend.
- Zrozumienie metod autoryzacji i ich trade-off.
- Proces migracji stanu.

## Następny krok
Publikacja modułów (`Rozdział 4`).

## Zakres tematyczny
- Czym jest backend w Terraform i do czego służy?
- Różnice między backendem lokalnym a zdalnym.
- Konfiguracja backendu Azure Storage krok po kroku.
- Mechanizmy blokad (state locking), bezpieczeństwo stanu, uprawnienia.
- Praca zespołowa na wspólnym stanie.
- Najczęstsze problemy i ich rozwiązywanie.

## Wskazówki
- Zawsze używaj backendu zdalnego w projektach zespołowych.
- Dbaj o uprawnienia do storage i kontenera.
- Nie przechowuj plików stanu w repozytorium!
- Testuj inicjalizację i planowanie na różnych maszynach.

## Efekt końcowy
- Umiejętność konfiguracji i użycia backendu zdalnego.
- Świadomość zagrożeń i dobrych praktyk pracy ze stanem.
- Gotowość do pracy w zespole nad wspólną infrastrukturą.
