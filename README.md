# claude-plugins

Marketplace `xvo-plugins` — pluginy [Claude Code](https://code.claude.com/)
od **Xentivo sp. z o.o.** Bez zewnętrznych zależności, zero kosztów API poza
samym Claude.

**Repozytorium:** https://github.com/xentivo/claude-plugins

| Plugin | Wersja | Komendy | Do czego |
| --- | --- | --- | --- |
| **claude-memory** | 1.0.2 | `/claude-memory:resume` `:save` `:graph` | Trwała pamięć między sesjami i mapa repo |
| **czlowiek** | 1.1.0 | `/czlowiek:humanizuj` `/czlowiek:czlowiek` | Redakcja polskich tekstów, usuwanie AI-owych wzorców |
| **pipeline** | 1.0.0 | `/pipeline:xvo-zbuduj-pipeline` | Budowanie pipeline'ów CI/CD zgodnie z zasadą `ci-pipeline` |
| **wydanie** | 1.0.0 | `/wydanie:xvo-wydaj` | Wydania: release z pnia z wersją z pliku wersjonującego repo |

## Instalacja

W dowolnym projekcie z Claude Code:

```
/plugin marketplace add xentivo/claude-plugins
/plugin install claude-memory@xvo-plugins
/plugin install czlowiek@xvo-plugins
/plugin install pipeline@xvo-plugins
/plugin install wydanie@xvo-plugins
```

Aktualizacja po zmianach w tym repo:

```
/plugin marketplace update
```

Marketplace nazywał się wcześniej `claude-memory`. Jeżeli masz go dodanego pod
starą nazwą, `/plugin marketplace update` nie wystarczy — usuń go i dodaj
ponownie:

```
/plugin marketplace remove claude-memory
/plugin marketplace add xentivo/claude-plugins
```

---

# claude-memory

Trwała, plikowa pamięć między sesjami i strukturalna mapa repozytorium — agent
nie skanuje w kółko tego samego kodu i nie zapomina, dlaczego coś wygląda tak,
a nie inaczej.

| Skill | Komenda | Kiedy |
| --- | --- | --- |
| **resume** | `/claude-memory:resume` | Na początku sesji — odtwarza kontekst z `decisions.md` i ostatnich logów |
| **save** | `/claude-memory:save` [slug] | Na końcu sesji — zapisuje log, ewentualną decyzję, odświeża `graph.json` |
| **graph** | `/claude-memory:graph` | Przed czytaniem wielu plików — buduje lub odpytuje mapę strukturalną repo |

Pamięć (`docs/claude-memory/`) jest per projekt; przy pierwszym `save` plugin
zakłada ją z wbudowanych szablonów.

Pełny opis: [`plugins/claude-memory/README.md`](plugins/claude-memory/README.md).
Autor: Xentivo sp. z o.o., licencja MIT ([`LICENSE`](LICENSE)).

---

# czlowiek

Redakcja polskich tekstów. Usuwa wzorce typowe dla nieredagowanego wyjścia modelu
i doprowadza tekst do ustalonego głosu autorki.

| Co | Komenda | Kiedy |
| --- | --- | --- |
| **komenda** `humanizuj` | `/czlowiek:humanizuj <tekst\|plik>` | Kiedy chcesz zredagować konkretny tekst albo plik |
| **skill** `czlowiek` | `/czlowiek:czlowiek` | To samo; odpala się też sam przy pisaniu i redagowaniu polskich tekstów |

Pełny opis: [`plugins/czlowiek/README.md`](plugins/czlowiek/README.md).
Autorka: Izabella Pyrkosz, licencja MIT ([`plugins/czlowiek/LICENSE`](plugins/czlowiek/LICENSE)).

---

# pipeline

Budowanie i poprawianie pipeline'ów CI/CD zgodnie z zasadą `ci-pipeline` organizacji.

| Co | Komenda | Kiedy |
| --- | --- | --- |
| **komenda** `xvo-zbuduj-pipeline` | `/pipeline:xvo-zbuduj-pipeline [zakres]` | Gdy stawiasz pipeline w repo albo uzupełniasz brakujący obszar |
| **skill** `bramka-pr` | odpala się sam | Przy edycji workflowów uruchamianych na `pull_request` |
| **skill** `deploy` | odpala się sam | Gdy workflow buduje obraz, wdraża rewizję albo robi rollback |
| **skill** `sekrety` | odpala się sam | Gdy workflow dotyka sekretów, tokenów, `permissions`, OIDC albo obcych akcji |

Treść normatywna nie jest tutaj: reguły żyją w `content/ci-pipeline.md`
w [`xentivo/mcp-org-rules`](https://github.com/xentivo/mcp-org-rules) i idą przez MCP,
a skille dociągają je przez `get_rule`. **Bez dostępu do serwera Xentivo MCP plugin
jest połowiczny** - procedura poprowadzi przez kroki, uzasadnienia zostaną poza
zasięgiem.

Pełny opis: [`plugins/pipeline/README.md`](plugins/pipeline/README.md).

---

# wydanie

Tworzenie wydań zgodnie z zasadą `versioning` organizacji: release z pnia, tag równy
wersji z pliku wersjonującego repo.

| Co | Komenda | Kiedy |
| --- | --- | --- |
| **komenda** `xvo-wydaj` | `/wydanie:xvo-wydaj [rc\|sprawdź]` | Gdy wydajesz wersję albo chcesz wiedzieć, czy można |
| **skill** `wersja` | odpala się sam | Przy odczycie i podbijaniu numeru wersji |
| **skill** `wydanie` | odpala się sam | Przy tworzeniu release'a, tagowaniu i wycofywaniu |

Sedno: jeśli deploy na produkcję startuje z `release: published`, **kliknięcie
„Publish" jest deployem**. Dlatego plugin tworzy draft, sprawdza migracje i czeka na
wyraźne „publikuj", a wersję czyta z pnia, nie z lokalnego drzewa.

Treść normatywna nie jest tutaj: reguły żyją w `content/versioning.md`
w [`xentivo/mcp-org-rules`](https://github.com/xentivo/mcp-org-rules) i idą przez MCP,
a skille dociągają je przez `get_rule`.

Pełny opis: [`plugins/wydanie/README.md`](plugins/wydanie/README.md).

---

## Struktura tego repo

To repozytorium jest jednocześnie **marketplace** i źródłem pluginów:

```
.claude-plugin/marketplace.json   # katalog marketplace: jakie pluginy są w repo
plugins/
├── claude-memory/
│   ├── .claude-plugin/plugin.json
│   ├── README.md
│   └── skills/
│       ├── resume/
│       ├── save/                 # szablony pamięci w assets/
│       └── graph/
│           └── generate_graph.py # generator graph.json (stdlib)
├── czlowiek/
│   ├── .claude-plugin/plugin.json
│   ├── README.md
│   ├── LICENSE                   # inna autorka niż reszta repo
│   ├── commands/humanizuj.md     # ręczne wyzwolenie skilla
│   └── skills/
│       └── czlowiek/SKILL.md
├── pipeline/
│   ├── .claude-plugin/plugin.json
│   ├── README.md
│   ├── commands/xvo-zbuduj-pipeline.md
│   └── skills/
│       ├── bramka-pr/SKILL.md
│       ├── deploy/SKILL.md
│       └── sekrety/SKILL.md
└── wydanie/
    ├── .claude-plugin/plugin.json
    ├── README.md
    ├── commands/xvo-wydaj.md
    └── skills/
        ├── wersja/SKILL.md
        └── wydanie/SKILL.md
```

Dwa poziomy manifestów to nie pomyłka. `marketplace.json` w korzeniu mówi, jakie
pluginy są w repo. `plugin.json` w katalogu pluginu opisuje ten jeden plugin.
Dodając kolejny plugin, zakładasz katalog w `plugins/` i dopisujesz wpis w
`marketplace.json`. Po każdej zmianie pluginu podbij jego `version` — po tym polu
rozpoznawana jest dostępność aktualizacji.

Wewnątrz pluginu komponenty są autowykrywane: `skills/` (podkatalog z `SKILL.md`),
`commands/` (płaskie pliki `.md`), `agents/`, `hooks/hooks.json`. Nazwa komendy
z `commands/` bierze się z nazwy pliku, nazwa skilla z pola `name` we frontmatterze.

**Plugin nie idzie do `.claude-plugin/`.** Ten katalog jest zarezerwowany —
Claude Code czyta z niego wyłącznie `marketplace.json`, a wszystko inne ignoruje.
Plugin wrzucony tam jest niewidoczny; miejsce na plugin to `plugins/<nazwa>/`.
Uwaga też na „Add files via upload" w GitHub UI: gubi zagnieżdżone katalogi
zaczynające się od kropki, więc `plugin.json` potrafi nie dojechać.

Skille lokalizują swoje zasoby przez `${CLAUDE_SKILL_DIR}`, a pliki pluginu
przez `${CLAUDE_PLUGIN_ROOT}` — działa jako plugin, instalacja projektowa
i globalna.

Szczegóły każdego pluginu — instalacja, wymagania, jak go zmieniać — siedzą
w jego własnym `README.md`.
