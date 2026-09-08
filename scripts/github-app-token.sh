#!/usr/bin/env bash
# Wymienia poświadczenia GitHub Appa (Xvo Bot App) na krótkożyciowy token
# instalacji i wypisuje go na stdout. Token żyje godzinę.
#
#   APP_ID=... APP_PRIVATE_KEY="$(cat klucz.pem)" ./scripts/github-app-token.sh
#   ./scripts/github-app-token.sh --jwt-only    # sam JWT, do diagnozy
#
# DLACZEGO WŁASNE LINIJKI, A NIE `actions/create-github-app-token`: ta akcja
# dostaje do ręki KLUCZ PRYWATNY Appa, czyli poświadczenie mocniejsze niż PAT do
# jednego repo - kto je wyciągnie, ma uprawnienia Appa w całej organizacji.
# Zasada `ci-pipeline` mówi wprost: akcję, którą da się zastąpić kilkoma
# linijkami preinstalowanego CLI, zastępuje się, i to tym bardziej, gdy akcja
# dostaje klucz (precedens: `azure/login` ustąpił ośmiu linijkom `az login`).
# Tu wychodzi kilkanaście linijek `openssl` i `curl`.
#
# DLACZEGO TOKEN JEST ZAWĘŻANY: żądamy wprost `repositories` i `permissions`,
# więc nawet gdy App widzi całą organizację, ten jeden token umie tylko to, czego
# potrzebuje krok wydania w tym repo. Bez tych pól token nosi pełny zakres
# instalacji - i to on, nie App, jest tym, co realnie leży na runnerze.
#
# DLACZEGO ID INSTALACJI NIE JEST SEKRETEM: bierzemy je z
# GET /repos/{owner}/{repo}/installation, więc ten sam workflow i ten sam skrypt
# działają w każdym repo organizacji bez konfiguracji per repo. O to właśnie
# chodzi w „globalnym" użyczaniu permisji: sekrety stoją raz, na organizacji.
set -euo pipefail

die() { echo "::error::$*" >&2; exit 1; }

JWT_ONLY=0
case "${1:-}" in
  --jwt-only) JWT_ONLY=1 ;;
  "") ;;
  -h|--help) sed -n '2,10p' "${BASH_SOURCE[0]}"; exit 0 ;;
  *) die "Nieznany argument: $1" ;;
esac

[ -n "${APP_ID:-}" ] || die "Brak APP_ID (w CI: sekret organizacji XVO_BOT_APP_ID)."
[ -n "${APP_PRIVATE_KEY:-}" ] || die "Brak APP_PRIVATE_KEY (w CI: sekret organizacji XVO_BOT_PRIVATE_KEY)."
for cmd in openssl curl jq; do
  command -v "$cmd" >/dev/null 2>&1 || die "Brak ${cmd} - potrzebny do zbudowania JWT i wywołania API."
done

# Klucz zapisujemy z umask 077, nigdy nie wypisujemy i nie podajemy w argumentach
# procesu (byłyby widoczne w `ps` dla innych jobów na tej samej maszynie).
umask 077
keyfile="$(mktemp)"
trap 'rm -f "$keyfile"' EXIT
printf '%s\n' "$APP_PRIVATE_KEY" > "$keyfile"
openssl rsa -check -noout -in "$keyfile" >/dev/null 2>&1 \
  || die "APP_PRIVATE_KEY nie jest poprawnym kluczem RSA. Wklej całą treść pliku .pem z GitHuba, razem z linijkami BEGIN/END; sekret z obciętym łamaniem wiersza wygląda tak samo, a nie działa."

b64url() { openssl base64 -A | tr '+/' '-_' | tr -d '='; }

now="$(date +%s)"
# `iat` cofnięte o minutę, bo zegar runnera bywa przed zegarem GitHuba, a JWT
# „z przyszłości" jest odrzucany. `exp` na 9 minut - GitHub nie przyjmuje więcej
# niż 10, a token instalacji i tak żyje godzinę niezależnie od życia JWT.
header="$(printf '%s' '{"alg":"RS256","typ":"JWT"}' | b64url)"
payload="$(jq -cn --argjson iat "$((now - 60))" --argjson exp "$((now + 540))" --arg iss "$APP_ID" \
  '{iat: $iat, exp: $exp, iss: $iss}' | b64url)"
signature="$(printf '%s' "${header}.${payload}" | openssl dgst -sha256 -sign "$keyfile" -binary | b64url)"
jwt="${header}.${payload}.${signature}"

if [ "$JWT_ONLY" = "1" ]; then
  printf '%s\n' "$jwt"
  exit 0
fi

repo="${GITHUB_REPOSITORY:-}"
if [ -z "$repo" ]; then
  repo="$(git config --get remote.origin.url | sed -E 's#^.*github\.com[:/]##; s#\.git$##')"
fi
[ -n "$repo" ] || die "Nie umiem ustalić repozytorium (brak GITHUB_REPOSITORY i remote.origin.url)."

api() { curl -fsS -H "Authorization: Bearer ${jwt}" -H "Accept: application/vnd.github+json" "$@"; }

installation="$(api "https://api.github.com/repos/${repo}/installation" 2>/dev/null)" \
  || die "API nie zwróciło instalacji dla ${repo}. Dwie zwykłe przyczyny: App nie jest zainstalowany na tym repo (Organization settings > GitHub Apps > Configure > Repository access), albo APP_ID nie należy do tego Appa. 404 wygląda tu identycznie w obu przypadkach."
installation_id="$(printf '%s' "$installation" | jq -r '.id // empty')"
[ -n "$installation_id" ] || die "Odpowiedź API nie zawiera id instalacji."

# Token zawężony do tego repo i do dwóch uprawnień, których potrzebuje wydanie:
# zapis treści (commit i tag) oraz odczyt PR-ów (tytuł, autor, etykiety).
body="$(jq -cn --arg name "${repo#*/}" \
  '{repositories: [$name], permissions: {contents: "write", pull_requests: "read"}}')"
token="$(api -X POST -d "$body" \
  "https://api.github.com/app/installations/${installation_id}/access_tokens" 2>/dev/null | jq -r '.token // empty')" \
  || die "Mintowanie tokena instalacji padło."
[ -n "$token" ] || die "API nie zwróciło tokena. Sprawdź, czy App ma uprawnienia Contents: Read and write oraz Pull requests: Read - żądanie węższego zakresu niż ma instalacja kończy się błędem, nie zawężeniem."

printf '%s\n' "$token"
