# 2026-09-07 — Krok wydania w skillu `deploy` (wersja + changelog)

- **Gałąź:** `claude/gallant-fermi-kg83eq`
- **Cel:** dołożyć do pluginu `pipeline` procedurę kroku wydania, który po merge'u do
  gałęzi domyślnej podbija wersję i dopisuje wpis do changeloga, i wyjąć ze skilla
  informację, że pipeline wersji nie podbija.

## Co zrobiono

- `plugins/pipeline/skills/deploy/SKILL.md` — nowa sekcja „Wydanie po merge'u: wersja
  i changelog": trzy rzeczy do ustalenia w repo (gdzie stoi numer, czy jest tag
  poprzedniego wydania, co już czyta numer) plus kształt kroku. Z listy „Czego nie
  wpisujesz do pipeline'u" wypadło „podbicia wersji". `description` we frontmatterze
  wymienia teraz wydanie, żeby skill wciągał się przy tej robocie.
- `plugins/pipeline/commands/xvo-zbuduj-pipeline.md` — rozpoznanie repo pyta o miejsce
  numeru wersji, `CHANGELOG.md` i tag poprzedniego wydania; „całość" obejmuje wydanie;
  lista rzeczy poza repo dostała bypass automatu w ochronie gałęzi.
- `plugins/pipeline/.claude-plugin/plugin.json` — `1.0.0` → `1.1.0`; tabele wersji
  w `README.md` i w `plugins/pipeline/README.md` zaktualizowane.
- Treść normatywna poszła osobnym PR-em do `xentivo/mcp-org-rules`
  (`content/ci-pipeline.md`, sekcja „Wydanie po merge'u").

## Kluczowe pliki

- `plugins/pipeline/skills/deploy/SKILL.md` — procedura wydania. Zmieniasz zasadę
  `ci-pipeline` po tamtej stronie? Sprawdź, czy ta sekcja nadal się z nią zgadza.
- `plugins/pipeline/commands/xvo-zbuduj-pipeline.md` — punkt 3 trzyma listę pułapek
  sprawdzanych po napisaniu plików.

## Decyzje / ustalenia

- Wydanie idzie do istniejącego skilla `deploy`, nie do czwartego skilla — przeniesione
  do `decisions.md`.
- Skill nie kopiuje reguł, tylko procedurę i odesłanie do `get_rule("ci-pipeline")`.
  Trzy pułapki wypisane wprost, bo każda daje cichą awarię: autor PR-a a nie autor
  commita mergującego, `paths-ignore` razem z warunkiem na commicie (`npm version`
  rusza też lockfile), build czytający numer po podbiciu.

## TODO / następny krok

- **To repo nie ma pipeline'u**, więc `version` w `plugin.json` nadal podbija się
  ręcznie — po tym polu marketplace rozpoznaje aktualizację. Zasada o kroku wydania
  tego nie obejmuje; gdyby miała, `claude-plugins` potrzebuje najpierw własnego
  workflow.
- Po zmergowaniu obu PR-ów: `/plugin marketplace update`, żeby 1.1.0 doszło do
  zainstalowanych kopii.
