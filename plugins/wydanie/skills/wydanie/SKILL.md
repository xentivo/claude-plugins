---
name: wydanie
description: Użyj gdy trzeba wydać wersję na produkcję - utworzyć release GitHuba, otagować pień, sprawdzić co wchodzi do wydania, albo wycofać to, co pojechało. Także przy pytaniach "czy można wydawać", "co jest w tym wydaniu", "jak cofnąć". Pilnuje, żeby publikacja release'a nie zaskoczyła nikogo deployem na produkcję.
---

# Wydanie

Pełna zasada organizacji: `get_rule("versioning")` na serwerze Xentivo MCP. Numer
wersji i jego plik: skill `wersja`.

Jedna rzecz decyduje o całej procedurze: **jeśli deploy na produkcję startuje
z `release: published`, to kliknięcie „Publish" jest deployem.** Sprawdź to zanim
cokolwiek zrobisz:

```bash
grep -rn "release:" .github/workflows/ | grep -A1 types
```

Jest taki wyzwalacz - obowiązuje wszystko niżej. Nie ma - release jest tylko
znacznikiem historii i połowa tych kroków jest zbędna.

## Przed wydaniem: pięć rzeczy do sprawdzenia

**1. Wersję czytaj z pnia, nie z lokalnego drzewa.**

```bash
git fetch origin main --tags
git show origin/main:package.json | jq -r .version
```

Lokalna gałąź potrafi mieć inny numer niż pień, a wdroży się to, co w tagu.

**2. Tag nie może istnieć.**

```bash
WERSJA="$(git show origin/main:package.json | jq -r .version)"
git ls-remote --tags origin "refs/tags/$WERSJA"   # musi nic nie zwrócić
```

Zwrócił coś - **wersja nie została podbita** w którymś z PR-ów, które od tamtego
wydania weszły do pnia. To pominięty krok, nie powód do przestawienia taga. Podbij
wersję osobnym PR-em i wydaj następny numer. Taga wskazującego na wydany artefakt nie
przestawiaj nigdy: przestaje być odpowiedzią na pytanie, co stało na produkcji.

**3. Czy w ogóle jest co wydawać.**

```bash
git log --oneline "$(git tag --sort=-v:refname | head -1)"..origin/main
git diff --stat "$(git tag --sort=-v:refname | head -1)"..origin/main
```

Same commity w `docs/`, `*.md` i `.github/` znaczą, że artefakt się nie zmienił.
Wydanie dopisałoby wtedy do historii pozycję, której nie da się ani wdrożyć, ani
wycofać deployem.

**4. CI zielone na dokładnie tym commicie**, który tagujesz. Nie „na pniu ostatnio",
bo między biegami mógł wejść kolejny merge.

**5. Migracje bazy już na produkcji.** Pipeline wydania ich nie robi. Migracja
wymagana przez wydawany kod idzie ręcznym runnerem repo **przed** publikacją, w
kolejności dev, stage, prod. Nie wiesz, czy jakaś czeka - sprawdź, zanim publikujesz,
nie po.

## Utworzenie release'a

Draft najpierw, publikacja osobnym krokiem. Nie z ostrożności: publikacja jest
deployem, więc te dwa kroki to dwie różne decyzje.

```bash
gh release create "$WERSJA" \
  --target main \
  --title "$WERSJA" \
  --generate-notes \
  --draft
```

- `--target main` - wydanie idzie **z pnia**. Gałąź `release_*` jako cel wprowadzałaby
  drugi pień, czego model gałęzi nie dopuszcza (`get_rule("git-workflow")`).
- Tag to **goła wersja**, bez prefiksu `v`. Nazwa release'a taka sama jak tag.
- `--generate-notes` - notatki składa GitHub z tytułów PR-ów scalonych od poprzedniego
  taga. Nie pisz ich z ręki: rozjadą się z tym, co naprawdę weszło.

Przeczytaj wygenerowane notatki (`gh release view "$WERSJA"`). Tytuł PR-a, który nic
nie mówi, poprawiasz **w PR-ze**, nie w notatkach; przy następnym generowaniu wróci.

Potem publikacja:

```bash
gh release edit "$WERSJA" --draft=false
```

Od tej chwili biegnie deploy. Zobacz, czym się skończył, zamiast zakładać:

```bash
gh run list --workflow "Deploy PROD" --limit 1
```

## Pre-release

`rc`, `beta` i inne wersje do sprawdzenia na stage:

```bash
gh release create "0.2.0-rc.1" --target main --title "0.2.0-rc.1" --generate-notes --prerelease
```

Bramka deployu ma pre-release **przepuszczać na zielono i nie wdrażać**. Czerwony
krzyżyk przy celowo wydanym rc uczy ludzi ignorować status tego workflow, a wtedy
przestaje działać jako sygnał przy prawdziwej awarii.

## Wycofanie

**Nie usuwaj release'a ani taga.** Usunięty tag zabiera możliwość odtworzenia tego, co
stało na produkcji, i psuje changelog następnego wydania.

Do natychmiastowego powrotu użyj ręcznego uruchomienia deployu ze wskazaniem
poprzedniego taga:

```bash
gh workflow run "Deploy PROD" -f tag="$POPRZEDNI"
```

Trwałe wycofanie idzie **następnym numerem**: revert PR-a w pniu, podbicie wersji,
nowe wydanie. Historia wydań ma pokazywać, co się stało, a nie wyglądać na czystą.

## Czego to wydanie nie załatwia

Jeśli deploy na produkcję nie ma wyzwalacza `release: published`, release nie wdraża
niczego i nie jest bramką. Wtedy pytanie „jak wydajemy" dotyczy pipeline'u deployowego,
nie release'ów - patrz `get_rule("ci-pipeline")` i plugin `pipeline@xvo-plugins`.
