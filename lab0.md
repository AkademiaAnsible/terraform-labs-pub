# Lab 0: Czysty Terraform (backend lokalny)

To rozgrzewkowe laboratorium używa wyłącznie providera `random` do generowania ciągu znaków. Brak zasobów Azure i tylko domyślny backend lokalny.

## Uruchomienie
```
cd lab0
./skrypt.sh -f dev.tfvars
```

## Uwagi
- Brak zdefiniowanego bloku backend, więc Terraform używa backendu lokalnego (plik stanu: `terraform.tfstate` w tym folderze).
- Zmień `variables.tf`, aby dostosować długość lub zestaw znaków; użyj `prefix`, aby dodać prefiks do wartości.
