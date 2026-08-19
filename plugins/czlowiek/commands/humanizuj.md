---
description: Zhumanizuj wskazany tekst albo plik — usuwa wzorce typowe dla nieredagowanego wyjścia modelu i doprowadza tekst do ustalonego głosu autorki
argument-hint: [tekst do redakcji albo ścieżka do pliku]
allowed-tools: Read
disable-model-invocation: true
---

Przeczytaj `${CLAUDE_PLUGIN_ROOT}/skills/czlowiek/SKILL.md` i zastosuj opisany
tam proces (najpierw odejmowanie wzorców, potem dodawanie głosu) do materiału
wskazanego niżej.

Materiał do redakcji: $ARGUMENTS

Jak potraktować argument:

- Ścieżka do istniejącego pliku — przeczytaj go i redaguj jego treść.
- Wklejony tekst — redaguj go bezpośrednio.
- Pusty argument — weź ostatni tekst z tej rozmowy, który wygląda na materiał
  do redakcji. Jeżeli takiego nie ma, zapytaj, co redagować, i nic nie zmyślaj.

Zwróć wynik w formacie z sekcji „Format odpowiedzi" w `SKILL.md`. Nie nadpisuj
pliku źródłowego, dopóki użytkowniczka o to nie poprosi.
