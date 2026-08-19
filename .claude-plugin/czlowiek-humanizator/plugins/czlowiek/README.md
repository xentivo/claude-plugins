# Człowiek

Plugin do redakcji polskich tekstów. Robi dwie rzeczy naraz: usuwa z tekstu wzorce typowe dla nieredagowanego wyjścia modelu i doprowadza go do ustalonego głosu autorki.

## Zawartość

| Komponent | Ile | Do czego |
|---|---|---|
| Skille | 1 | `czlowiek` — redakcja i humanizacja polskiego tekstu |
| Agenci | 0 | niepotrzebni |
| Hooki | 0 | niepotrzebne |
| MCP | 0 | nie łączy się z niczym na zewnątrz |

## Kiedy się uruchamia

Sam, kiedy w rozmowie padnie „humanizuj", „przepisz to po ludzku", „brzmi jak AI", „sprawdź pod kątem AI", „napisz to moim głosem", „popraw styl", albo kiedy wklejasz tekst i prosisz o redakcję stylistyczną. Odpala się też przy pisaniu nowych polskich tekstów (posty, artykuły, newslettery, eseje), bo domyślny styl modelu wpada w te wzorce sam z siebie.

## Co dostajesz na wyjściu

Przepisany tekst, potem lista rzeczywistych trafień z cytatami, potem lista miejsc oznaczonych do uzupełnienia. Jeżeli tekst jest czysty, plugin to napisze zamiast dopychać listę.

## Dwie rzeczy warte zapamiętania

Plugin nie zmyśla. Zamiast wymyślonego wspomnienia, nazwiska albo daty zostawia `[DO UZUPEŁNIENIA: ...]` albo `[ŹRÓDŁO?]` z opisem, czego brakuje.

Głos docelowy nie dotyczy tekstów użytkowych. UX copy, komunikaty błędów i opisy funkcji zostają rzeczowe.

## Jak to zmieniać

Katalog wzorców i opis głosu siedzą w `skills/czlowiek/SKILL.md`. Sekcja „Głos docelowy" to miejsce do edycji, jeśli głos się przesunie. Katalog wzorców rozbudowuj przez dopisywanie punktów z konkretnym cytatem, bo abstrakcyjne zasady bez przykładu działają słabo.
