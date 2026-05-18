# 2026-05-18 — Pakowanie skilli w plugin claude-memory

- **Gałąź:** claude/convert-rules-to-skill-2I4zq
- **Cel:** spakować resume/save/graph w instalowalny plugin (repo = marketplace); wybór użytkownika: tylko plugin (bez `.claude/skills/`).

## Co zrobiono

- `git mv .claude/skills` → `plugins/claude-memory/skills/`; `.claude/`
  zniknęło (został tylko nietknięty `settings.local.json`).
- Manifest pluginu `plugins/claude-memory/.claude-plugin/plugin.json`
  (autor: Xentivo sp. z o.o.; opis: „Claude memory - zaoszczędź tokeny").
- Marketplace `.claude-plugin/marketplace.json` w korzeniu repo.
- One-linery w SKILL.md przepisane na `${CLAUDE_SKILL_DIR}`; `save` woła
  generator siostrzanego skilla przez `${CLAUDE_SKILL_DIR}/../graph/...`.
- Zaktualizowano `CLAUDE.md` (sekcja „Dystrybucja: plugin"),
  `docs/claude-memory/README.md`, szablon `assets/README.md`.
- Walidacja: oba JSON-y OK; generator i scaffold działają przez
  `${CLAUDE_SKILL_DIR}` (test w /tmp).

## Kluczowe pliki

- `plugins/claude-memory/.claude-plugin/plugin.json` — manifest.
- `.claude-plugin/marketplace.json` — katalog marketplace.
- `plugins/claude-memory/skills/{resume,save,graph}/SKILL.md`.
- `plugins/claude-memory/skills/graph/generate_graph.py` — generator.

## Decyzje / ustalenia

- Plugin = jedyne źródło; `${CLAUDE_SKILL_DIR}`; namespace komend — patrz
  `../decisions.md`.

## TODO / następny krok

- Instalacja: `/plugin marketplace add https://bitbucket.org/xentivo/claude.git` →
  `/plugin install claude-memory@claude-memory`.
- W tej sesji web skille nieaktywne do dodania marketplace (świadome).
