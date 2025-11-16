
plan wstępny szkolenia zaawansowanego terraform  na 3 dni po 8h
8 godzin, 50 minut10 min przerwy, obiad 40 minut
godziny 9-17
1.5h na wprowadzenie i przygotowanie srodowiska

prosze zaplanuj agendę
przygotuj opis bloków agendy 
wygeneruj plik agenda_zaawansowana.md


---
chciałbym poruszyc poniższe punkty

dzien 1
planuje z nimi zacząć od modułów, count, dor_each, dynamic w jakimś deployment, może container apps i sekretem z kv... i do tego nsg czy coś
no a może jednak prościej storage 
to pewnie z 2-3h zejdzie 
 
do tego remore backends 
1h
 
repo artefaktów - musze pogadać z pzu, bo jak by coś dali, to byśmy tam mogli z 2 przykładowe moduły wrzucić
i trzeba omowic rozwoj modulow w organizacji
1h
 
mieliśmy fajny case teraz na szkoleniu, import zasobów  udało sie, więc to też z godzinka
 
i na koniec pierwzego dnia moduły
2h
 
Dzien 2
dalej troche zmiennych, locals i te sprawy
typy danych w ramach powtorki, i zlozone struktury objects + locals
pliki tfvars, zmienne itp
warunki
datasources
2-3h
 
integracja z cicd, pipelines w ghe
walidacja kodu
fmt, checkov, tflint 
pogadanka o approvalach w pipeline, autobuild dla pr itp...
pewnie 2-3h
 
gdzieś by trzeba poruszyć może HCP i zrobić jakiś przykład
1-2h? ale może nie...
wiec może coś innego zamiast tego
 
Dzień 3
corpo standardy i moduły w organizacji
validate na zasobach
hardenowanie modułów, nie dopuszczanie niektorych wartości na poziomie kodu (np zabronione account key w storage) - przykłady realizacji, ale tez jak dać exclude 
2-3h
 
terragrunt/terramate/...
1h ?
 
pipeline 
Budowa złożonego środowiska (AIFoundry AIServices + Encryption (KV + key) + UAI itd., FunctionApp + SA + itd..).
pipeline, PR, testy, zatwierdzenie
2-3h 
 
inne?  
1h ?
