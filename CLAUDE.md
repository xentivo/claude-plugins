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
w korzeniu) i źródłem trzech pluginów:

- `plugins/claude-memory/` — skille `resume`, `save`, `graph`; generator
  `graph.json` i szablony pamięci wbudowane obok `SKILL.md`.
- `plugins/czlowiek/` — skill `czlowiek` (redakcja polskich tekstów) plus
  cienka komenda `commands/humanizuj.md`, która ten skill woła. Autorka:
  Izabella Pyrkosz, własny `LICENSE` przy pluginie.
- `plugins/pipeline/` - skille `bramka-pr`, `deploy`, `sekrety` plus komenda
  `commands/xvo-zbuduj-pipeline.md`. Procedura, nie treść normatywna: reguły
  żyją w `content/ci-pipeline.md` w `xentivo/mcp-org-rules` i idą przez MCP,
  a skille dociągają je przez `get_rule`. Kopiowanie reguł do `SKILL.md` dałoby
  drugą wersję prawdy, która rozjedzie się przy pierwszej poprawce zasady.

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
/plugin install pipeline@xvo-plugins
```

Repozytorium: https://github.com/xentivo/claude-plugins

Komendy są namespace'owane nazwą pluginu: `/claude-memory:resume`,
`/claude-memory:save`, `/claude-memory:graph`, `/czlowiek:humanizuj`,
`/czlowiek:czlowiek`, `/pipeline:xvo-zbuduj-pipeline`. Pamięć (`docs/claude-memory/`) jest per-projekt —
`/claude-memory:save` zakłada ją z wbudowanych szablonów przy pierwszym
uruchomieniu. Aktualizacja: push do repo + `/plugin marketplace update`.

## Wydanie: `version` podbija pipeline, nie Ty

Po merge'u do `main` workflow „Wydanie (wersje pluginów + changelog)" woła
`scripts/release.sh`. Skrypt sprawdza, którego pluginu dotknęły zmiany od jego
ostatniego taga, podbija `version` w jego manifeście, dopisuje wpis do
`CHANGELOG.md` w formie `zmiana - kto przygotował` i zakłada tag
`<plugin>-<wersja>`. Zasady organizacji: `versioning` i `ci-pipeline` (sekcja
„Wydanie po merge'u"). `./scripts/release.sh --dry-run` pokazuje, co by wyszło.

- **Nie podbijaj `version` z ręki i nie edytuj `CHANGELOG.md`.** Ręczny bump
  konfliktuje z każdym równolegle otwartym PR-em, a przy automerge domyślnym
  nikt tego nie zauważy przed merge'em. Opis zmiany pisze się w tytule PR-a -
  z niego powstaje wpis.
- **Wersja jest per plugin**, bo po tym polu klient rozpoznaje dostępność
  aktualizacji. Podbicie wszystkich naraz zapowiadałoby aktualizację pluginów,
  w których nic się nie zmieniło. Dlatego tagi mają prefiks nazwy pluginu -
  „wersji repo" tutaj nie ma.
- **Tabela wersji w README jest przepisywana przez skrypt.** Jeśli usuniesz albo
  przeformatujesz wiersz pluginu, krok wydania padnie czerwono zamiast cicho
  zostawić README kłamiące o tym, co jest w marketplace.
- **Wewnątrz katalogu pluginu artefaktem jest wszystko poza jego `README.md`** -
  markdown jest tu produktem, nie dokumentacją. Zmiana samego README pluginu albo
  plików w korzeniu repo nie podbija niczego.
- Krok pushuje na chroniony pień, więc wymaga sekretu `RELEASE_TOKEN`
  **z bypassem w ochronie gałęzi**.

Tę sekcję „Pamięć Claude" warto wkleić do `~/.claude/CLAUDE.md`.