---
description: Zbuduj albo uzupełnij pipeline CI/CD repozytorium zgodnie z zasadą ci-pipeline organizacji.
argument-hint: [zakres, np. "bramka PR" / "deploy na stage" / pusto = całość]
allowed-tools: mcp__Xentivo_MCP__get_rule mcp__Xentivo_MCP__search_rules Read Write Edit Glob Grep Bash(ls:*) Bash(cat:*) Bash(git ls-files:*) Bash(git log:*) Bash(git status:*)
disable-model-invocation: true
---

Zakres: $ARGUMENTS

Pobierz zasady `ci-pipeline` oraz `structure-conventions` przez `get_rule`. To one
rozstrzygają, nie Twoja pamięć wzorców z innych projektów.

Przeczytaj też procedury z tego pluginu - to one mówią, jak zasadę zastosować:

- `${CLAUDE_PLUGIN_ROOT}/skills/bramka-pr/SKILL.md` - checki na pull requestach
- `${CLAUDE_PLUGIN_ROOT}/skills/deploy/SKILL.md` - wdrażanie i weryfikacja po deployu
- `${CLAUDE_PLUGIN_ROOT}/skills/sekrety/SKILL.md` - sekrety, tokeny, uprawnienia

Bez zakresu w argumencie czytaj wszystkie trzy. Ze zakresem - ten, który go dotyczy,
plus `sekrety`, bo dotyczy każdego workflow.

## 1. Rozpoznaj repo, zanim cokolwiek napiszesz

Ustal i wypisz jednym akapitem: stack i menedżer pakietów, komendy lint/build/test z
`package.json` (albo odpowiednika), obecność `Dockerfile` i skryptów deployowych,
gałąź domyślną, docelowy rejestr obrazów i środowiska, oraz to, co już leży w
`.github/workflows/`. Sprawdź `.gitignore` pod kątem kodu generowanego, który
importuje aplikacja.

Jeśli repo ma skrypt deployowy, pipeline ma go **wołać**, a nie odtwarzać jego kroki.
Brak takiego skryptu odnotuj jako brak i zaproponuj jego napisanie osobno.

## 2. Pokaż plan, potem pisz

Przedstaw listę plików do utworzenia lub zmiany, a przy każdym: wyzwalacze, joby i
to, co dany job łapie. Dopiero po tym twórz pliki. Bez zakresu w argumencie zakładaj
całość: bramka PR-a, skan zależności, deploy na środowisko, auto-merge.

Nie kopiuj workflowów z `xentivo/aria` żywcem. Bierz z nich reguły, a wartości
(obrazy usług, nazwy zmiennych, komendy, ścieżki wykluczeń) wyprowadzaj z tego repo.

## 3. Sprawdź własną robotę przeciwko liście

Dla każdego napisanego pliku przejdź punkt po punkcie zasadę `ci-pipeline` i wypisz,
gdzie świadomie odchodzisz od reguły i dlaczego. Odejście bez powodu popraw, zamiast
tłumaczyć.

Szczególnie: `ready_for_review` w wyzwalaczach, `concurrency` w obie strony
(`true` na PR-ze, `false` w deployu), `permissions` zawężone na górze pliku, warunki
na `env` a nie na `secrets`, obce akcje przypięte do SHA, krok generujący kod w każdym
jobie kompilującym, weryfikacja po deployu w kolejności obraz - stan rewizji -
health-check.

## 4. Powiedz, czego pliki nie załatwią

Zakończ listą rzeczy do ustawienia poza repozytorium: wymagane checki w ochronie
gałęzi (z nazwami jobów), environments i sekrety w nich, federated credentials dla
OIDC, „Allow auto-merge", PAT dla automatu. Zaznacz, że pierwszy bieg uruchomiony
ręcznie jest jedynym testem konfiguracji OIDC.

Nie wymyślaj wartości sekretów ani identyfikatorów chmury. Czego nie wiesz, wypisz
jako do uzupełnienia przez człowieka.
