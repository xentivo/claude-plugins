# Reguły dla Claude Code

## Pamięć Claude

Trwała pamięć między sesjami żyje w `docs/claude-memory/`
(`README.md` — zasady, `decisions.md` — dziennik decyzji, `sessions/` —
logi sesji).

- Na początku sesji uruchom Skill `resume` (`/resume`), by odtworzyć kontekst, zanim zaczniesz pracę.
- Na końcu sesji uruchom Skill `save` (`/save`), by zapisać log sesji i ew. nową decyzję.
- Strukturalną mapę repo trzyma `graph.json` (korzeń) generowany lokalnie przez generator wbudowany w Skill `graph` (`generate_graph.py` w folderze skilla). Przed czytaniem wielu plików uruchom Skill `graph` (`/graph`) i odpytaj mapę zamiast skanować repo. Zero zewnętrznych zależności.
- Trwałe ustalenia traktuj jak źródło prawdy „dlaczego tak”; nie duplikuj tu treści — w razie sprzeczności pierwszeństwo ma `CLAUDE.md`.

## Dystrybucja: marketplace `xvo-plugins`

Skille `resume`, `save`, `graph` są spakowane jako plugin Claude Code,
a to repo pełni jednocześnie rolę marketplace:

- Plugin: `plugins/claude-memory/` (manifest `.claude-plugin/plugin.json`,
  skille w `skills/`, generator i szablony pamięci wbudowane obok `SKILL.md`).
- Marketplace: `.claude-plugin/marketplace.json` w korzeniu repo — wymienia
  wszystkie pluginy z `plugins/`. Drugi plugin to `czlowiek` (redakcja polskich
  tekstów, `/czlowiek:czlowiek`); każdy nowy plugin dostaje własny katalog w
  `plugins/` z `.claude-plugin/plugin.json` i wpis w `marketplace.json`.
- Skille lokalizują własne zasoby przez `${CLAUDE_SKILL_DIR}` — działa tak
  samo jako plugin, instalacja projektowa i globalna.

Instalacja w dowolnym projekcie:

```
/plugin marketplace add xentivo/claude-plugins
/plugin install claude-memory@xvo-plugins
/plugin install czlowiek@xvo-plugins
```

Repozytorium: https://github.com/xentivo/claude-plugins

Komendy są namespace'owane: `/claude-memory:resume`, `/claude-memory:save`,
`/claude-memory:graph`. Pamięć (`docs/claude-memory/`) jest per-projekt —
`/claude-memory:save` zakłada ją z wbudowanych szablonów przy pierwszym
uruchomieniu. Aktualizacja: push do repo + `/plugin marketplace update`.
Tę sekcję „Pamięć Claude" warto wkleić do `~/.claude/CLAUDE.md`.