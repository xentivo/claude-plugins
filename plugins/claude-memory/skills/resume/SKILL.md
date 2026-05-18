---
name: resume
description: Odtwarza kontekst projektu z plikowej pamięci Claude (docs/claude-memory/) — czyta dziennik decyzji i kilka ostatnich logów sesji, po czym streszcza stan prac. Dystrybuowany jako plugin claude-memory; jeśli pamięć jeszcze nie istnieje, mówi o tym zamiast błędu. Używaj na początku każdej sesji, zanim zaczniesz cokolwiek robić, oraz gdy użytkownik prosi o „wczytaj pamięć", „odtwórz kontekst", „przypomnij gdzie skończyliśmy" lub wpisze /resume.
allowed-tools: Read, Bash(ls:*), Bash(git log:*), Bash(test:*)
---

# Odtworzenie pamięci projektu

Zanim zrobisz cokolwiek innego, odtwórz kontekst z plikowej pamięci projektu
(`docs/claude-memory/`):

0. Jeśli katalog `docs/claude-memory/` nie istnieje, pamięć nie jest jeszcze
   zainicjalizowana w tym projekcie. Nie traktuj tego jak błąd — sprawdź
   tylko `git log --oneline -10`, krótko streść stan repo i powiedz
   użytkownikowi, że pamięć powstanie przy pierwszym `/save`. Zakończ.
1. Przeczytaj `docs/claude-memory/decisions.md` w całości.
2. Wylistuj `docs/claude-memory/sessions/` i przeczytaj 3 najnowsze logi sesji
   (po dacie w nazwie pliku; pomiń `_TEMPLATE.md`).
3. Sprawdź ostatnie commity: `git log --oneline -10`.

Następnie w 5–8 zdaniach streść użytkownikowi:

- nad czym pracowano ostatnio i co zostało niedokończone (sekcje TODO),
- jakie trwałe decyzje obowiązują,
- które pliki/ścieżki są kluczowe dla bieżącego wątku.

Nie czytaj kodu źródłowego „na zapas" — wejdź w pliki dopiero, gdy zacznie się
konkretne zadanie. Jeśli istnieje `graph.json`, odpytaj go zamiast skanować
repo (Skill `graph`). Po streszczeniu zapytaj, nad czym dziś pracujemy.
