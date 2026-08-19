# Pluginy — Izabella Pyrkosz

Repozytorium z pluginami do Claude Code i Claude Cowork. Na razie jest tu jeden.

## Człowiek

Redakcja polskich tekstów. Robi dwie rzeczy naraz: usuwa wzorce typowe dla nieredagowanego wyjścia modelu i doprowadza tekst do ustalonego głosu autorki.

Kolejność jest istotna. Najpierw odejmowanie wzorców, potem dodawanie głosu. Odwrotnie wychodzi tekst gładki i pusty, co jest gorszym problemem niż myślnik w niewłaściwym miejscu.

**Co dostajesz na wyjściu:** przepisany tekst, potem lista rzeczywistych trafień z cytatami, potem lista miejsc oznaczonych do uzupełnienia. Kiedy tekst jest czysty, plugin to napisze zamiast dopychać listę.

**Kiedy się uruchamia:** sam, kiedy padnie „humanizuj", „przepisz to po ludzku", „brzmi jak AI", „sprawdź pod kątem AI", „napisz to moim głosem", „popraw styl", albo kiedy wklejasz tekst i prosisz o redakcję stylistyczną. Odpala się też przy pisaniu nowych polskich tekstów, bo domyślny styl modelu wpada w te wzorce sam z siebie.

**Czego nie robi:** nie zmyśla. Zamiast wymyślonego wspomnienia, nazwiska albo daty zostawia `[DO UZUPEŁNIENIA: ...]` albo `[ŹRÓDŁO?]` z opisem, czego brakuje. Głos docelowy nie dotyczy też tekstów użytkowych, więc UX copy i komunikaty błędów zostają rzeczowe.

Pełny opis: [`plugins/czlowiek/README.md`](plugins/czlowiek/README.md).

## Instalacja

```
/plugin marketplace add <użytkownik>/<nazwa-repo>
/plugin install czlowiek@izabella-pyrkosz
```

Lokalnie, bez wypychania na GitHuba:

```
/plugin marketplace add /ścieżka/do/tego/katalogu
/plugin install czlowiek@izabella-pyrkosz
```

Po wypchnięciu zmian użytkownicy odświeżają swoją kopię przez `/plugin marketplace update`.

## Struktura

```
.
├── .claude-plugin/
│   └── marketplace.json          katalog: co jest w repo i gdzie
├── plugins/
│   └── czlowiek/
│       ├── .claude-plugin/
│       │   └── plugin.json       manifest pluginu
│       ├── skills/
│       │   └── czlowiek/
│       │       └── SKILL.md      instrukcje dla modelu
│       └── README.md             opis pluginu
├── LICENSE
└── README.md
```

Dwa manifesty w dwóch miejscach to nie pomyłka. `marketplace.json` w korzeniu mówi, jakie pluginy są w repo. `plugin.json` w katalogu pluginu opisuje ten jeden plugin. Przy dodawaniu kolejnego dopisujesz wpis w katalogu i zakładasz obok nowy katalog.

## Jak to zmieniać

Katalog wzorców i opis głosu siedzą w `plugins/czlowiek/skills/czlowiek/SKILL.md`. Sekcja „Głos docelowy" to miejsce do edycji, jeśli głos się przesunie. Katalog wzorców rozbudowuj przez dopisywanie punktów z konkretnym cytatem, bo abstrakcyjne zasady bez przykładu działają słabo.

Po każdej zmianie podbij `version` w `plugin.json`, bo po tym polu rozpoznawana jest dostępność aktualizacji.

## Licencja

MIT, plik [LICENSE](LICENSE).
