# Sesja 2026-08-25 - Plugin pipeline, odbudowa po nieudanym przeniesieniu

- **Gałąź:** `claude/test-961kbr`
- **Cel:** dokończyć przeniesienie skilli `pipeline-*` i komendy z `xentivo/mcp-org-rules`
  do tego marketplace'u. Sesja z 24.08.2026 zbudowała ten plugin lokalnie, ale go nie
  wypchnęła.

## Co się stało 24.08.2026

Log tamtej sesji (`mcp-org-rules`, `docs/claude-memory/sessions/2026-08-24-plugin-pipeline.md`)
sam zapisał, co poszło nie tak, w sekcji „Do dokończenia": push do tego repo nie przeszedł,
bo `claude-plugins` nie było w autoryzowanym zestawie źródeł, a `add_repo` odbiło się
o klasyfikator trybu auto. Tamta sesja ostrzegła też o kolejności merge'ów: najpierw PR tutaj,
potem w `mcp-org-rules`. Wyszło odwrotnie - PR #19 w `mcp-org-rules` wszedł i usunął skille
z `.claude/`, a plugin nigdy tu nie dotarł.

Skutek utrzymywał się dobę: `mcp-org-rules` bez skilli, z `pipeline@xvo-plugins`
w `enabledPlugins` i z CLAUDE.md twierdzącym, że plugin żyje tutaj. Komenda
`/pipeline:xvo-zbuduj-pipeline` nie działała u nikogo. Nikt tego nie zgłosił, bo nikt jej
nie próbował użyć.

## Zrobione

Cztery pliki odzyskane z `mcp-org-rules` z commita `8270d33^` (ten, który je usunął) i wydane
jako `plugins/pipeline/`: manifest, README, trzy skille, komenda. Wpis w `marketplace.json`,
sekcje w `README.md` i `CLAUDE.md`.

Nazwy skilli skrócone do konwencji marketplace'u (`bramka-pr`, `deploy`, `sekrety` zamiast
`pipeline-*`) - prefiks był potrzebny w płaskim `.claude/skills/`, tutaj namespace daje nazwa
pluginu. Komenda czyta skille przez `${CLAUDE_PLUGIN_ROOT}`, jak `humanizuj` w `czlowiek`.

## Treść zaktualizowana, nie skopiowana żywcem

Skille pisano pod zasadę `ci-pipeline` w brzmieniu sprzed 25.08.2026, a model auto-merge
zmienił się tego dnia dwukrotnie: z etykiety jako bramki wejściowej na automerge domyślny
z wytrychem `no-automerge`. Trzy miejsca wymagały przepisania, żeby plugin nie wskrzesił
drugiej wersji prawdy:

- `sekrety`: „etykieta to nie autoryzacja" (sprawdzenie aktora **i** autora) zastąpione
  regułą dla modelu domyślnego - bramką jest **autor** PR-a, warunek na aktorze blokowałby
  rolę `triage`. Dołożone dwie pułapki z tego dnia: token automatu potrzebuje
  `Pull requests: Read and write`, bo uzbrajanie idzie mutacją GraphQL
  `enablePullRequestAutoMerge` (REST-owe sprawdzenie uprawnień przechodzi, a uzbrojenie pada),
  oraz rozbrojenie musi zawodzić zamknięte.
- `bramka-pr`: bramka na metadane PR-a idzie do osobnego pliku i słucha `edited`, `labeled`,
  `unlabeled`; dopisany powód, dla którego nie wolno jej wpychać do pliku z testami za `if`
  (job `skipped` liczy się jak zielony wymagany check).
- `deploy`: nowa sekcja o powiadomieniu po wydaniu (`always()` + `continue-on-error`, wysyłka
  przy każdym statusie, payload budowany `jq`-iem, bez linku do aplikacji przy porażce).

## Ustalenia

- Podział obowiązków zapisany w README pluginu i w CLAUDE.md: **normatywna treść zostaje
  w `content/ci-pipeline.md`** w `mcp-org-rules` i idzie przez MCP, plugin trzyma procedurę
  i dociąga resztę przez `get_rule`. Bez serwera MCP plugin jest połowiczny i README to mówi.
- W `mcp-org-rules` nie ma czego poprawiać: `enabledPlugins` i CLAUDE.md opisywały stan
  docelowy, więc po merge'u tego PR-a stają się prawdziwe.
- Zmiana treści zasady `ci-pipeline` wymaga przejrzenia tych skilli i podbicia `version`
  pluginu - po tym polu rozpoznawana jest aktualizacja.
