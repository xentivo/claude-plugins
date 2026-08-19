# Reguły dla Claude Code

## Pamięć Claude

Trwała pamięć między sesjami żyje w `docs/claude-memory/`
(`README.md` — zasady, `decisions.md` — dziennik decyzji, `sessions/` —
logi sesji).

- Na początku sesji uruchom Skill `resume` (`/claude-memory:resume`), by odtworzyć kontekst, zanim zaczniesz pracę.
- Na końcu sesji uruchom Skill `save` (`/claude-memory:save`), by zapisać log sesji i ew. nową decyzję.
- Strukturalną mapę repo trzyma `graph.json` (korzeń) generowany lokalnie przez generator wbudowany w Skill `graph` (`generate_graph.py` w folderze skilla). Przed czytaniem wielu plików uruchom Skill `graph` (`/claude-memory:graph`) i odpytaj mapę zamiast skanować repo. Zero zewnętrznych zależności.
- Trwałe ustalenia traktuj jak źródło prawdy „dlaczego tak”; nie duplikuj tu treści — w razie sprzeczności pierwszeństwo ma `CLAUDE.md`.

## Dystrybucja: marketplace `xvo-plugins`

To repo jest marketplace `xvo-plugins` (`.claude-plugin/marketplace.json`
w korzeniu) i źródłem dwóch pluginów:

- `plugins/claude-memory/` — skille `resume`, `save`, `graph`; generator
  `graph.json` i szablony pamięci wbudowane obok `SKILL.md`.
- `plugins/czlowiek/` — skill `czlowiek` (redakcja polskich tekstów) plus
  cienka komenda `commands/humanizuj.md`, która ten skill woła. Autorka:
  Izabella Pyrkosz, własny `LICENSE` przy pluginie.

Konwencja: każdy plugin ma własny katalog w `plugins/<nazwa>/` z manifestem
`.claude-plugin/plugin.json` i wpis w `marketplace.json`. Komponenty są
autowykrywane z `skills/`, `commands/`, `agents/`, `hooks/hooks.json`.
Katalog `.claude-plugin/` w korzeniu repo jest zarezerwowany — czytany jest
z niego wyłącznie `marketplace.json`, więc **nie wrzucaj tam pluginu**
(zdarzyło się dwa razy przy „Add files via upload" w GitHub UI; plugin był
wtedy niewidoczny, raz zgubił się `plugin.json`).

Zasoby własne skille lokalizują przez `${CLAUDE_SKILL_DIR}`, a pliki
pluginu przez `${CLAUDE_PLUGIN_ROOT}` — działa tak samo jako plugin,
instalacja projektowa i globalna.

Instalacja w dowolnym projekcie:

```
/plugin marketplace add xentivo/claude-plugins
/plugin install claude-memory@xvo-plugins
/plugin install czlowiek@xvo-plugins
```

Repozytorium: https://github.com/xentivo/claude-plugins

Komendy są namespace'owane nazwą pluginu: `/claude-memory:resume`,
`/claude-memory:save`, `/claude-memory:graph`, `/czlowiek:humanizuj`,
`/czlowiek:czlowiek`. Pamięć (`docs/claude-memory/`) jest per-projekt —
`/claude-memory:save` zakłada ją z wbudowanych szablonów przy pierwszym
uruchomieniu. Aktualizacja: push do repo + `/plugin marketplace update`;
po każdej zmianie pluginu podbij jego `version`, bo po tym polu rozpoznawana
jest dostępność aktualizacji.

Tę sekcję „Pamięć Claude" warto wkleić do `~/.claude/CLAUDE.md`.