---
name: graph
description: Buduje i odpytuje strukturalną mapę repo (graph.json) samodzielnym generatorem Python stdlib wbudowanym w ten Skill, bez zewnętrznych narzędzi — węzły to pliki, krawędzie to linki/wikilinki Markdown oraz importy w kodzie. Przenośny: dystrybuowany jako plugin claude-memory, działa w dowolnym projekcie. Używaj zanim zaczniesz czytać wiele plików naraz, gdy trzeba zrozumieć strukturę kodu lub powiązania dokumentów, gdy graph.json jest nieaktualny względem ostatnich zmian, oraz gdy użytkownik prosi o „mapę kodu", „odśwież graf", „strukturę repo" lub wpisze /graph.
allowed-tools: Read, Bash(python3:*), Bash(git:*)
---

# Strukturalna mapa repo (graph.json)

Zamiast re-czytać dziesiątki plików, najpierw skonsultuj `graph.json` w
korzeniu projektu. Generator jest **wbudowany w ten Skill** — żadnych
zewnętrznych narzędzi (tylko biblioteka standardowa Pythona). Kod nigdy nie
opuszcza maszyny. Skill jest przenośny: dystrybuowany jako plugin
`claude-memory`, ta sama logika działa w każdym projekcie.

## Odświeżenie mapy

Uruchom wbudowany generator z korzenia projektu. `${CLAUDE_SKILL_DIR}`
wskazuje katalog tego Skilla niezależnie od miejsca instalacji (plugin,
projekt, globalnie) i bieżącego katalogu roboczego:

```
python3 "${CLAUDE_SKILL_DIR}/generate_graph.py"
```

Zapisuje `graph.json` w bieżącym katalogu (deterministycznie, posortowane —
czyste diffy). Odśwież zawsze, gdy:

- pliki zmieniły się od pola `generated` w `graph.json`,
- dodano/usunięto/przeniesiono pliki,
- zaczynasz nowe zadanie wymagające orientacji w strukturze.

Sprawdzenie aktualności: porównaj `graph.json` `generated` z
`git log -1 --format=%cI` — jeśli graf starszy niż ostatni commit lub są
niezacommitowane zmiany, wygeneruj ponownie.

## Odpytywanie zamiast czytania

`graph.json` ma kształt:

- `stats` — liczba węzłów/krawędzi/plików,
- `nodes[]` — `{id, type, size, symbols?}` (`symbols` = funkcje/klasy
  najwyższego poziomu w plikach `.py`),
- `edges[]` — `{from, to, kind}`, `kind` ∈ `link` | `wikilink` | `import`.

Najpierw odczytaj/przefiltruj `graph.json` (Read albo `grep`), żeby ustalić:
które pliki są kluczowe, co z czym powiązane, gdzie żyje dany symbol — i
dopiero wtedy otwieraj konkretne pliki. To tnie zużycie tokenów względem
ślepego czytania repo.

## Integracja z pamięcią

Przy `/save` (Skill `save`) odśwież `graph.json`, żeby mapa nie odstawała od
stanu repo. Opcjonalny git hook `pre-commit` może wołać generator
automatycznie — instaluj tylko na wyraźną prośbę użytkownika.
