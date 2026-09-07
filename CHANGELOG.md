# Changelog

Wpisy dopisuje **krok wydania** po merge'u do gałęzi domyślnej
(`scripts/release.sh`, workflow „Wydanie (wersje pluginów + changelog)"). Tego
pliku **nie edytuj z ręki**: przy następnym wydaniu i tak liczy się to, co weszło
do pnia, a ręczna poprawka konfliktuje z każdym równolegle otwartym PR-em. Treść
wpisu bierze się z tytułu pull requesta i jego autora, więc dobry opis zmiany
pisze się w tytule PR-a, nie tutaj.

Format wpisu: `zmiana - kto przygotował`. **Każdy plugin ma własny numer**, bo po
polu `version` w jego manifeście klient rozpoznaje dostępność aktualizacji —
podbicie wszystkich naraz zapowiadałoby aktualizację pluginów, w których nic się
nie zmieniło. Stąd nagłówki `<plugin> <wersja>` i tagi `<plugin>-<wersja>`.
Numerację rozstrzyga zasada `versioning` organizacji.

<!-- Nowe wpisy wchodzą pod tę linijkę; najnowsze na górze. -->

## Punkt odniesienia

Numery, na których pluginy stały, gdy wydania przestały być ręczne:
`claude-memory 1.0.2`, `czlowiek 1.1.0`, `pipeline 1.1.0`. Wcześniejszych zmian
nie odtwarzamy wstecz — historia jest w gicie i w pull requestach.
