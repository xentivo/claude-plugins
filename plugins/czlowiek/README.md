# Człowiek

Plugin do redakcji polskich tekstów. Robi dwie rzeczy naraz: usuwa z tekstu wzorce typowe dla nieredagowanego wyjścia modelu i doprowadza go do ustalonego głosu autorki.

## Zawartość

| Komponent | Ile | Do czego |
|---|---|---|
| Skille | 1 | `czlowiek` — redakcja i humanizacja polskiego tekstu |
| Komendy | 1 | `/czlowiek:humanizuj` — ręczne wyzwolenie na wskazanym tekście lub pliku |
| Agenci | 0 | niepotrzebni |
| Hooki | 0 | niepotrzebne |
| MCP | 0 | nie łączy się z niczym na zewnątrz |

## Jak go wyzwolić

Ręcznie:

```
/czlowiek:humanizuj <tekst albo ścieżka do pliku>
```

Bez argumentu komenda bierze ostatni tekst z rozmowy. Komenda sama się nie
odpala (`disable-model-invocation: true`), żeby nie dublować automatycznego
wyzwalania skilla — ten odpala się sam, patrz niżej.

## Kiedy się uruchamia sam

Sam, kiedy w rozmowie padnie „humanizuj", „przepisz to po ludzku", „brzmi jak AI", „sprawdź pod kątem AI", „napisz to moim głosem", „popraw styl", albo kiedy wklejasz tekst i prosisz o redakcję stylistyczną. Odpala się też przy pisaniu nowych polskich tekstów (posty, artykuły, newslettery, eseje), bo domyślny styl modelu wpada w te wzorce sam z siebie.

## Co dostajesz na wyjściu

Przepisany tekst, potem lista rzeczywistych trafień z cytatami, potem lista miejsc oznaczonych do uzupełnienia. Jeżeli tekst jest czysty, plugin to napisze zamiast dopychać listę.

## Dwie rzeczy warte zapamiętania

Plugin nie zmyśla. Zamiast wymyślonego wspomnienia, nazwiska albo daty zostawia `[DO UZUPEŁNIENIA: ...]` albo `[ŹRÓDŁO?]` z opisem, czego brakuje.

Głos docelowy nie dotyczy tekstów użytkowych. UX copy, komunikaty błędów i opisy funkcji zostają rzeczowe.

## Jak to zmieniać

Katalog wzorców i opis głosu siedzą w `skills/czlowiek/SKILL.md`; komenda w `commands/humanizuj.md` tylko go woła, więc zmiany zachowania robisz w skillu. Sekcja „Głos docelowy" to miejsce do edycji, jeśli głos się przesunie. Katalog wzorców rozbudowuj przez dopisywanie punktów z konkretnym cytatem, bo abstrakcyjne zasady bez przykładu działają słabo.

## Instalacja

```
/plugin marketplace add xentivo/claude-plugins
/plugin install czlowiek@xvo-plugins
```

Aktualizacja po zmianach w tym repo: `/plugin marketplace update`. Po każdej
zmianie skilla podbij `version` w `.claude-plugin/plugin.json` — po tym polu
rozpoznawana jest dostępność aktualizacji.

## Licencja

MIT, plik [LICENSE](LICENSE) — © 2026 Izabella Pyrkosz.
