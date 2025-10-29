# Terraform & Azure – Opisy zagadnień

Poniższy plik zawiera skondensowane opisy wszystkich haseł użytych w slajdach prezentacji `terraform-azure-workshop-full.pptx`. Hasła bez zdefiniowanego opisu w slajdzie są oznaczone placeholderem `[OPIS DO UZUPEŁNIENIA]` – można je uzupełnić tutaj, a następnie przenieść do słownika `EXPLANATIONS` w skrypcie.

## Słownik

| Hasło | Opis |
|-------|------|
| Core | Główna część Terraform odpowiedzialna za analizę konfiguracji, budowanie grafu zależności oraz planowanie i stosowanie zmian w infrastrukturze. Core przetwarza pliki HCL, komunikuje się z providerami i zarządza stanem. <br>**Przykład:** <br>Użytkownik uruchamia `terraform plan` – Core analizuje kod i generuje plan zmian. |
| Providers | Wtyczki (np. azurerm, aws, google) umożliwiające Terraformowi komunikację z API różnych dostawców chmury lub usług. Provider implementuje obsługę konkretnych typów zasobów. <br>**Przykład:** <br>`provider "azurerm" { features {} }` pozwala zarządzać zasobami Azure. |
| Plugins | Binarne rozszerzenia ładowane przez Core, takie jak providery i provisionery. Pozwalają na rozszerzenie funkcjonalności Terraform bez modyfikacji samego silnika. <br>**Przykład:** <br>Provider `azurerm` lub provisioner `local-exec` to pluginy. |
| State | Plik (najczęściej `terraform.tfstate`) przechowujący aktualny stan infrastruktury zarządzanej przez Terraform. Zawiera mapowanie zasobów z kodu na rzeczywiste identyfikatory w chmurze oraz metadane. <br>**Przykład:** <br>Po `terraform apply` plik `terraform.tfstate` zawiera ID utworzonej grupy zasobów. |
| DAG | Directed Acyclic Graph – graf zależności zasobów budowany przez Terraform na podstawie referencji między nimi. Pozwala na równoległe tworzenie niezależnych zasobów i wymusza właściwą kolejność operacji. <br>**Przykład:** <br>VM zależy od NIC, a NIC od subnetu – DAG zapewnia poprawną kolejność tworzenia. |
| init | Komenda inicjalizująca projekt Terraform: pobiera wymagane pluginy (providerów), konfiguruje backend stanu i przygotowuje środowisko do pracy. <br>**Przykład:** <br>`terraform init` w katalogu projektu pobiera providera `azurerm` i tworzy plik `.terraform`. |
| validate | Komenda sprawdzająca poprawność składni i podstawowych reguł konfiguracji Terraform. Pozwala wykryć literówki, brakujące nawiasy czy niezgodności typów przed planowaniem zmian. <br>**Przykład:** <br>`terraform validate` zgłosi błąd, jeśli w kodzie jest nieprawidłowa referencja do zmiennej. |
| plan | Komenda generująca plan zmian w infrastrukturze na podstawie aktualnego stanu i kodu. Pokazuje, co zostanie utworzone, zmodyfikowane lub usunięte, bez wprowadzania zmian. <br>**Przykład:** <br>`terraform plan` wyświetli, że zostanie utworzona nowa grupa zasobów. |
| apply | Komenda stosująca planowane zmiany do infrastruktury. Tworzy, modyfikuje lub usuwa zasoby zgodnie z planem. <br>**Przykład:** <br>`terraform apply` utworzy zasoby w Azure zgodnie z kodem. |
| destroy | Komenda usuwająca wszystkie zasoby zarządzane przez dany projekt Terraform. Pozwala na szybkie posprzątanie środowiska. <br>**Przykład:** <br>`terraform destroy` usunie grupę zasobów, storage i inne utworzone elementy. |
| string | Typ tekstowy, używany do przechowywania pojedynczych wartości znakowych, np. nazw, identyfikatorów czy regionów. <br>**Przykład:** <br>`variable "location" { type = string; default = "westeurope" }` |
| number | Typ liczbowy, obsługuje zarówno liczby całkowite, jak i zmiennoprzecinkowe. <br>**Przykład:** <br>`variable "count" { type = number; default = 2 }` |
| bool | Typ logiczny, przyjmuje wartości `true` lub `false`. <br>**Przykład:** <br>`variable "enabled" { type = bool; default = true }` |
| list | Uporządkowana kolekcja elementów jednego typu. Pozwala na iterację i indeksowanie. <br>**Przykład:** <br>`variable "subnets" { type = list(string); default = ["subnet1", "subnet2"] }` |
| map | Słownik klucz-wartość, gdzie klucze są stringami. Umożliwia przekazywanie tagów lub parametrów. <br>**Przykład:** <br>`variable "tags" { type = map(string); default = { env = "dev" } }` |
| set | Zbiór unikalnych wartości jednego typu, bez gwarancji kolejności. <br>**Przykład:** <br>`variable "regions" { type = set(string); default = ["westeurope", "northeurope"] }` |
| object | Struktura z nazwanymi polami o określonych typach. Pozwala grupować powiązane dane. <br>**Przykład:** <br>`variable "vm_config" { type = object({ name = string, size = string }); default = { name = "vm1", size = "Standard_B1s" } }` |
| tuple | Kolekcja pozycyjna o z góry określonych typach elementów. <br>**Przykład:** <br>`variable "example" { type = tuple([string, number]); default = ["abc", 42] }` |
| type | Deklaracja typu zmiennej, wymusza walidację wartości przekazanych do zmiennej. <br>**Przykład:** <br>`variable "location" { type = string }` |
| description | Opis zmiennej, ułatwia dokumentowanie celu i użycia. <br>**Przykład:** <br>`variable "location" { description = "Region Azure dla zasobów." }` |
| validation | Blok reguł walidujących wartość zmiennej, np. ograniczenie do wybranych wartości. <br>**Przykład:** <br>`variable "location" { validation { condition = contains(["westeurope", "northeurope"], var.location); error_message = "Nieprawidłowy region." } }` |
| sensitive | Oznaczenie zmiennej lub outputu jako wrażliwy – wartość nie pojawi się w logach ani planie. <br>**Przykład:** <br>`variable "admin_password" { type = string; sensitive = true }` |
| locals | Blok pozwalający definiować lokalne zmienne i wyrażenia do wielokrotnego użycia w kodzie. <br>**Przykład:** <br>`locals { common_tags = { environment = "dev" } }` |
| Tagi | Klucz-wartość przypisywane zasobom w celu identyfikacji, zarządzania kosztami i automatyzacji. <br>**Przykład:** <br>`tags = { environment = "dev", owner = "team" }` |
| Nazwy | Konwencje i wzorce nazewnictwa zasobów, np. `rg-projekt-dev`. Ułatwiają zarządzanie i automatyzację. <br>**Przykład:** <br>`name = "${var.prefix}-vm"` |
| Warunki try()/coalesce() | Funkcje HCL do obsługi wartości opcjonalnych i domyślnych. <br>**Przykład:** <br>`try(var.optional, "default")` lub `coalesce(var.a, var.b, "fallback")` |
| count | Mechanizm iteracji do tworzenia wielu instancji zasobu na podstawie liczby. <br>**Przykład:** <br>`resource "azurerm_network_interface" "nic" { count = 2 ... }` |
| for_each | Iteracja po mapie lub zbiorze, zapewnia stabilne adresy zasobów. <br>**Przykład:** <br>`resource "azurerm_subnet" "subnet" { for_each = var.subnets ... }` |
| Mapy > listy | Mapy zapewniają stabilniejsze identyfikatory zasobów niż listy, szczególnie przy usuwaniu elementów. <br>**Przykład:** <br>`for_each = { a = "foo", b = "bar" }` |
| dynamic | Blok generujący zagnieżdżone sekcje (np. reguły NSG) na podstawie kolekcji. <br>**Przykład:** <br>`dynamic "security_rule" { for_each = var.rules ... }` |
| Iteracja reguł | Tworzenie wielu podobnych bloków, np. reguł sieciowych, za pomocą `for_each` lub `dynamic`. <br>**Przykład:** <br>Patrz dynamiczny blok `security_rule` w NSG. |
| NSG rules przykład | Przykład użycia dynamic do generacji reguł NSG: <br>`dynamic "security_rule" { for_each = var.rules ... }` |
| try() | Funkcja HCL zwracająca wynik wyrażenia lub wartość alternatywną przy błędzie. <br>**Przykład:** <br>`try(var.optional, "default")` |
| coalesce() | Funkcja HCL zwracająca pierwszy niepusty (nie-null) argument. <br>**Przykład:** <br>`coalesce(var.a, var.b, "fallback")` |
| Fallback wartości | Wartości domyślne stosowane, gdy brakuje danych wejściowych. <br>**Przykład:** <br>`coalesce(var.optional, "default")` |
| Obsługa braków | Bezpieczne omijanie błędów przy brakujących właściwościach, np. przez `try()`. |
| Tagi wspólne | Lokalna zmienna z zestawem tagów używana w wielu zasobach. <br>**Przykład:** <br>`locals { common_tags = { environment = var.env } }` |
| Parametry pochodne | Wartości wyliczane na podstawie innych zmiennych, np. prefixy nazw. <br>**Przykład:** <br>`locals { rg_name = "${var.prefix}-rg" }` |
| AVM | Azure Verified Modules – oficjalne, certyfikowane moduły Terraform dla Azure, zgodne z najlepszymi praktykami. <br>**Przykład:** <br>`module "rg" { source = "Azure/avm-res-resource-group/azurerm" ... }` |
| Wyszukiwanie modułów | Przeglądanie katalogu registry.terraform.io lub GitHub w celu znalezienia gotowych modułów. |
| Kontrybucja | Dodawanie własnych poprawek lub nowych funkcji do istniejących modułów open source. |
| Terraform >=1.0 | Wersja Terraform gwarantująca stabilność i kompatybilność semver. <br>**Przykład:** <br>`terraform { required_version = ">= 1.0" }` |
| VS Code extensions | Rozszerzenia do VS Code, np. HashiCorp Terraform, Azure Account, ułatwiające pracę z kodem IaC. |
| Azure CLI | Narzędzie wiersza poleceń do zarządzania zasobami Azure. <br>**Przykład:** <br>`az login` |
| Git | System kontroli wersji do zarządzania kodem infrastruktury. <br>**Przykład:** <br>`git clone ...` |
| TFLint/Checkov (opc) | Narzędzia do statycznej analizy kodu Terraform pod kątem stylu, bezpieczeństwa i zgodności z politykami. |
| linting (TFLint) | Sprawdzanie stylu i typowych błędów w kodzie Terraform. <br>**Przykład:** <br>`tflint` |
| Checkov | Skanner bezpieczeństwa IaC, wykrywa niezgodności z politykami bezpieczeństwa. <br>**Przykład:** <br>`checkov -d .` |
| pre-commit | Framework do automatycznego uruchamiania testów i lintów przed commitem. <br>**Przykład:** <br>Hook `pre-commit` uruchamia `terraform fmt` i `tflint`. |
| tfswitch | Narzędzie do szybkiego przełączania wersji Terraform lokalnie. <br>**Przykład:** <br>`tfswitch 1.5.0` |
| Managed Identity | Mechanizm Azure umożliwiający uwierzytelnianie bez kluczy i haseł, oparty o tokeny. <br>**Przykład:** <br>VM z włączoną Managed Identity może pobierać sekrety z Key Vault bez hasła. |
| Private Endpoints | Prywatne połączenie z usługą PaaS w obrębie VNet, eliminujące ekspozycję publiczną. <br>**Przykład:** <br>`resource "azurerm_private_endpoint" ...` |
| RBAC least privilege | Zasada przydzielania minimalnych niezbędnych uprawnień użytkownikom i aplikacjom. <br>**Przykład:** <br>Rola Contributor tylko dla wybranej grupy zasobów. |
| Monitorowanie | Zbieranie metryk i logów z zasobów do narzędzi takich jak Azure Monitor czy Log Analytics. <br>**Przykład:** <br>Włączenie diagnostyki w Storage Account. |
| Adresacja zasobów (terraform state list) | Identyfikacja i śledzenie zasobów w pliku stanu za pomocą polecenia `terraform state list`. |
| Preferuj mapy do for_each | Użycie map zamiast list w `for_each` zapewnia stabilniejsze adresy zasobów. |
| dynamic "security_rule" | Przykład dynamicznego generowania reguł NSG: <br>`dynamic "security_rule" { for_each = var.rules ... }` |
| content { name = each.value.name ... } | Szablon bloku dynamicznego, pozwala budować atrybuty na podstawie kolekcji. <br>**Przykład:** <br>`content { name = each.value.name ... }` |
| Redukcja duplikacji | Eliminacja powtarzalnego kodu przez użycie locals, dynamic, for_each. |
| Obsługa opcjonalnych parametrów | Użycie funkcji `try()` lub warunków do obsługi parametrów, które mogą nie istnieć. |
| Bezpieczne wartości domyślne | Stosowanie `coalesce()` lub wartości domyślnych, by uniknąć błędów przy braku danych. |
| Standaryzacja | Ujednolicenie podejścia do kodowania, nazewnictwa i tagowania w celu redukcji błędów. |
| Zgodność z Well-Architected | Przestrzeganie dobrych praktyk architektonicznych Azure (np. bezpieczeństwo, dostępność). |
| Mniej kodu własnego | Korzystanie z gotowych modułów i wzorców zamiast pisania wszystkiego od zera. |
| Przykład: module 'avm-res-resource-group' | Użycie oficjalnego modułu AVM do tworzenia Resource Group: <br>`module "rg" { source = "Azure/avm-res-resource-group/azurerm" ... }` |
| Integracja CI | Włączanie narzędzi jakości (lint, testy) w pipeline CI/CD. <br>**Przykład:** <br>GitHub Actions uruchamiające `terraform validate`. |
| Raport przed merge | Wymuszenie przejścia testów i lintów przed połączeniem brancha do głównego. |
| Instaluj przed startem | Lista narzędzi do przygotowania środowiska: Terraform, Azure CLI, VS Code, TFLint. |
| curl -fsSL ... | Przykład pobrania klucza GPG repozytorium HashiCorp: <br>`curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -` |
| Blob lease | Mechanizm blokady pliku stanu w Azure Storage, zapobiega konfliktom przy jednoczesnych zmianach. |
| Remote state | Przechowywanie pliku stanu poza lokalnym dyskiem, np. w Azure Storage, dla współpracy zespołowej. |
| Policies | Reguły governance wymuszające standardy (np. Sentinel, OPA). |
| Run tasks | Dodatkowe kroki (np. skan bezpieczeństwa) wykonywane automatycznie w cyklu HCP Terraform. |
| Hardcode | Wartości wpisane na sztywno w kodzie, utrudniające ponowne użycie i automatyzację. |
| Opis zmiennych | Szczegółowy opis celu i użycia zmiennej, ułatwia korzystanie z modułów. |
| Pin wersji | Blokowanie konkretnej wersji Terraform lub providera dla powtarzalności wdrożeń. <br>**Przykład:** <br>`version = ">= 3.0"` |
| Lock file | Plik `terraform.lock.hcl` z haszami providerów, zapewnia spójność środowisk. |
| ~> constraints | Operator wersji semver, pozwala na automatyczne aktualizacje minor/patch bez łamania kompatybilności. <br>**Przykład:** <br>`version = "~> 3.0"` |
| Locking | Mechanizm zapobiegający jednoczesnym modyfikacjom pliku stanu przez wielu użytkowników. |
| RBAC | Role Based Access Control – system przydzielania uprawnień na podstawie ról. <br>**Przykład:** <br>Rola Contributor dla grupy zasobów. |
| Monitorowanie | (Duplikat) Patrz wcześniejszy wpis. |
| Retention | Polityka przechowywania logów i metryk, np. 30 dni w Log Analytics. |
| Replication | Poziomy redundancji danych w Azure Storage: LRS, ZRS, GRS. |
| Nazwy konwencja | Wzorzec budowy identyfikatorów zasobów, np. `rg-projekt-dev`, ułatwiający zarządzanie. |

## Uzupełnianie braków
Hasła oznaczone `[OPIS DO UZUPEŁNIENIA]` w prezentacji należy doprecyzować i dodać tutaj, następnie przenieść do `EXPLANATIONS`.

## Aktualizacja skryptu
Po dodaniu nowych opisów:
1. Zaktualizuj słownik `EXPLANATIONS` w `prezentacja/generate_preview_pptx.py`.
2. Uruchom ponownie generowanie: `python prezentacja/generate_preview_pptx.py full`.
3. Zweryfikuj slajdy z nowymi opisami.

