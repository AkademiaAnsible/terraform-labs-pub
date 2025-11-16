# Lab Advanced 6: Zaawansowane moduły — outputs, locals, walidacja

## Cel laboratorium
- Przećwiczyć budowę i użycie zaawansowanego modułu sieciowego z outputs, locals i walidacją wejść.

## Krok po kroku
1. Utwórz katalog `modules/network` i zaimplementuj moduł (VNet + subnets, locals, outputs, walidacja).
2. Skonfiguruj wywołanie modułu w `main.tf`.
3. Przetestuj lokalnie: `terraform init`, `terraform plan`, `terraform apply`.
4. Dodaj walidację wejść (np. długość adresacji, poprawność CIDR).
5. Sprawdź outputs i locals w module.

## Wyjaśnienia
- Locals pozwalają agregować i przetwarzać dane wejściowe.
- Outputs przekazują wyniki do głównego kodu.
- Walidacja wejść chroni przed błędami na etapie planowania.

## Efekt końcowy
- Utworzony i przetestowany moduł sieciowy z outputs, locals i walidacją.
- Gotowość do rozwoju i testowania zaawansowanych modułów.
