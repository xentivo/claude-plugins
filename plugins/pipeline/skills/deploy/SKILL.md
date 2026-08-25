---
name: deploy
description: Użyj gdy workflow ma cokolwiek wdrażać - budować obraz, logować się do chmury, podmieniać rewizję albo wersję aplikacji, wdrażać release, robić rollback. Także przy zmianie istniejącego workflow deployowego. Pilnuje, żeby CI nie dorabiało się własnej logiki deployu i żeby „deploy OK" znaczyło „aplikacja wstała".
---

# Deploy z pipeline'u

Dwie rzeczy psują deploy w CI: druga implementacja tego, co robi się ręcznie, i
uznanie odpowiedzi API za dowód, że aplikacja działa.

Pełna zasada organizacji: `get_rule("ci-pipeline")` na serwerze Xentivo MCP.

## Kształt workflow

- **Osobny plik na środowisko.** Nie jeden z parametrem: literówka w `inputs` albo
  w `if` celuje wtedy w produkcję. W nagłówku pliku napisz, gdzie jest bliźniak.
- **Workflow woła skrypt deployowy repo**, tego samego, którego używa człowiek z
  laptopa. Kroki przepisane na YAML to druga implementacja, która rozjedzie się z
  pierwszą, a guardy skryptu (host bazy, czyste drzewo, walidacja schematu) przestaną
  chronić akurat tę ścieżkę, której nikt nie odpala ręcznie.
- `concurrency` po środowisku z **`cancel-in-progress: false`**. Bieg zmienia stan.
- `workflow_dispatch` zawsze, z inputem na ponowne wgranie sekretów i (dla produkcji)
  na tag do wdrożenia.
- Produkcja jedzie z **taga release'a**, nie z czubka pnia. Pre-release nie jedzie i
  bramka kończy się zielono z wypisanym powodem.

## Kroki, o których się zapomina

- `fetch-depth: 0`, gdy numer buildu liczy się z historii gita.
- Instalacja zależności, jeśli skrypt deployowy woła cokolwiek z `npx` przed buildem.
- Odtworzenie `.env` z sekretu: `umask 077`, zero wypisywania zawartości, kontrola
  obecności kluczowej zmiennej i `git status --porcelain` (obraz powstaje z drzewa).
- Sekrety aplikacji wgrywane **tylko** na jawne żądanie, nie przy każdym mergu.
- Pominięcie builda przy zmianach, które nie wchodzą do obrazu: buduj, chyba że
  KAŻDA zmieniona ścieżka jest na liście wykluczeń. Diff z `--no-renames`, sprawdzenie
  wyniku poprzedniego biegu, powód wypisany zawsze.

## Weryfikacja po deployu (kolejność jest częścią reguły)

1. porównaj identyfikator obrazu przed i po - łapie „update nic nie podmienił",
2. czekaj na stan `Running`, przerwij na `Failed` albo `Degraded`,
3. dopiero teraz odpytuj health-check aż do 200 z oczekiwaną treścią.

Odwrócenie 2 i 3 przepuszcza zepsuty obraz: w trakcie rolloutu ruch idzie jeszcze na
starą rewizję, która odpowiada 200. Przy porażce zrzuć ogon logów aplikacji
(`if: failure()` + `continue-on-error: true`). W Summary daj rewizję, tag obrazu,
adres i gotową komendę rollbacku.

## Powiadomienie po wydaniu

Wynik deployu widzi ten, kto wejdzie w bieg. Jeśli zespół pyta „co chodzi na
środowisku" na czacie, pipeline ma tam pisać sam: wersja, identyfikator rewizji, tag
obrazu, kto wydał, linki do aplikacji i do biegu.

- Krok wysyłający ma `if: always()` **i** `continue-on-error: true`. To obserwowalność,
  nie bramka: padnięty webhook nie może przewrócić udanego deployu ani przemilczeć
  nieudanego.
- Wysyłaj przy **każdym** statusie joba. Czerwony deploy to informacja pilniejsza niż
  zielony.
- Brak sekretu z adresem to `notice` w logu, nie ciche pominięcie. Krok pominięty bez
  słowa wyjaśnienia wygląda jak działający.
- Payload buduj narzędziem do JSON-a (`jq`), nie sklejaniem stringów: tag i opis
  release'a mogą zawierać cudzysłowy, a wtedy odbiorca odpowiada 400 bez wyjaśnienia.
- Nie zapraszaj do aplikacji, gdy deploy padł. Adres odpowiada wtedy ze starej rewizji,
  więc link wygląda jak dowód, że wszystko się udało.

## Czego nie wpisujesz do pipeline'u

- **Migracji bazy.** Idą ręcznie, dev, stage, prod. Jeśli wdrażany kod wymaga
  migracji, powiedz to wprost przy planowaniu PR-a: migracja musi być na środowisku
  przed mergem, który tam ten kod wdroży.
- Podbicia wersji, kasowania artefaktów cudzych projektów, „przy okazji" sprzątania.
