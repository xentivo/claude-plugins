# 2026-09-07 — Token wydania z Xvo Bot App zamiast PAT-a

- **Gałąź:** `claude/gallant-fermi-kg83eq` (odbita od `main` po merge'u PR #7)
- **Cel:** krok wydania wymagał sekretu `RELEASE_TOKEN` per repo. Zastąpić to
  tokenem instalacji GitHub Appa organizacji.

## Co zrobiono

- `scripts/github-app-token.sh` — JWT RS256 z klucza Appa, ID instalacji z
  `GET /repos/{owner}/{repo}/installation`, token zawężony do tego repo oraz
  `contents: write` + `pull_requests: read`. `--jwt-only` do diagnozy.
- `.github/workflows/release.yml` — sprawdzenie sekretów organizacji przed
  checkoutem, potem checkout, potem mintowanie tokena do `RELEASE_TOKEN`
  w `GITHUB_ENV`. `scripts/release.sh` bez zmian.
- `plugins/pipeline/skills/sekrety/SKILL.md` — nowy punkt w „Cichych pułapkach":
  cztery rzeczy, które przy Appie wyglądają jak zły klucz, a nim nie są (brak
  bypassu, dwuznaczny 404, `.pem` z pogubionym łamaniem wiersza, żądanie węższych
  uprawnień niż ma instalacja) plus dwa szczegóły JWT.
- `CLAUDE.md`, `README.md` — sekrety organizacji zamiast `RELEASE_TOKEN`.

## Kluczowe pliki

- `scripts/github-app-token.sh` — bliźniak tego samego pliku żyje w
  `xentivo/mcp-org-rules`. Zmieniasz jeden, przejrzyj drugi.
- `plugins/pipeline/skills/sekrety/SKILL.md` — pułapki Appa; uzasadnienia po
  stronie zasady `ci-pipeline` (sekcja „Uprawnienia i sekrety").

## Decyzje / ustalenia

- Mintowanie własnymi linijkami, nie `actions/create-github-app-token` — klucz
  Appa jest poświadczeniem na całą organizację i nie idzie do obcej akcji.
  Pełne uzasadnienie w `decisions.md` repo `xentivo/mcp-org-rules`, wpis
  z tej samej daty.
- Weryfikacja: JWT sprawdzony lokalnie na jednorazowym kluczu RSA (podpis
  zweryfikowany kluczem publicznym), cztery ścieżki błędu przetestowane. Wywołań
  API nie da się sprawdzić z sesji — nie ma klucza Appa.
- Testy skryptu wydania puszczone ponownie, bez regresji.

## TODO / następny krok

- Poza repo, przez człowieka: sekrety organizacji `XVO_BOT_APP_ID`
  i `XVO_BOT_PRIVATE_KEY`, instalacja Appa na repo i **bypass Appa w regule
  chroniącej `main`**.
- Pierwszy udany bieg założy tylko tagi punktów odniesienia
  (`claude-memory-1.0.2`, `czlowiek-1.1.0`, `pipeline-1.1.0`) i nie podbije
  niczego.
