# Claude memory

Plugin do [Claude Code](https://code.claude.com/): trwała, plikowa pamięć
między sesjami i strukturalna mapa repozytorium. Bez zewnętrznych zależności,
zero kosztów API poza samym Claude.

## Zawartość

| Komponent | Ile | Do czego |
|---|---|---|
| Skille | 3 | `resume`, `save`, `graph` — odtwarzanie kontekstu, zapis sesji, mapa repo |
| Komendy | 0 | skille wystarczą |
| Agenci | 0 | niepotrzebni |
| Hooki | 0 | niepotrzebne |
| MCP | 0 | nie łączy się z niczym na zewnątrz |

## Po co

- **Mniej tokenów** — agent nie skanuje od zera tego samego kodu w każdej sesji.
- **Brak amnezji** — decyzje architektoniczne i logi sesji żyją w plikach w repo.
- **Mapa kodu** — `graph.json` (linki Markdown, importy) zamiast ślepego czytania
  wielu plików naraz.

## Skille

Po instalacji komendy mają prefiks `claude-memory:`:

| Skill | Komenda | Kiedy |
| --- | --- | --- |
| **resume** | `/claude-memory:resume` | Na początku sesji — odtwarza kontekst z `decisions.md` i ostatnich logów |
| **save** | `/claude-memory:save` [slug] | Na końcu sesji — zapisuje log, ewentualną decyzję, odświeża `graph.json` |
| **graph** | `/claude-memory:graph` | Przed czytaniem wielu plików — buduje lub odpytuje mapę strukturalną repo |

Skille odpalają się też same, kiedy padnie „wczytaj pamięć", „zapisz sesję"
i podobne — opisy wyzwalaczy siedzą we frontmatterze każdego `SKILL.md`.

## Typowy workflow

1. **`/claude-memory:resume`** — na start sesji.
2. Praca nad kodem (w razie potrzeby **`/claude-memory:graph`**).
3. **`/claude-memory:save`** [opcjonalny-slug] — na koniec sesji.

## Pamięć w projekcie

Pamięć jest **per projekt**. Przy pierwszym `/claude-memory:save` plugin zakłada
katalog z wbudowanych szablonów (`skills/save/assets/`):

```
docs/claude-memory/
├── README.md          # zasady systemu pamięci
├── decisions.md       # trwałe decyzje („dlaczego tak”)
└── sessions/          # logi sesji (YYYY-MM-DD-opis.md)
```

W korzeniu projektu powstaje **`graph.json`** — generowany lokalnie przez
`skills/graph/generate_graph.py` (Python 3, biblioteka standardowa).

Opcjonalnie wklej sekcję „Pamięć Claude" z [`CLAUDE.md`](https://github.com/xentivo/claude-plugins/blob/main/CLAUDE.md)
tego repo do `~/.claude/CLAUDE.md`, żeby agent pamiętał o `resume` i `save` globalnie.

## Jak to zmieniać

Zachowanie każdego skilla siedzi w jego `skills/<nazwa>/SKILL.md`. Szablony
zakładanej pamięci — w `skills/save/assets/`; zmiana tych plików trafia do
wszystkich projektów, w których pamięć dopiero powstanie. Generator mapy to
`skills/graph/generate_graph.py`, bez zewnętrznych zależności — tak ma zostać.

Zasoby własne skille lokalizują przez `${CLAUDE_SKILL_DIR}`, więc plugin działa
tak samo zainstalowany globalnie i projektowo.

## Instalacja

```
/plugin marketplace add xentivo/claude-plugins
/plugin install claude-memory@xvo-plugins
```

Aktualizacja po zmianach w tym repo: `/plugin marketplace update`. Po każdej
zmianie pluginu podbij `version` w `.claude-plugin/plugin.json` — po tym polu
rozpoznawana jest dostępność aktualizacji.

## Wymagania

- [Claude Code](https://code.claude.com/) z obsługą pluginów i skilli
- Python 3 (tylko do generatora `graph.json`; biblioteka standardowa)

## Licencja

MIT, plik [LICENSE](https://github.com/xentivo/claude-plugins/blob/main/LICENSE)
w korzeniu repo — © 2026 XENTIVO.
