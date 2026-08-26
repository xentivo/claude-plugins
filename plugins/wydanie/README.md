# Wydanie

Plugin do [Claude Code](https://code.claude.com/): tworzenie wydań zgodnie z zasadą
`versioning` organizacji Xentivo. Release z pnia, tag równy wersji z pliku
wersjonującego repo.

## Zawartość

| Komponent | Ile | Do czego |
|---|---|---|
| Skille | 2 | `wersja` - gdzie w repo żyje numer; `wydanie` - procedura wydania i wycofania |
| Komendy | 1 | `xvo-wydaj` - wydaj wersję z pnia albo tylko sprawdź, czy można |
| Agenci | 0 | niepotrzebni |
| Hooki | 0 | niepotrzebne |
| MCP | 0 | nie wystawia serwera, ale skille i komenda **czytają** zasadę z serwera Xentivo MCP |

## Po co

Wydanie wygląda na jedno kliknięcie, a jest miejscem, w którym zbiegają się cztery
rzeczy: numer wersji, stan pnia, migracje bazy i wyzwalacz deployu. Pomyłka na każdej
z nich kosztuje produkcję, a nie czerwony check.

Trzy pułapki, po których ten plugin powstał:

- **Publikacja release'a jest deployem**, jeśli workflow startuje z
  `release: published`. Kto tego nie wie, klika „Publish", żeby „zapisać wydanie".
- **Tag, który już istnieje**, znaczy pominięte podbicie wersji w którymś PR-ze.
  Odruch „przestawię taga" zabiera odpowiedź na pytanie, co stało na produkcji.
- **Wersja czytana z lokalnego drzewa** zamiast z pnia. Wdroży się to, co w tagu, nie
  to, co widzisz u siebie.

## Instalacja

```
/plugin marketplace add xentivo/claude-plugins
/plugin install wydanie@xvo-plugins
```

## Użycie

| Wywołanie | Co robi |
|---|---|
| `/wydanie:xvo-wydaj` | Sprawdza stan, tworzy release jako draft, pokazuje notatki. Nie publikuje, jeśli publikacja odpala deploy |
| `/wydanie:xvo-wydaj sprawdź` | Tylko kontrola: wersja, tag, co weszło od poprzedniego wydania, CI, migracje |
| `/wydanie:xvo-wydaj rc` | To samo, ale jako pre-release |

Skille `wersja` i `wydanie` odpalają się też same, gdy rozmowa dotyczy numeru wersji
albo wydawania.

## Czego plugin nie robi

**Nie podbija wersji.** Podbicie idzie w PR-ze ze zmianą, która na nie zasługuje -
osobny commit „a teraz wersja" nie mówi, czego dotyczy. Skill `wersja` powie, w którym
pliku i jaką komendą, ale sam bump zostaje przy zmianie.

**Nie publikuje za Ciebie**, gdy publikacja jest wyzwalaczem deployu na produkcję.
Tworzy draft, wypisuje, czego brakuje, i czeka na wyraźne „publikuj".

**Nie robi migracji bazy.** Sprawdza tylko, czy któraś czeka niewdrożona, bo to
najczęstszy powód, dla którego wydanie nie powinno jeszcze pójść.

## Podział obowiązków

**Treść normatywna żyje w `content/versioning.md` w `xentivo/mcp-org-rules`** i idzie
przez MCP do wszystkich repozytoriów. Ten plugin trzyma samą procedurę i dociąga
resztę przez `get_rule`. Kopiowanie reguł do `SKILL.md` dałoby drugą wersję prawdy,
która rozjedzie się przy pierwszej poprawce zasady.

Wniosek praktyczny: **plugin bez dostępu do serwera Xentivo MCP jest połowiczny.**
Procedura poprowadzi przez kroki, uzasadnienia zostaną poza zasięgiem.

## Wymagania

- `gh` CLI uwierzytelnione w repozytorium, z prawem tworzenia release'ów.
- `jq` do odczytu wersji z `package.json` (albo odpowiednik dla innego ekosystemu).
- Dostęp do serwera Xentivo MCP, żeby `get_rule("versioning")` odpowiedziało.

## Zmiany w pluginie

Po każdej zmianie podbij `version` w `.claude-plugin/plugin.json` - po tym polu
Claude Code rozpoznaje dostępność aktualizacji. Zmieniasz treść zasady `versioning`
w `mcp-org-rules` - sprawdź, czy procedura tutaj nadal się z nią zgadza.
