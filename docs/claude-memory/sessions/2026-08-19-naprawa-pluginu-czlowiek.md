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

## TODO / następny krok

- Merge PR #1.
- Po merge'u użytkownicy z dodanym starym marketplace muszą zrobić
  `/plugin marketplace remove claude-memory` i dodać ponownie — zmiana nazwy
  nie jest wstecznie zgodna.
