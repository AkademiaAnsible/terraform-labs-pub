# Lab 11: Azure CDN + Statyczna Strona z Azure Storage (Static Website)

## Cel
Utworzyć statyczną stronę WWW hostowaną w Azure Storage (mechanizm Static Website) oraz opcjonalnie wystawić ją globalnie poprzez Azure CDN. Laboratorium pokazuje:
- Konfigurację `static_website` w `azurerm_storage_account`.
- Wgrywanie plików HTML/CSS/JS jako blobów do specjalnego kontenera `$web`.
- Utworzenie profilu i endpointu CDN (`azurerm_cdn_profile`, `azurerm_cdn_endpoint`).
- (Opcjonalnie) Podpięcie własnej domeny z certyfikatem zarządzanym przez CDN.
- Dobre praktyki cache'owania, wersjonowania i bezpieczeństwa.

## Zakres zasobów
Tworzone lub użyte zasoby:
- `azurerm_resource_group`
- `azurerm_storage_account` (z blokiem `static_website`)
- `azurerm_storage_blob` (kilka plików: `index.html`, `style.css`, `script.js`, `404.html`)
- (Opcjonalnie) `azurerm_cdn_profile`
- (Opcjonalnie) `azurerm_cdn_endpoint`
- (Opcjonalnie) `azurerm_cdn_endpoint_custom_domain`

## Struktura katalogu (fragment)
```
lab11/
   main.tf
   variables.tf
   outputs.tf
   website/
      index.html
      style.css
      script.js
      404.html
```

## Kroki
1. Przejdź do katalogu `lab11`.
2. `terraform init`
3. (Opcjonalnie) edytuj `variables.tf` ustawiając `enable_cdn = true` i ewentualne `custom_domain_name`.
4. `terraform plan` – zobacz tworzenie Storage + plików, oraz CDN gdy włączony.
5. `terraform apply` – wdrożenie.
6. Sprawdź:
    - Endpoint strony: output `website_url` (`https://<web_host>`).
    - Jeśli CDN aktywny: `cdn_endpoint_url`.
    - Jeśli domena własna: `custom_domain_url`.
7. (Domena własna) Skonfiguruj rekord CNAME kierujący na `<cdn_endpoint_fqdn>` przed tworzeniem custom domain / lub zgodnie z wymaganiami Azure CDN.

## Weryfikacja działania
Polecenia testowe:
```bash
curl -I $(terraform output -raw website_url)
curl -I $(terraform output -raw cdn_endpoint_url)
```
Sprawdź nagłówki:
- `Content-Type` dla plików CSS/JS/HTML.
- `Cache-Control` (domyślny lub skonfigurowany później przez rules).
- Przekierowanie HTTP→HTTPS (delivery rule).

## Przykładowy fragment konfiguracji static website
```hcl
resource "azurerm_storage_account" "website" {
   name                     = local.sa_name
   resource_group_name      = azurerm_resource_group.rg.name
   location                 = azurerm_resource_group.rg.location
   account_tier             = "Standard"
   account_replication_type = "LRS"
   allow_nested_items_to_be_public = true

   static_website {
      index_document     = var.index_document
      error_404_document = var.error_404_document
   }
}
```

## CDN – dobre praktyki
| Aspekt | Zalecenie |
|--------|-----------|
| SKU | `Standard_Microsoft` wystarczający dla większości labów |
| HTTPS | Wymuś HTTPS (rule / domyślne) |
| Cache | Wykorzystaj querystring z wersją (np. `app.css?v=1.2`) zamiast wyłączania cache |
| Kompresja | Włącz automatyczną kompresję (jeśli dostępne w SKU) |
| Observability | Dodaj Log Analytics / Diagnostic Settings dla profilu CDN |
| Custom Domain | Zweryfikuj DNS przed enable cert |

## Typowe błędy i rozwiązania
| Problem | Przyczyna | Rozwiązanie |
|---------|-----------|-------------|
| 404 dla index | Brak pliku w `$web` | Upewnij się, że blob `index.html` istnieje i nazwa się zgadza |
| Brak HTTPS wymuszenia | Brak delivery rule | Dodaj rule przekierowania HTTP→HTTPS w endpoint |
| Domena nie działa | CNAME jeszcze nie rozpropagowany | Poczekaj propagację DNS / sprawdź `dig` |
| Zmiana pliku nie widoczna | Cache CDN | Wymuś wersjonowanie plików lub manualna purge (Portal/API) |
| Access denied | `allow_nested_items_to_be_public = false` | Ustaw wartość na `true` dla static website |

## Rozszerzenia
- Dodaj mechanizm invalidacji cache po deploy (Azure CLI / API).
- Zastąp pliki ręczną aktualizacją: użyj modułu lub skryptu uploadującego wiele blobów.
- Dodaj Content Security Policy (nagłówki poprzez funkcje Azure Front Door / CDN rules). 
- Porównaj czas odpowiedzi bez CDN vs z CDN przy testach globalnych (np. `curl` z różnych regionów).

## Bezpieczeństwo
- Publiczny dostęp tylko dla `$web` – pozostałe kontenery prywatne.
- Rozważ Private Endpoint + Front Door/Static Web Apps dla produkcyjnych scenariuszy.
- Nie zapisuj tajnych kluczy w repo – używaj Managed Identity / OIDC w CI.

## Sprzątanie
```bash
terraform destroy
```
Uwaga: Usunięcie Storage usunie wszystkie pliki strony.

## Checklist końcowa
- [ ] Storage Account z włączonym static website
- [ ] Pliki index + 404 + assets wgrane
- [ ] (Opcjonalnie) CDN Profile + Endpoint
- [ ] (Opcjonalnie) Custom domain aktywna i działa przez HTTPS
- [ ] Test `curl` zwraca 200 dla strony głównej

## Następny krok
Lab 12: dodanie Log Analytics / diagnostyki dla monitoringu zasobów.
