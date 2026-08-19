# Pamięć Claude

Trwała, oparta o pliki pamięć dla Claude Code — żeby nie tracić kontekstu między sesjami i nie re-czytać w kółko tych samych plików.

## Struktura

- `README.md` — ten plik (jak działa system).
- `decisions.md` — trwały dziennik decyzji architektonicznych i ustaleń. Krótkie, atomowe wpisy; źródło prawdy „dlaczego tak”.
- `sessions/` — logi sesji, jeden plik na sesję:
  `YYYY-MM-DD-krotki-opis.md`.
- `sessions/_TEMPLATE.md` — szablon nowego logu sesji.

## Skille

Logika pamięci żyje jako Skille spakowane w plugin `claude-memory`
(`plugins/claude-memory/skills/`); to repo jest też marketplace `xvo-plugins`.
Po instalacji komendy są namespace'owane prefiksem `claude-memory:`:

- `resume` (`/claude-memory:resume`) — na początku sesji: Claude czyta `decisions.md` i kilka ostatnich logów z `sessions/`, zanim cokolwiek zrobi.
- `save` (`/claude-memory:save`) — na końcu sesji: Claude zapisuje nowy log sesji (z odnośnikami do dotkniętych plików) i w razie potrzeby dopisuje wpis do `decisions.md`. Przyjmuje opcjonalny argument: krótki slug opisu sesji. Odświeża też `graph.json`.
- `graph` (`/claude-memory:graph`) — buduje/odpytuje strukturalną mapę repo `graph.json` (korzeń) generowaną lokalnie przez generator wbudowany w skill (`generate_graph.py` obok `SKILL.md`), bez zewnętrznych narzędzi. Odpytuj ją zamiast skanować repo.

Instalacja w innym projekcie: `/plugin marketplace add xentivo/claude-plugins` → `/plugin install claude-memory@xvo-plugins`.

Marketplace nazywał się wcześniej `claude-memory`; jeżeli masz go dodanego pod
starą nazwą, usuń go (`/plugin marketplace remove claude-memory`) i dodaj ponownie.

Repozytorium: https://github.com/xentivo/claude-plugins — obok pamięci mieszka
tam drugi plugin, `czlowiek` (redakcja polskich tekstów).

## Zasady wpisów

- Po polsku, zwięźle, perspektywa „co i dlaczego”, nie „jak krok po kroku”.
- W logu sesji podawaj ścieżki do plików, żeby kolejna sesja trafiała od razu w kod, a nie skanowała repo.
- `decisions.md`: dopisuj tylko trwałe ustalenia (architektura, konwencje, świadome kompromisy). Nie duplikuj tego, co już jest w `CLAUDE.md`.
- Logi sesji są append-only — nie przepisuj starych, dodawaj nowe.
