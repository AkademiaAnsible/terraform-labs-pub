# Rozdział 12: Budowa złożonego środowiska, pipeline, PR, testy, zatwierdzenie

## Cel rozdziału
- Poznasz praktyczne aspekty budowy złożonych środowisk w Terraform.
- Nauczysz się integrować wiele zasobów, korzystać z pipeline, testów i procesu zatwierdzania zmian.
- Zrozumiesz, jak wdrażać infrastrukturę w sposób bezpieczny i powtarzalny.

## Zakres tematyczny
- Projektowanie złożonych środowisk (np. AIFoundry, AIServices, Encryption, UAI, FunctionApp, Storage).
- Integracja wielu modułów i zasobów.
- Pipeline: automatyzacja wdrożeń, testy, approval flow.
- Przykład procesu PR: review, testy, zatwierdzenie.
- Best practices: podział na środowiska, kontrola zmian, rollback.

## Wskazówki
- Planuj środowisko jako zestaw powiązanych modułów.
- Automatyzuj testy i wdrożenia przez pipeline.
- Wdrażaj approval flow i kontrolę zmian na produkcji.
- Dokumentuj architekturę i procesy wdrożeniowe.

## Efekt końcowy
- Umiejętność budowy i wdrażania złożonych środowisk.
- Bezpieczny, powtarzalny i kontrolowany proces wdrożeniowy.
- Gotowość do pracy z dużymi projektami i zespołami.

## Architektura przykładowa (zarys)
| Komponent | Cel |
|-----------|-----|
| VNet + Subnets | Segmentacja ruchu |
| Key Vault | Sekrety i klucze szyfrujące |
| User Assigned Identity | Dostęp zasobów do Key Vault bez sekretów |
| Storage Account (blob + files) | Dane aplikacyjne / artefakty |
| Function App / Container App | Warstwa logiki |
| Log Analytics | Monitoring i audyt |

## Kroki integracji
1. Utwórz moduły bazowe (network, security, storage, compute).
2. Zdefiniuj wspólne `locals { tags = {...} }`.
3. Provision identity → nadaj rolę Key Vault Secrets User.
4. Utwórz Key Vault + sekret.
5. Function App pobiera sekret (uwaga: secret w stanie jeśli bezpośrednio w kodzie – prefer referencję runtime).
6. Dodaj pipeline z etapami plan/apply.

## Przykład orkiestracji modułów
```hcl
module "network" {
	source   = "../modules/network"
	vnet_cidr = "10.20.0.0/16"
	subnets   = { app = { cidr = "10.20.1.0/24" } }
}

module "key_vault" { /* ... */ }
module "storage"   { /* ... */ }
module "function"  { /* ... depends on identity & storage */ }
```

## Testowanie złożone
- Najpierw plan modułu network – minimalny blast radius.
- Dodawaj kolejne moduły iteracyjnie.
- Wprowadź `terraform validate` + lint w PR przed apply.

## Rollback strategia
W IaC brak klasycznego rollback – użyj wcześniejszego commit + ponowny plan; unikaj manualnych zmian. Krytyczne dane w Storage – snapshoty.

## Pułapki
- Kolejność: brak implicit dependencies → race conditions (rozwiązać referencjami).
- Sekrety w logach planu – usuń wrażliwe outputy.

## Ćwiczenie (koncepcyjne)
Dodaj drugą Function App korzystającą z tego samego Key Vault – oceń czy trzeba rozdzielić sekrety (naming konwencja). 

## Efekt końcowy
- Spójnie wdrożone, modułowe środowisko z pipeline.

## Zakończenie
Przygotowanie do produkcyjnego wdrożenia: standaryzacja, bezpieczeństwo, automatyzacja.

