---
name: bramka-pr
description: Użyj gdy dodajesz albo zmieniasz checki uruchamiane na pull requestach - lint, build, testy, skan zależności, bramka konwencji, auto-merge - czyli przy każdej edycji plików w .github/workflows, które odpalają się na `pull_request`. Pilnuje, żeby bramka faktycznie łapała to, co ma łapać, i nie świeciła zielono na ślepo.
---

# Bramka na pull requestach

Zielona bramka jest warta tyle, ile łapie. Dwa najdroższe błędy to check, którego
nie ma (błąd wychodzi po merge'u), i check, który przechodzi, bo nic nie sprawdził.

Pełna zasada organizacji: `get_rule("ci-pipeline")` na serwerze Xentivo MCP.
Poniżej procedura; uzasadnienia i historie wpadek są w zasadzie.

## Zanim dopiszesz jakikolwiek job

1. Sprawdź, co realnie łamie się w tym repo **po** merge'u. Bramka powstaje z
   incydentu, nie z listy dobrych praktyk.
2. Przeczytaj `Dockerfile` albo skrypt buildu. Job budujący ma odtwarzać ten build,
   który poleci do rejestru, z tymi samymi zmiennymi-placeholderami.
3. Sprawdź, co jest w `.gitignore`, a co importuje kod (klient ORM, kod generowany).
   Każdy job kompilujący musi mieć swój krok generujący.

## Zestaw minimalny

- **Lint** - osobno od testów, bo nie potrzebuje bazy i daje wynik po minucie.
- **Build produkcyjny** - osobna bramka. Bez niej błąd typów wychodzi dopiero przy
  budowaniu obrazu w deployu, czyli po merge'u do pnia.
- **Testy** - z prawdziwymi usługami w `services:`, na obrazach identycznych z tymi,
  których używa deweloper lokalnie.
- **Skan zależności** - z zależnościami deweloperskimi, z kontrolą „ile paczek
  faktycznie przeskanowano" i z progiem blokującym zapisanym czytelnie w kroku.
- **Bramka konwencji** (baza PR-a, nazwa gałęzi) - sekundowy job bez `if` na poziomie
  joba, żeby przy naruszeniu zapalił się na czerwono, a nie pominął. Trzymaj ją
  w **osobnym pliku** od lintu, buildu i testów (patrz reguła niżej).

## Reguły, których nie negocjujemy

- Wyzwalacz dla checków czytających KOD: `[opened, synchronize, reopened,
  ready_for_review]`. Bez ostatniego PR wyjęty z drafta nie dostaje żadnego zdarzenia.
- **Bramka na metadane PR-a idzie do osobnego pliku** i słucha dodatkowo `edited`,
  `labeled` i `unlabeled`. Bazę PR-a przestawia się z UI, a to `edited`, nie
  `synchronize`, więc bez tych zdarzeń check zostaje z wynikiem sprzed zmiany. Nie
  dokładaj tych zdarzeń do pliku z lintem i testami „z warunkiem na rodzaj zdarzenia":
  job pominięty przez `if` raportuje `skipped`, a wymagany check w tym stanie liczy się
  przy ochronie gałęzi **jak zielony** - czyli jedna etykieta nadpisuje czerwone testy
  zielonym pominięciem.
- `concurrency` po numerze PR-a z `cancel-in-progress: true`.
- `permissions: contents: read` na górze pliku; szerzej tylko w jobie, który tego
  potrzebuje.
- Job doradczy (recenzja AI, komentarz bota) ma `continue-on-error: true` i **nigdy**
  nie jest wymaganym checkiem.
- Warunek zależny od sekretu piszesz na `env`, nie na `secrets` - kontekst `secrets`
  w `if` nie działa i cicho daje fałsz.

## Po napisaniu

- Wypisz użytkownikowi listę checków do ustawienia jako **required** w ochronie
  gałęzi. Bez tego bramka jest życzeniem i da się mergować na czerwono.
- Nazwy checków w ochronie gałęzi to `name:` jobów. Zmiana `name:` rozspaja ochronę
  gałęzi po cichu - przy przemianowaniu joba przypomnij o aktualizacji listy.
- Sprawdź składnię (`actionlint`, jeśli jest) i przeczytaj własny diff pod kątem
  jednego pytania: który krok przejdzie, mimo że nic nie sprawdził?
