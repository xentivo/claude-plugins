# 2026-08-19 — Naprawa dodania pluginu czlowiek, marketplace = xvo-plugins

- **Gałąź:** `claude/verify-czlowiek-plugin-kibzy8` (PR #1)
- **Cel:** zweryfikować, czy plugin `czlowiek` jest poprawnie dodany do repo — okazało się, że nie, więc naprawić.

## Co zrobiono

- **Diagnoza.** Commit „Add files via upload" wrzucił całe cudze repo (Meaning Lab)
  do zarezerwowanego katalogu `.claude-plugin/czlowiek-humanizator/`. Cztery błędy:
  brak `plugin.json` (GitHub UI zgubił zagnieżdżony ukryty katalog), brak wpisu
  w `marketplace.json`, zła lokalizacja (z `.claude-plugin/` czytany jest tylko
  `marketplace.json`), duplikat w postaci zipa `humanizator skill/czlowiek.skill`
  z bajt w bajt tym samym `SKILL.md`.
- Przeniesiono plugin do `plugins/czlowiek/` (skill, README, LICENSE autorki).
- Dopisano brakujący `plugins/czlowiek/.claude-plugin/plugin.json` (v1.0.0).
- Zarejestrowano `czlowieka` w `.claude-plugin/marketplace.json`.
- Usunięto `.claude-plugin/czlowiek-humanizator/` i zip `.skill`.
- Zmieniono nazwę marketplace `claude-memory` → `xvo-plugins`.
- Przepisano `README.md` pod dwa pluginy, zaktualizowano `CLAUDE.md`
  i `docs/claude-memory/README.md`, odświeżono `graph.json`.

## Kluczowe pliki

- `.claude-plugin/marketplace.json` — katalog marketplace `xvo-plugins`, dwa wpisy.
- `plugins/czlowiek/.claude-plugin/plugin.json` — manifest, tu podbijać `version`.
- `plugins/czlowiek/skills/czlowiek/SKILL.md` — katalog wzorców i „Głos docelowy",
  jedyne miejsce do edycji zachowania pluginu.
- `plugins/czlowiek/LICENSE` — MIT, © 2026 Izabella Pyrkosz (inny autor niż reszta repo).

## Decyzje / ustalenia

- Marketplace nazywa się `xvo-plugins`, nie `claude-memory` — patrz `../decisions.md`.
- LICENSE `czlowieka` zostaje przy pluginie zamiast być scalony z korzeniowym,
  bo prawa autorskie należą do kogoś innego niż Xentivo.

## Runda 2 (po merge'u PR #1)

- **Nadprogramowe pliki.** Równolegle z PR #1 wgrano na `main` kolejną kopię
  pluginu: `.claude-plugin/czlowiek-humanizator/czlowiek-skill/` (4 pliki)
  plus paczka `czlowiek.plugin` (zip). Merge ich nie usunął, bo leżały pod
  innymi ścieżkami niż te, które kasował PR. `SKILL.md` i `LICENSE` bajt
  w bajt takie same jak w `plugins/czlowiek/`, README bez sekcji Instalacja
  i Licencja — czyli starsze. Cały katalog usunięty.
- Z paczki `czlowiek.plugin` przeniesiono do manifestu `keywords` i `license`
  (jedyne, czego w nim brakowało); reszta była duplikatem.
- **Nowa komenda** `plugins/czlowiek/commands/humanizuj.md` →
  `/czlowiek:humanizuj [tekst|plik]`. Woła skill przez
  `${CLAUDE_PLUGIN_ROOT}/skills/czlowiek/SKILL.md`, ma
  `disable-model-invocation: true`, żeby nie dublować automatycznego
  wyzwalania skilla. Wersja pluginu 1.0.0 → 1.1.0.

## Runda 3 (dokumentacja)

- `CLAUDE.md`: sekcja dystrybucji przepisana pod dwa pluginy; komendy pamięci
  podane jako `/claude-memory:*` zamiast gołych `/resume`, `/save`, `/graph`
  (gołe działają tylko przy braku kolizji nazw); dopisana konwencja układu
  pluginu, autowykrywane katalogi i zakaz wrzucania pluginu do `.claude-plugin/`.
- `README.md`: tabela pluginów z wersjami i komendami, instrukcja migracji po
  zmianie nazwy marketplace, opis autowykrywania `skills/` i `commands/`.
- `docs/claude-memory/README.md`: nazwa marketplace, migracja, wzmianka o drugim
  pluginie.
- `plugins/claude-memory/skills/save/assets/README.md` — szablon wysyłany do
  cudzych projektów miał `claude-memory@claude-memory`; poprawione na
  `@xvo-plugins`. Za to podbita wersja pluginu na 1.0.1.
- `decisions.md`: nowy wpis o cienkiej komendzie, stary wpis z 2026-05-18
  oznaczony jako częściowo nieaktualny (nazwa marketplace).

## TODO / następny krok

- Po merge'u użytkownicy z dodanym starym marketplace muszą zrobić
  `/plugin marketplace remove claude-memory` i dodać ponownie — zmiana nazwy
  nie jest wstecznie zgodna.
- **Nie wrzucać pluginów przez „Add files via upload" w GitHub UI.** Dwa razy
  z rzędu wylądowały w `.claude-plugin/` i raz zgubiły `plugin.json`. Miejsce
  na plugin to `plugins/<nazwa>/`.
