# Rozdział 2: Modularność w Terraform — count, for_each, dynamic

## Cel rozdziału
- Poznasz podejście modularne w Terraform.
- Nauczysz się stosować count, for_each i dynamic blocks do automatyzacji i powtarzalności.
- Zastosujesz te mechanizmy w praktycznym wdrożeniu (np. Storage Account z NSG lub Container Apps z sekretem z Key Vault).

## Definicje podstawowe
- Moduł: logiczna paczka zasobów z interfejsem wejść/wyjść.
- `count`: powiela identyczne (lub prawie identyczne) instancje na podstawie liczby.
- `for_each`: tworzy instancje z mapy / zbioru; klucze stanowią stabilne addressy.
- `dynamic` block: generuje powtarzalne zagnieżdżone bloki wewnątrz pojedynczego zasobu.

## Kiedy czego użyć?
| Sytuacja | count | for_each | dynamic |
|----------|-------|----------|---------|
| Stała liczba identycznych VM | TAK | NIE | NIE |
| Konfiguracja zależna od nazw (mapa) | NIE | TAK | NIE |
| Opcjonalne powtarzalne bloki w zasobie | NIE | NIE | TAK |
| Parametryzacja subnets (mapa obiektów) | NIE | TAK | (dynamic w środku np. service_endpoints) |

## Przykład 1 – count
```hcl
resource "azurerm_resource_group" "rg" {
	count    = 2
	name     = "rg-mod-${count.index}"
	location = "westeurope"
}
```
Adresowanie: `azurerm_resource_group.rg[0]`.

## Przykład 2 – for_each z mapą
```hcl
variable "rgs" {
	type = map(string)
	default = {
		dev  = "westeurope"
		prod = "northeurope"
	}
}

resource "azurerm_resource_group" "rg" {
	for_each = var.rgs
	name     = "rg-${each.key}"
	location = each.value
}
```

## Przykład 3 – for_each z obiektem + chaining
```hcl
variable "storage_defs" {
	type = map(object({
		replication = string
	}))
	default = {
		logs = { replication = "LRS" }
		app  = { replication = "GRS" }
	}
}

resource "azurerm_resource_group" "base" {
	name     = "rg-storage"
	location = "westeurope"
}

resource "azurerm_storage_account" "sa" {
	for_each                 = var.storage_defs
	name                     = "st${each.key}demo123"          # uproszczone
	resource_group_name      = azurerm_resource_group.base.name
	location                 = azurerm_resource_group.base.location
	account_tier             = "Standard"
	account_replication_type = each.value.replication
}
```

## Przykład 4 – dynamic block (opcjonalne IP rules)
```hcl
variable "allowed_ips" {
	type    = list(string)
	default = []
}

resource "azurerm_storage_account" "sa2" {
	name                     = "stmoddyn123"
	resource_group_name      = azurerm_resource_group.base.name
	location                 = azurerm_resource_group.base.location
	account_tier             = "Standard"
	account_replication_type = "LRS"

	network_rules {
		default_action = length(var.allowed_ips) > 0 ? "Deny" : "Allow"
		dynamic "ip_rules" {
			for_each = var.allowed_ips
			content { ip = ip_rules.value }
		}
	}
}
```

## Pułapki
| Pułapka | Wyjaśnienie | Mitigacja |
|---------|-------------|-----------|
| Zmiana klucza for_each → rekreacja zasobów | Adres stanu zależny od klucza | Stabilne klucze (np. ID zamiast nazwy przy refaktorze) |
| Nadmierny dynamic | Kod mało czytelny | Używaj tylko dla opcjonalnych/n-wielokrotnych bloków |
| count dla heterogenicznych zasobów | Trudno przypisać parametry | for_each z mapą obiektów |
| Sensitive dane w kluczach | Zabronione (Terraform błąd) | Ekstrakcja kluczy bez wartości wrażliwych |

## Ćwiczenie hands-on
1. Przepisz tworzenie trzech subnetów z powtarzalnym kodem na for_each.
2. Dodaj dynamic service_endpoints zależne od listy.
3. Usuń jeden element z mapy i zobacz różnicę w planie.

## Dobre praktyki
- Starannie typuj zmienne (map(object({...}))).
- W module nie powielaj bezmyślnie wszystkich atrybutów zasobów – oferuj sensowną abstrakcję.
- Dodaj opisowe outputy: np. mapę storage account → endpoint.
- Kompozycja modułów (moduł network + moduł security) zamiast mega-modułu.

## Efekt końcowy (rozszerzony)
- Umiejętność iterowania nad kolekcjami.
- Świadomość kosztu zmiany kluczy.
- Zastosowanie dynamic tam gdzie potrzebne – nie wszędzie.

## Następny krok
Przejście do zdalnego stanu (`Rozdział 3`).

## Zakres tematyczny
- Czym są moduły w Terraform i dlaczego warto ich używać?
- Różnice między count a for_each — kiedy stosować?
- Dynamiczne bloki — jak generować powtarzalne fragmenty kodu.
- Przykłady praktyczne: budowa powtarzalnych zasobów, parametryzacja, reużywalność.
- Przekazywanie zmiennych do modułów, outputs, locals.
- Best practices: czytelność, testowalność, unikanie antywzorców.

## Wskazówki
- Stosuj count do prostych, liczbowych powtórzeń.
- for_each jest lepszy do map/list obiektów — zapewnia stabilne adresy zasobów.
- Dynamic blocks pozwalają generować zagnieżdżone bloki na podstawie danych wejściowych.
- Moduły ułatwiają utrzymanie i rozwój infrastruktury.

## Efekt końcowy
- Umiejętność budowy powtarzalnych, parametryzowanych zasobów.
- Zrozumienie modularności i automatyzacji w Terraform.
- Gotowość do pracy z większymi, złożonymi projektami.
