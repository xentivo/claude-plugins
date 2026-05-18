# 2026-05-18 — Wdrożenie systemu pamięci Claude

- **Gałąź:** claude/add-code-memory-system-JUPY8
- **Cel:** dać Claude Code trwałą pamięć między sesjami (na bazie artykułu o `claude-code-memory-setup`).

## Co zrobiono

- Utworzono `docs/claude-memory/` z `README.md`, `decisions.md`, szablonem `sessions/_TEMPLATE.md` i tym logiem.
- Dodano komendy `/resume` i `/save` w `.claude/commands/`.
- Dopisano sekcję „Pamięć Claude” w `CLAUDE.md`.

## Kluczowe pliki

- `docs/claude-memory/README.md` — opis i zasady systemu.
- `docs/claude-memory/decisions.md` — dziennik decyzji.
- `.claude/commands/resume.md`, `.claude/commands/save.md` — komendy.
- `CLAUDE.md` — sekcja „Pamięć Claude”.

## Decyzje / ustalenia

- Pominięto Obsidian i Graphify — uzasadnienie w `../decisions.md` (środowisko offline, repo ma już mapy kontekstu).

## TODO / następny krok

- Faktycznie używać `/resume` na start i `/save` na koniec kolejnych sesji.
- Rozważyć osobne zadanie dla mapy strukturalnej kodu, jeśli zajdzie potrzeba.
