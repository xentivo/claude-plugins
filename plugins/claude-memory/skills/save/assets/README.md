# Pamięć Claude

Trwała, oparta o pliki pamięć dla Claude Code — żeby nie tracić kontekstu
między sesjami i nie re-czytać w kółko tych samych plików.

## Struktura

- `README.md` — ten plik (jak działa system).
- `decisions.md` — trwały dziennik decyzji architektonicznych i ustaleń.
  Krótkie, atomowe wpisy; źródło prawdy „dlaczego tak".
- `sessions/` — logi sesji, jeden plik na sesję:
  `YYYY-MM-DD-krotki-opis.md`.
- `sessions/_TEMPLATE.md` — szablon nowego logu sesji.

## Skille

Logika pamięci żyje jako Skille Anthropic spakowane w plugin `claude-memory`
(komendy namespace'owane prefiksem `claude-memory:`):

- `/claude-memory:resume` — na początku sesji odtwarza kontekst.
- `/claude-memory:save` — na końcu sesji zapisuje log i ew. decyzję; odświeża `graph.json`.
- `/claude-memory:graph` — buduje/odpytuje strukturalną mapę repo `graph.json`.

Instalacja: `/plugin marketplace add xentivo/claude-plugins` →
`/plugin install claude-memory@claude-memory`.

Repozytorium: https://github.com/xentivo/claude-plugins

## Zasady wpisów

- Po polsku, zwięźle, perspektywa „co i dlaczego", nie „jak krok po kroku".
- W logu sesji podawaj ścieżki do plików, żeby kolejna sesja trafiała od razu
  w kod, a nie skanowała repo.
- `decisions.md`: dopisuj tylko trwałe ustalenia (architektura, konwencje,
  świadome kompromisy). Nie duplikuj tego, co już jest w `CLAUDE.md`.
- Logi sesji są append-only — nie przepisuj starych, dodawaj nowe.
