---
name: deploy
description: Użyj gdy workflow ma cokolwiek wdrażać - budować obraz, logować się do chmury, podmieniać rewizję albo wersję aplikacji, wdrażać release, robić rollback - a także gdy po merge'u do gałęzi domyślnej ma podbić numer wersji i dopisać wpis do changeloga. Także przy zmianie istniejącego workflow deployowego. Pilnuje, żeby CI nie dorabiało się własnej logiki deployu i żeby „deploy OK" znaczyło „aplikacja wstała".
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

## Wydanie po merge'u: wersja i changelog

Wersję podbija pipeline, nie autor PR-a. Krok wydania odpala się po wejściu PR-a do
gałęzi domyślnej, ustala zakres od ostatniej wersji i jednym commitem podbija numer
oraz dopisuje wpis do `CHANGELOG.md`.

Zanim ten krok napiszesz, ustal w repo trzy rzeczy:

1. **Gdzie stoi numer wersji.** JS - `version` w głównym `package.json`. Java -
   korzeniowy `pom.xml` (`<version>`) albo `build.gradle` / `gradle.properties`. Numer
   powtórzony w każdym module zgłoś jako problem do rozstrzygnięcia; nie podbijaj
   kilku miejsc naraz.
2. **Czy jest tag poprzedniego wydania.** Od niego liczy się zakres, więc krok
   potrzebuje `fetch-depth: 0` **i tagów**. Brak tagów to pierwsze wydanie - powiedz
   to wprost, zamiast wsypać całą historię repo do jednego wpisu.
3. **Co już czyta numer wersji** (tagowanie obrazu, deploy, health-check). To
   rozstrzyga kolejność: build musi wziąć numer PO podbiciu.

Kształt kroku:

- Wpis w formie `zmiana - kto przygotował`: tytuł zmergowanego PR-a z numerem i
  **autor PR-a**. Nie autor commita mergującego - przy automerge to token automatu,
  więc w changelogu wszystko przygotowałby bot.
- Wersja i wpis jednym commitem, tag zaraz po nim. Wersja bez wpisu psuje zakres
  następnego wydania.
- `paths-ignore` na pliku z wersją, changelogu **i lockfile** (`npm version` rusza
  `package-lock.json`) plus warunek na samym commicie, żeby krok nie odpalił sam
  siebie.
- Push **tokenem automatu** z bypassem w ochronie gałęzi. `GITHUB_TOKEN` nie startuje
  kolejnych workflowów, więc obraz z nowym numerem nie powstanie; nieudany push kończy
  job czerwono, bo ciche pominięcie wygląda jak wydanie.
- `concurrency` po gałęzi z `cancel-in-progress: false`.
- Poziom podbicia z jawnego sygnału: domyślnie `patch`, wyżej z etykiety
  `breaking` na PR-ze. Mapowanie rozstrzyga `get_rule("versioning")` - przed
  `1.0.0` zmiana łamiąca kontrakt to MINOR, nie MAJOR. Brak etykiety nie wywraca
  wydania.
- Repo, które wydaje **kilka niezależnych artefaktów** (marketplace pluginów,
  monorepo paczek), nie ma jednej wersji: numer i tag idą per artefakt
  (`<artefakt>-<wersja>`), a podbija się tylko to, czego dotknął merge. Podbicie
  wszystkich naraz zapowiada aktualizację tam, gdzie nic się nie zmieniło.
- Merge bez treści do wydania (same `docs/`) kończy się zielono z wypisanym powodem.

Uzasadnienia i pełna lista pułapek: `get_rule("ci-pipeline")`, sekcja „Wydanie po
merge'u".

## Czego nie wpisujesz do pipeline'u

- **Migracji bazy.** Idą ręcznie, dev, stage, prod. Jeśli wdrażany kod wymaga
  migracji, powiedz to wprost przy planowaniu PR-a: migracja musi być na środowisku
  przed mergem, który tam ten kod wdroży.
- Kasowania artefaktów cudzych projektów, „przy okazji" sprzątania.
