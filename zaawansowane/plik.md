# Agenda szkolenia Terraform – poziom zaawansowany

**Czas trwania:** 3 dni po ok. 8 godzin (każdego dnia), z przerwami 10 min co ~2h oraz 40 min przerwą obiadową.

## Dzień 1 – Zaawansowane moduły i stan Terraform

- **09:00 - 09:15** – **Rozpoczęcie szkolenia:** Powitanie uczestników, omówienie planu szkolenia i celów kursu. Przedstawienie agendy na najbliższe trzy dni oraz krótkie przypomnienie podstaw Terraform (dla kontekstu).

- **09:15 - 10:50** – **Moduły i iteracja zasobów:** Zaawansowane użycie modułów w Terraform. Omówienie sposobów tworzenia **modułów** i ponownego wykorzystania kodu. Przedstawienie meta-argumentów **`count`** i **`for_each`** do tworzenia wielu instancji zasobów oraz **dynamicznych bloków** do generowania powtarzalnych fragmentów konfiguracji. **Przykład praktyczny:** implementacja modułu wdrażającego usługę Azure (np. konto Storage lub Azure Container Instance) z wykorzystaniem powyższych mechanizmów oraz integracja z tajnymi danymi przechowywanymi w **Azure Key Vault** (sekrety). *Forma:* prezentacja z przykładami kodu + dyskusja. 

- **10:50 - 11:00** – **Przerwa techniczna (10 min)** 

- **11:00 - 12:50** – **Zdalne backendy i repozytoria modułów:** Zarządzanie stanem Terraform w środowisku zespołowym. Omówienie **remote backends** – konfiguracja zdalnego magazynu stanu (np. Azure Storage, Terraform Cloud) w celu bezpiecznego współdzielenia stanu i blokowania operacji. Następnie **repozytoria artefaktów i rozwój modułów:** najlepsze praktyki wersjonowania modułów Terraform oraz przechowywania ich w repozytorium (Terraform Registry prywatne/publiczne lub narzędzia typu Artifactory). Dyskusja o tym, jak publikować i dystrybuować własne moduły w organizacji. *Forma:* wykład + demo konfiguracji zdalnego backendu (np. migracja stanu lokalnego do Azure Storage) oraz omówienie struktury przykładowego repozytorium modułów.

- **12:50 - 13:30** – **Przerwa obiadowa (40 min)**

- **13:30 - 15:20** – **Importowanie istniejących zasobów:** Sposoby włączania już istniejącej infrastruktury do zarządzania przez Terraform. Omówienie polecenia **`terraform import`**, jego zastosowań i ograniczeń. **Demonstracja:** import rzeczywistego zasobu Azure stworzonego poza Terraform (np. istniejącego konta Storage) do stanu Terraform. Następnie krótkie **ćwiczenie praktyczne** – uczestnicy samodzielnie importują wskazany zasób do swojego stanu, co pozwoli utrwalić procedurę importu i rozwiązać potencjalne problemy (konieczność zdefiniowania odpowiadającego zasobu w kodzie, itp.). 

- **15:20 - 15:30** – **Przerwa techniczna (10 min)**

- **15:30 - 17:00** – **Utrwalenie i rozwój modułów:** Podsumowanie wiedzy o modułach Terraform zdobytej w ciągu dnia. **Warsztat modułowy:** uczestnicy w grupach lub indywidualnie tworzą prosty moduł od podstaw lub rozbudowują istniejący, wykorzystując zaawansowane elementy (parametry, `for_each`, dynamiczne bloki). Celem jest utrwalenie najlepszych praktyk (np. unikanie duplikacji kodu, czytelność modułu, użycie zmiennych wejściowych/wyjściowych). Instruktor asystuje i omawia rozwiązania. Na zakończenie dnia **podsumowanie** najważniejszych punktów dotyczących modułów i dyskusja o możliwościach ich dalszego wykorzystania w projektach uczestników. *Plan na dzień 2:* zapowiedź tematów kolejnego dnia (zmienne, CI/CD, itd.).

---

## Dzień 2 – Złożone konfiguracje i integracja CI/CD

- **09:00 - 09:15** – **Otwarcie dnia 2:** Krótkie przypomnienie materiału z dnia poprzedniego (moduły, backendy, import) oraz przedstawienie planu na Dzień 2. Sesja pytań na rozgrzewkę – wyjaśnienie ewentualnych wątpliwości z Dnia 1.

- **09:15 - 10:50** – **Zmienne, typy danych i struktury złożone:** Dogłębne omówienie **zmiennych** w Terraform. Przypomnienie deklaracji zmiennych i **locals**, następnie prezentacja różnych **typów danych** (string, list, map, bool, number, a także złożone typu jak struktury object i list(map(...)) itp.). Jak definiować **złożone struktury danych** dla przekazywania konfiguracji do modułów (np. lista map dla wielu ustawień naraz). Poruszenie kwestii organizacji wartości konfiguracyjnych: pliki **.tfvars** vs. zmienne środowiskowe **TF_VAR**. *Forma:* wykład + przykład konfiguracji terraform z użyciem złożonych zmiennych (np. lista obiektów reprezentujących wiele Storage Accountów).

- **10:50 - 11:00** – **Przerwa kawowa (10 min)**

- **11:00 - 12:50** – **Warunki logiczne i data sources:** Wykorzystanie wyrażeń warunkowych w Terraform do tworzenia elastycznej konfiguracji. Omówienie składni **warunków (ternary)** oraz wzorców typu **`count`** z warunkiem (tworzenie zasobu tylko gdy spełniony warunek) vs. blok **`for_each`** z filtrowaniem. Następnie **Data Sources:** pobieranie danych z istniejących zasobów chmurowych. Przykłady użycia **`data` sources** na platformie Azure (np. odczyt istniejącego VNet, subskrypcji, kluczy z Key Vault, itp.) i wykorzystanie tych danych w konfiguracji. *Forma:* demonstracja na żywo – napisanie kodu Terraform korzystającego z data source (np. uzyskanie istniejącego IP z zasobu Azure) oraz krótkie ćwiczenie dla uczestników: dodanie do swojej konfiguracji data source (lub warunku) wedle instrukcji prowadzącego.

- **12:50 - 13:30** – **Przerwa obiadowa (40 min)**

- **13:30 - 15:20** – **Integracja Terraform z CI/CD:** Wprowadzenie do automatyzacji Terraform w potokach CI/CD. Omówienie narzędzi zapewniających jakość kodu: **`terraform fmt`** (automatyczne formatowanie kodu), **`terraform validate`** (walidacja składni i logiki), **TFLint** (linting Terraform pod kątem błędów i dobrych praktyk) oraz **Checkov** (statyczna analiza bezpieczeństwa i zgodności z politykami). Przedstawienie, jak te narzędzia włączyć w pipeline (na przykładzie platformy CI/CD – GitHub Actions, GitLab CI lub Azure DevOps). Omówienie przykładowego **workflow pipeline**: etap plan (generowanie planu zmian), manualna akceptacja (**approval**) planu przez zespół, etap apply (wdrożenie) oraz automatyczne akcje typu **autobuild** przy każdym merge’u do głównej gałęzi. Dyskusja o dobrych praktykach: przechowywanie plików stanu w ramach pipeline, zabezpieczenie sekretów (np. poprzez Azure Key Vault w pipeline), oraz generowanie dokumentacji i raportów z testów. *Forma:* prezentacja z przykładami plików konfiguracyjnych pipeline, analiza sample pipeline (np. plik YAML) i omówienie jego działania.

- **15:20 - 15:30** – **Przerwa techniczna (10 min)**

- **15:30 - 17:00** – **HashiCorp Cloud Platform (opcjonalnie) i dyskusja:** (Sesja opcjonalna, w zależności od tempa szkolenia) Prezentacja wybranych dodatkowych narzędzi i usług powiązanych z Terraform. Główny fokus na **Terraform Cloud/Enterprise (HCP)** – omówienie funkcjonalności chmurowej platformy HashiCorp: zdalne operacje `plan/apply`, współpraca zespołowa, blokady stanu, **Sentinel** (polityki jako kod) i zarządzanie workspace’ami. Dyskusja na temat zalet i wad korzystania z Terraform Cloud vs. własne rozwiązania (open-source). **Inne możliwe tematy** (wg zainteresowania grupy): przegląd alternatywnych narzędzi i rozszerzeń Terraform (np. **Scalr, Spacelift** – zewnętrzne platformy CI/CD dla Terraform, czy **Terratest** – framework do testów infrastruktury). Końcowe **podsumowanie dnia 2** i omówienie planu na ostatni dzień szkolenia (standardy, Terragrunt, projekt końcowy). 

---

## Dzień 3 – Best practices, Terragrunt i projekt końcowy

- **09:00 - 09:15** – **Rozpoczęcie dnia 3:** Podsumowanie kluczowych punktów z Dnia 2 (zmienne, datasources, CI/CD). Omówienie agendy na ostatni dzień szkolenia – skupienie na organizacyjnych standardach, bezpieczeństwie oraz finalnym projekcie praktycznym integrującym zdobytą wiedzę. Krótkie **Q&A** na starcie, aby wyjaśnić wątpliwości przed kontynuacją.

- **09:15 - 10:50** – **Standardy organizacyjne i zabezpieczenia w Terraform:** Przegląd najlepszych praktyk przy tworzeniu kodu Terraform w środowisku firmowym. **Polityki i konwencje:** jak ustandaryzować nazewnictwo zasobów, tagowanie, struktury katalogów i modułów w dużych projektach Terraform. **Zabezpieczenia:** użycie wbudowanych mechanizmów Terraform do walidacji wartości (blok **`validation`** w zmiennych – wymuszanie określonych formatów lub zakresów wartości, np. dopuszczalne nazwy, regiony itp.). Omówienie sposobów na **enforcement** reguł organizacyjnych: od recenzji kodu (pull requesty) po automatyczne testy i narzędzia takie jak **Sentinel** (Terraform Enterprise) lub **Open Policy Agent** do egzekwowania polityk bezpieczeństwa. Przykłady typowych reguł bezpieczeństwa: np. zakaz użycia czystych haseł/kluczy dostępowych w kodzie, **zakaz wykorzystywania klucza dostępowego Storage Account** (key) zamiast bezpiecznych metod (Managed Identity, SAS), wymaganie szyfrowania dysków, itp. *Forma:* prezentacja + dyskusja (uczestnicy dzielą się własnymi doświadczeniami ze standardami w swoich organizacjach).

- **10:50 - 11:00** – **Przerwa kawowa (10 min)**

- **11:00 - 12:50** – **Hardening modułów i zaawansowane techniki:** Techniki utwardzania (hardening) tworzonych modułów Terraform, aby były bezpieczne i odporne na błędy użytkowania. Omówienie, jak projektować moduły wymuszające dobre praktyki (np. domyślne bezpieczne ustawienia, walidacje wejść, ukrywanie wewnętrznej logiki). **Przykład:** Implementacja modułu tworzącego Storage Account, który **nie pozwala** użytkownikowi na pobranie klucza dostępowego z wyjść (aby wymusić korzystanie z mechanizmów RBAC lub Key Vault). Inne przykłady: moduł zapewniający logowanie aktywności (diagnostic settings) dla krytycznych zasobów, czy integrację z usługami monitoringu/alertów. Ponadto, omówienie **strategii refaktoryzacji** istniejących modułów w celu zwiększenia ich czytelności i bezpieczeństwa (np. rozbicie zbyt rozbudowanych modułów na mniejsze). *Forma:* studium przypadku + dyskusja. **Ćwiczenie praktyczne:** analiza przygotowanego przykładowego modułu pod kątem błędów i luk (code review modułu) – uczestnicy wspólnie identyfikują potencjalne problemy i proponują ulepszenia.

- **12:50 - 13:30** – **Przerwa obiadowa (40 min)**

- **13:30 - 15:20** – **Terragrunt i Terramate – zarządzanie złożonymi infrastrukturami:** Wprowadzenie do narzędzi ułatwiających pracę z wieloma konfiguracjami Terraform. **Terragrunt:** omówienie sposobu działania tego wrappera na Terraform (reużywanie modułów, warstwy environment, automatyzacja backendów i konfiguracji dla wielu środowisk). Przykład struktury katalogów w projekcie z Terragruntem oraz pokazowa konfiguracja Terragrunt (blok `terraform { source = ... }`, dziedziczenie ustawień). **Terramate:** przedstawienie nowego narzędzia do orkiestracji Terraform – generowanie kodu, zarządzanie stosem wielu konfiguracji, wykrywanie zmian między stackami. Porównanie możliwości Terramate do Terragrunt. *Forma:* prezentacja + demo. **Demo:** krótki pokaz użycia Terragrunt (np. uruchomienie `terragrunt plan` dla zestawu modułów w różnych katalogach) oraz omówienie jak Terramate może wygenerować powtarzalny kod dla wielu środowisk. Dyskusja: w jakich scenariuszach te narzędzia przynoszą najwięcej korzyści.

- **15:20 - 15:30** – **Przerwa techniczna (10 min)**

- **15:30 - 17:00** – **Projekt końcowy – budowa złożonego środowiska:** Zastosowanie zdobytej wiedzy w praktyce poprzez utworzenie kompleksowej infrastruktury w Azure za pomocą Terraform. **Scenariusz:** wdrożenie przykładowego środowiska zawierającego kilka usług:
    - **Azure AI Foundry** – przygotowanie usługi (hub/projekt) do zarządzania rozwiązaniami AI,
    - **Storage Account** z włączonym szyfrowaniem kluczem z **Azure Key Vault** (integracja Key Vault do przechowywania kluczy szyfrujących),
    - **Function App** (funkcja Azure) korzystająca z powyższego Storage (np. do przetwarzania danych) – z przypisaną **User-Assigned Managed Identity (UAI)** zamiast kluczy dostępowych,
    - Połączenie komponentów oraz konfiguracja uprawnień (np. UAI z dostępem do Key Vault zamiast używania sekretów w kodzie).
  
  Uczestnicy, pod opieką trenera, tworzą konfiguracje Terraform dla poszczególnych elementów, organizują je w moduły i aplikują w odpowiedniej kolejności. **Integracja z pipeline:** Omówienie, jak taki projekt byłby obsługiwany przez pipeline CI/CD – od planowania, przez automatyczne testy, po wdrożenie na środowiska (np. dev/prod) z wykorzystaniem mechanizmu **pull requestów i code review** przed zastosowaniem zmian. Wspomnienie o napisaniu prostych testów infrastrukturalnych (np. skrypt sprawdzający dostępność funkcji po wdrożeniu lub wykorzystanie narzędzia **Terratest** dla chętnych). **Podsumowanie szkolenia:** Ostatnie 15 minut przeznaczone na podsumowanie całości trzydniowego treningu – najważniejsze wnioski, najlepsze praktyki Terraform na poziomie zaawansowanym, oraz sesja **Q&A** na zakończenie (odpowiedzi na pytania uczestników, dyskusja). Pożegnanie uczestników i wskazówki dotyczące dalszego samodzielnego rozwoju (materiały, dokumentacja, społeczność Terraform).

