---
description: Wydaj wersję z pnia - release GitHuba z tagiem równym wersji z pliku wersjonującego repo.
argument-hint: [pusto = wersja z pnia | rc = pre-release | "sprawdź" = tylko kontrola bez tworzenia]
allowed-tools: mcp__Xentivo_MCP__get_rule mcp__Xentivo_MCP__search_rules Read Glob Grep Bash(git fetch:*) Bash(git show:*) Bash(git log:*) Bash(git tag:*) Bash(git ls-remote:*) Bash(git diff:*) Bash(jq:*) Bash(gh release:*) Bash(gh run list:*) Bash(gh workflow list:*)
disable-model-invocation: true
---

Tryb: $ARGUMENTS

Pobierz zasadę `versioning` przez `get_rule`. To ona rozstrzyga, nie Twoja pamięć
konwencji z innych projektów.

Przeczytaj procedury z tego pluginu:

- `${CLAUDE_PLUGIN_ROOT}/skills/wersja/SKILL.md` - gdzie w tym repo żyje numer wersji
- `${CLAUDE_PLUGIN_ROOT}/skills/wydanie/SKILL.md` - jak wygląda wydanie i czym grozi
  publikacja

## 1. Ustal, czym jest tu publikacja

Sprawdź, czy któryś workflow startuje z `release: published`. Powiedz wprost, co
wyjdzie: albo publikacja odpala deploy na produkcję, albo release jest tylko
znacznikiem historii. Od tego zależy, ile z dalszych kroków ma sens.

## 2. Zbierz stan, zanim cokolwiek utworzysz

Wypisz jednym blokiem, z komendami i ich wyjściem:

- wersja w pniu i plik, z którego pochodzi (repo bez takiego pliku: ostatni tag)
- czy tag o tej nazwie już istnieje w `origin`
- co weszło od poprzedniego taga: lista commitów i `--stat` zmienionych ścieżek
- wynik CI na commicie, który zamierzasz otagować
- czy repo ma migracje bazy i czy któraś czeka niewdrożona

Tag już istnieje albo od poprzedniego wydania zmieniły się wyłącznie ścieżki, które
nie wchodzą do artefaktu - **zatrzymaj się i powiedz to**. Pierwsze znaczy pominięte
podbicie w PR-ze, drugie znaczy, że nie ma czego wydawać. Żadnego z nich nie obchodź
przestawianiem taga.

## 3. Pokaż, co utworzysz, potem twórz

Podaj: tag, tytuł, cel (`main`), tryb (draft czy pre-release) i skąd wezmą się
notatki. Dopiero po tym wołaj `gh release create` z `--draft`.

Bez argumentu zakładaj draft z wersji z pnia. Argument `rc` znaczy pre-release.
Argument `sprawdź` znaczy: zrób kroki 1 i 2, nic nie twórz.

## 4. Publikacja jest osobną decyzją

Po utworzeniu draftu przeczytaj wygenerowane notatki i pokaż je. Potem, jeśli
publikacja odpala deploy:

**nie publikuj sam.** Napisz, co zostało do zrobienia i czego brakuje - w
szczególności czy migracje są na produkcji. Publikuj wyłącznie na wyraźne „publikuj".

Jeśli release niczego nie wdraża, publikuj od razu i powiedz, że to zrobiłeś.

## 5. Po publikacji

Znajdź bieg deployu i podaj jego wynik oraz link. „Release opublikowany" nie znaczy
„aplikacja wstała" - dopóki nie masz statusu tego biegu, nie meldujesz sukcesu.

## Czego nie robisz

- Nie podbijasz wersji tą komendą. Podbicie idzie w PR-ze ze zmianą, która na nie
  zasługuje - inaczej powstaje commit „a teraz wersja" bez powodu w historii.
- Nie usuwasz i nie przestawiasz tagów ani release'ów.
- Nie piszesz notatek z ręki, gdy GitHub umie je wygenerować.
- Nie wydajesz z gałęzi innej niż pień.
