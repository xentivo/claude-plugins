# claude-plugins

Marketplace pluginów [Claude Code](https://code.claude.com/) od **Xentivo sp. z o.o.**
Bez zewnętrznych zależności, zero kosztów API poza samym Claude.

**Repozytorium:** https://github.com/xentivo/claude-plugins

| Plugin | Do czego | Opis |
| --- | --- | --- |
| **claude-memory** | trwała pamięć między sesjami i mapa repo | niżej |
| **czlowiek** | redakcja polskich tekstów, usuwanie AI-owych wzorców | [`plugins/czlowiek/README.md`](plugins/czlowiek/README.md) |

## Instalacja

W dowolnym projekcie z Claude Code:

```
/plugin marketplace add xentivo/claude-plugins
/plugin install claude-memory@xvo-plugins
/plugin install czlowiek@xvo-plugins
```

Aktualizacja po zmianach w tym repo:

```
/plugin marketplace update
```

---

# claude-memory

Trwała, plikowa pamięć między sesjami i strukturalna mapa repozytorium.

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
| **save** | `/claude-memory:save` | Na końcu sesji — zapisuje log, ewentualną decyzję, odświeża `graph.json` |
| **graph** | `/claude-memory:graph` | Przed czytaniem wielu plików — buduje lub odpytuje mapę strukturalną repo |

Pamięć (`docs/claude-memory/`) jest **per projekt**. Przy pierwszym `/save` plugin
tworzy katalog i szablony z wbudowanych assetów.

Opcjonalnie wklej sekcję „Pamięć Claude” z [`CLAUDE.md`](CLAUDE.md) do
`~/.claude/CLAUDE.md`, żeby agent pamiętał o `/resume` i `/save` globalnie.

## Typowy workflow

1. **`/claude-memory:resume`** — na start sesji.
2. Praca nad kodem (w razie potrzeby **`/claude-memory:graph`**).
3. **`/claude-memory:save`** [opcjonalny-slug] — na koniec sesji.

## Pamięć w projekcie

Po pierwszym zapisie powstaje:

```
docs/claude-memory/
├── README.md          # zasady systemu pamięci
├── decisions.md       # trwałe decyzje („dlaczego tak”)
└── sessions/          # logi sesji (YYYY-MM-DD-opis.md)
```

W korzeniu projektu: **`graph.json`** — generowany lokalnie przez Python (stdlib)
wbudowany w skill `graph`.

Szczegóły: [`docs/claude-memory/README.md`](docs/claude-memory/README.md).

---

# czlowiek

Redakcja polskich tekstów. Usuwa wzorce typowe dla nieredagowanego wyjścia modelu
i doprowadza tekst do ustalonego głosu autorki. Jeden skill, `/czlowiek:czlowiek`,
odpalany też automatycznie przy pisaniu i redagowaniu polskich tekstów.

Pełny opis: [`plugins/czlowiek/README.md`](plugins/czlowiek/README.md).
Autorka: Izabella Pyrkosz, licencja MIT ([`plugins/czlowiek/LICENSE`](plugins/czlowiek/LICENSE)).

---

## Struktura tego repo

To repozytorium jest jednocześnie **marketplace** i źródłem pluginów:

```
.claude-plugin/marketplace.json   # katalog marketplace: jakie pluginy są w repo
plugins/
├── claude-memory/
│   ├── .claude-plugin/plugin.json
│   └── skills/
│       ├── resume/
│       ├── save/                 # szablony pamięci w assets/
│       └── graph/
│           └── generate_graph.py # generator graph.json (stdlib)
└── czlowiek/
    ├── .claude-plugin/plugin.json
    └── skills/
        └── czlowiek/SKILL.md
```

Dwa poziomy manifestów to nie pomyłka. `marketplace.json` w korzeniu mówi, jakie
pluginy są w repo. `plugin.json` w katalogu pluginu opisuje ten jeden plugin.
Dodając kolejny plugin, zakładasz katalog w `plugins/` i dopisujesz wpis w
`marketplace.json`. Po każdej zmianie pluginu podbij jego `version` — po tym polu
rozpoznawana jest dostępność aktualizacji.

Skille używają `${CLAUDE_SKILL_DIR}` — działają jako plugin, instalacja
projektowa i globalna.

## Wymagania

- [Claude Code](https://code.claude.com/) z obsługą pluginów i skilli
- Python 3 (tylko do generatora `graph.json`; biblioteka standardowa)
