# Lab Advanced 3: Remote backend Azure Storage

## Cel laboratorium
- Skonfigurować backend zdalny w Azure Storage.
- Przećwiczyć inicjalizację, planowanie i współdzielenie stanu.

## Krok po kroku
1. Przejdź do katalogu laboratorium: `cd zaawansowane/lab/lab_advanced_3`.
2. Zainicjuj Terraform: `terraform init -backend-config=backend.hcl`.
3. Zweryfikuj konfigurację: `terraform validate`.
4. Przeprowadź planowanie: `terraform plan -var-file=dev.tfvars`.
5. (Opcjonalnie) Utwórz zasoby: `terraform apply -var-file=dev.tfvars`.
6. Skonfiguruj backend w innych katalogach/labach, by korzystały z tego samego storage.

## Wyjaśnienia
- Plik `backend.hcl.example` zawiera przykładową konfigurację backendu.
- Storage Account i kontener muszą istnieć przed użyciem backendu.
- Praca zespołowa: kilka osób może korzystać z tego samego backendu (blokady!).

## Efekt końcowy
- Utworzony storage i kontener pod backend.
- Skonfigurowany backend zdalny, gotowy do pracy zespołowej.
