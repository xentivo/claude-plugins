# 2026-05-18 — Konwersja zasad pamięci na Skille Anthropic

- **Gałąź:** claude/convert-rules-to-skill-2I4zq
- **Cel:** przerobić zasady `/resume` i `/save` na Skille zgodnie z formatem Anthropic.

## Co zrobiono

- Utworzono `.claude/skills/resume/SKILL.md` i `.claude/skills/save/SKILL.md`
  (frontmatter `name` + `description` z frazami-wyzwalaczami + `allowed-tools`,
  treść instrukcji przeniesiona 1:1 z dawnych komend).
- Usunięto `.claude/commands/resume.md` i `.claude/commands/save.md` (katalog
  `.claude/commands/` pusty → usunięty).
- Zaktualizowano odwołania w `CLAUDE.md` i `docs/claude-memory/README.md`
  (Skille zamiast komend, `/resume`, `/save` nadal działają z palca).

## Kluczowe pliki

- `.claude/skills/resume/SKILL.md`, `.claude/skills/save/SKILL.md` — Skille pamięci.
- `CLAUDE.md` — sekcja „Pamięć Claude" (odwołania do Skilli).
- `docs/claude-memory/README.md` — sekcja „Skille".
- `docs/claude-memory/decisions.md` — wpis o decyzji.

## Decyzje / ustalenia

- Pamięć jako Skille, nie komendy slash — uzasadnienie w `../decisions.md`.

## TODO / następny krok

- Używać Skilli `resume`/`save` w kolejnych sesjach (auto-wyzwalanie po opisie).
