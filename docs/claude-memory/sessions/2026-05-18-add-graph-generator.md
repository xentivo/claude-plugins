# 2026-05-18 — Samodzielny generator graph.json

- **Gałąź:** claude/convert-rules-to-skill-2I4zq
- **Cel:** dodać generator strukturalnej mapy repo (graph.json) bez zewnętrznych narzędzi (art. claude-code-memory-setup, warstwa „Graphify").

## Co zrobiono

- `tools/generate_graph.py` — Python tylko stdlib (`os`, `ast`, `re`,
  `json`). Węzły = pliki; krawędzie: `link`/`wikilink` (Markdown) +
  `import` (Python przez `ast`, JS/TS/shell regex). Symbole .py z `ast`.
  Wyjście deterministyczne (posortowane), `--stdout` opcjonalnie.
- Skill `graph` (`.claude/skills/graph/SKILL.md`) — odświeżanie i
  odpytywanie mapy zamiast skanowania repo.
- Spięcie z pamięcią: krok odświeżania w Skillu `save`, bullet w
  `CLAUDE.md`, sekcja w `docs/claude-memory/README.md`.
- Wpis decyzyjny w `decisions.md`.

## Kluczowe pliki

- `tools/generate_graph.py` — generator.
- `.claude/skills/graph/SKILL.md` — Skill mapy.
- `graph.json` — wygenerowana mapa (korzeń).
- `CLAUDE.md`, `docs/claude-memory/README.md`, `.claude/skills/save/SKILL.md`.

## Decyzje / ustalenia

- Własny generator stdlib zamiast Graphify — uzasadnienie w `../decisions.md`.

## TODO / następny krok

- Ew. git hook `pre-commit` wołający generator — tylko na prośbę użytkownika.
- Rozbudowa krawędzi importów dla JS/TS, jeśli pojawi się realny kod.
