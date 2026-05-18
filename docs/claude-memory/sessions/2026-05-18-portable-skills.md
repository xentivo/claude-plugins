# 2026-05-18 — Setup pamięci przenośny między projektami

- **Gałąź:** claude/convert-rules-to-skill-2I4zq
- **Cel:** umożliwić reużycie skilli pamięci w innych projektach (wybór: instalacja globalna `~/.claude/skills/`).

## Co zrobiono

- Przeniesiono generator: `tools/generate_graph.py` →
  `.claude/skills/graph/generate_graph.py`; usunięto katalog `tools/`.
- Wbudowano szablony pamięci w `.claude/skills/save/assets/`
  (`README.md`, `decisions.md`, `_TEMPLATE.md`).
- Skille lokalizują zasoby projektowo lub globalnie (one-liner z `$HOME`).
- `save`: krok 0 — auto-scaffold `docs/claude-memory/` jeśli brak.
- `resume`: brak pamięci nie jest błędem (info zamiast crash).
- Sekcja „Przenoszenie tego setupu..." w `CLAUDE.md`; aktualizacja
  `docs/claude-memory/README.md`; wpis w `decisions.md`.
- Test: generator z nowej ścieżki OK; scaffold świeżego projektu OK.

## Kluczowe pliki

- `.claude/skills/graph/generate_graph.py` — przeniesiony generator.
- `.claude/skills/save/assets/` — szablony pamięci.
- `.claude/skills/{resume,save,graph}/SKILL.md` — wersje przenośne.
- `CLAUDE.md` — sekcja przenoszenia setupu.

## Decyzje / ustalenia

- Skille samowystarczalne pod instalację globalną — patrz `../decisions.md`.

## TODO / następny krok

- Instalacja globalna po stronie użytkownika: skopiować
  `.claude/skills/{resume,save,graph}/` do `~/.claude/skills/`.
- Ew. `bootstrap.sh` dla wariantu zespołowego — tylko na prośbę.
