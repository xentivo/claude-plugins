# 2026-09-07 — Krok wydania: implementacja w marketplace

- **Gałąź:** `claude/gallant-fermi-kg83eq` (odbita od `main` po merge'u PR #6)
- **Cel:** zamienić ręczne podbijanie `version` w manifestach na krok wydania,
  który po merge'u do `main` podbija tylko dotknięte pluginy i dopisuje wpisy do
  changeloga.

## Co zrobiono

- `scripts/release.sh` — logika wydania per plugin: zakres od taga
  `<plugin>-<wersja>`, klasyfikacja ścieżek, poziom podbicia z etykiety PR-a,
  `jq` na manifeście, wpis do `CHANGELOG.md`, przepisanie tabeli wersji w README,
  commit z markerem `[wydanie]`, tag per plugin, push tokenem automatu.
  `--dry-run` pokazuje wynik bez ruszania gita.
- `.github/workflows/release.yml` — pierwszy workflow w tym repo. `push` na `main`
  z `paths-ignore` na plikach, które sam zmienia, plus warunek na markerze
  w commicie; `persist-credentials: false`, żeby obca akcja nie dostała PAT-a.
- `CHANGELOG.md` — nowy, z punktem odniesienia (`claude-memory 1.0.2`,
  `czlowiek 1.1.0`, `pipeline 1.1.0`).
- `CLAUDE.md`, `README.md` — zdanie „po każdej zmianie pluginu podbij jego
  `version`" wypada; w zamian sekcja „Wydanie" i adnotacja, że kolumna „Wersja"
  w README jest przepisywana przez skrypt.
- `plugins/pipeline/skills/deploy/SKILL.md` — nazwa etykiety (`breaking`) i przypadek
  repo z kilkoma niezależnymi artefaktami.

## Kluczowe pliki

- `scripts/release.sh` — cała logika. Zmieniasz układ katalogów pluginów albo
  format tabeli w README? Ten plik trzeba przejrzeć, bo pada celowo, gdy nie
  znajdzie wiersza tabeli.
- `.github/workflows/release.yml` — dwa zabezpieczenia przed pętlą naraz.

## Decyzje / ustalenia

- Wersja per plugin i tagi `<plugin>-<wersja>` — wyjątek od „jednego numeru na
  repo", dopisany do zasady `versioning` w `mcp-org-rules`. Przeniesione do
  `decisions.md`.
- Wewnątrz katalogu pluginu artefaktem jest wszystko poza jego `README.md`:
  markdown jest tu produktem, nie dokumentacją. Odwrotnie niż w repo z kodem.
- Testy skryptu (pięć scenariuszy: seed, jeden plugin, samo README pluginu, sam
  korzeń repo, dwa pluginy naraz) puszczone na klonie z lokalnym remote. Zapis
  scenariuszy nie wchodzi do repo — to był test jednorazowy, nie bramka.

## TODO / następny krok

- **Sekret `RELEASE_TOKEN` z bypassem w ochronie gałęzi** — bez tego pierwszy bieg
  padnie na kroku sprawdzającym konfigurację. To jedyna rzecz do zrobienia ręcznie.
- Pierwszy bieg po merge'u **tylko zakłada tagi** (`claude-memory-1.0.2`,
  `czlowiek-1.1.0`, `pipeline-1.1.0`) i nie podbija niczego. Pierwsze prawdziwe
  wydanie wyjdzie z następnego merge'a dotykającego pluginu.
- Wersji `pipeline` w tym PR-ze **nie podbijam z ręki**, mimo że PR rusza
  `deploy/SKILL.md` — to byłoby dokładnie to, co ta zmiana likwiduje.
