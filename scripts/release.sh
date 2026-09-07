#!/usr/bin/env bash
# Krok wydania dla marketplace'u: podbija `version` w manifeście każdego pluginu,
# którego dotknęły zmiany od jego ostatniego taga, i dopisuje wpisy do CHANGELOG.md.
#
# Wołany przez .github/workflows/release.yml po merge'u do gałęzi domyślnej, ale
# działa też z ręki - i tak trzeba go umieć uruchomić, gdy bieg padnie:
#
#   ./scripts/release.sh --dry-run     # policz i wypisz, niczego nie zmieniaj
#   ./scripts/release.sh               # commit + tagi + push
#
# DLACZEGO WERSJA PER PLUGIN, A NIE JEDNA NA REPO: `version` w
# plugins/<nazwa>/.claude-plugin/plugin.json jest tym polem, po którym klient
# rozpoznaje dostępność aktualizacji. Podbijanie wszystkich naraz zapowiadałoby
# aktualizację pluginów, w których nic się nie zmieniło. Stąd też tagi
# `<plugin>-<wersja>`, a nie goła wersja: „wersja repo" tutaj nie istnieje.
# Wyjątek jest opisany w zasadzie `versioning`, sekcja „Wydanie".
#
# DLACZEGO AUTOR PR-A, A NIE AUTOR COMMITA: autorem merge commita jest ten, kto
# kliknął merge, a przy automerge - token automatu. Wzięcie autora commita dałoby
# changelog, w którym wszystko przygotował bot.
#
# DLACZEGO README JEST GENEROWANE: tabela wersji w README.md to druga kopia numeru
# z manifestu. Skrypt ją przepisuje i pada, jeśli nie znajdzie wiersza - dzięki temu
# rozjazd jest czerwony, a nie cichy.
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

CHANGELOG="CHANGELOG.md"
CHANGELOG_MARKER="<!-- Nowe wpisy wchodzą pod tę linijkę; najnowsze na górze. -->"
COMMIT_MARKER="[wydanie]"
RELEASE_AUTHOR_NAME="${RELEASE_AUTHOR_NAME:-xvo-release}"
RELEASE_AUTHOR_EMAIL="${RELEASE_AUTHOR_EMAIL:-noreply@xentivo.pl}"

# Wewnątrz katalogu pluginu artefaktem jest wszystko poza jego README: SKILL.md,
# komendy, manifest i zasoby jadą do użytkownika. To odwrotnie niż w repo z kodem,
# gdzie markdown zwykle jest dokumentacją - tu markdown JEST produktem.
plugin_non_artifact() {
  case "$1" in
    */README.md) return 0 ;;
  esac
  return 1
}

DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    -h|--help) sed -n '2,24p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *) echo "Nieznany argument: $arg" >&2; exit 2 ;;
  esac
done

log()  { echo "$*"; }
warn() { echo "::warning::$*" >&2; }
die()  { echo "::error::$*" >&2; exit 1; }
summary() {
  echo "$*"
  if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then echo "$*" >> "$GITHUB_STEP_SUMMARY"; fi
}

if [ -n "${GITHUB_ACTIONS:-}" ] && [ -n "${RELEASE_TOKEN:-}" ]; then
  echo "::add-mask::${RELEASE_TOKEN}"
fi

repo_slug() {
  if [ -n "${GITHUB_REPOSITORY:-}" ]; then echo "$GITHUB_REPOSITORY"; return; fi
  git config --get remote.origin.url | sed -E 's#^.*github\.com[:/]##; s#\.git$##'
}
REPO="$(repo_slug)"
[ -n "$REPO" ] || die "Nie umiem ustalić repozytorium (brak GITHUB_REPOSITORY i remote.origin.url)."

# Push tokenem automatu podanym wprost, żeby obca akcja checkout nigdy go nie
# dostała do ręki (leci z persist-credentials: false) i żeby nie został
# w .git/config. Bez sekretu wołamy origin - tak działa uruchomienie z laptopa.
push_ref() {
  local remote="origin"
  if [ -n "${RELEASE_TOKEN:-}" ]; then
    remote="https://x-access-token:${RELEASE_TOKEN}@github.com/${REPO}.git"
  fi
  git push "$remote" "$@" \
    || die "Push do ${REPO} odbity. Przy chronionej gałęzi token automatu musi mieć bypass w ochronie gałęzi (Settings > Rules); bez tego wydanie nie zachodzi."
}

pr_json() {
  local number="$1"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    gh api "repos/${REPO}/pulls/${number}" 2>/dev/null && return 0
  fi
  local token="${RELEASE_TOKEN:-${GH_TOKEN:-${GITHUB_TOKEN:-}}}"
  [ -n "$token" ] || return 1
  curl -fsS -H "Authorization: Bearer ${token}" -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/${REPO}/pulls/${number}" 2>/dev/null
}

next_version() {
  local current="$1" level="$2"
  IFS=. read -r major minor patch <<< "$current"
  if [ "$level" = "minor" ]; then
    echo "${major}.$((minor + 1)).0"
  else
    echo "${major}.${minor}.$((patch + 1))"
  fi
}

# --- Przejście po pluginach --------------------------------------------------
released=()          # "<plugin> <nowa_wersja>"
entry_file="$(mktemp)"
seed_tags=()
trap 'rm -f "$entry_file"' EXIT

for manifest in plugins/*/.claude-plugin/plugin.json; do
  [ -f "$manifest" ] || continue
  dir="$(dirname "$(dirname "$manifest")")"          # plugins/<nazwa>
  name="$(jq -r '.name' "$manifest")"
  current="$(jq -r '.version' "$manifest")"
  [ -n "$name" ] && [ "$name" != "null" ] || die "Manifest ${manifest} bez pola name."

  last_tag="$(git tag --list "${name}-*" --sort=-v:refname \
    | grep -E "^${name}-[0-9]+\.[0-9]+\.[0-9]+$" | head -n1 || true)"

  if [ -z "$last_tag" ]; then
    # Pierwsze uruchomienie dla tego pluginu: zakładamy punkt odniesienia na
    # obecnej wersji i nie podbijamy. Wsypanie całej historii do jednego wpisu
    # nie powiedziałoby nikomu niczego.
    seed_tags+=("${name}-${current}")
    log "${name}: brak taga, punkt odniesienia ${current}"
    continue
  fi

  range="${last_tag}..HEAD"
  mapfile -t changed < <(git diff --no-renames --name-only "$range" -- "$dir")
  if [ "${#changed[@]}" -eq 0 ]; then
    log "${name}: od ${last_tag} nic w ${dir}/ - bez podbicia"
    continue
  fi

  artifact_touched=0
  for path in "${changed[@]}"; do
    if ! plugin_non_artifact "$path"; then
      artifact_touched=1
      break
    fi
  done
  if [ "$artifact_touched" -eq 0 ]; then
    log "${name}: zmiany od ${last_tag} to tylko README pluginu - bez podbicia"
    continue
  fi

  # Co weszło i kto to przygotował - w zakresie tego pluginu.
  # `tformat:`, nie `format:`: przy `format:` ostatni rekord wychodzi bez znaku
  # nowej linii, `read` zwraca kod niezerowy i pętla gubi ostatni commit.
  entries=()
  level="patch"
  api_missing=0
  while IFS=$'\t' read -r sha subject; do
    [ -n "$sha" ] || continue
    number="$(printf '%s' "$subject" | sed -nE 's/^Merge pull request #([0-9]+) from .*/\1/p')"
    if [ -z "$number" ]; then
      entries+=("$(git show -s --format='%s' "$sha") - $(git show -s --format='%an' "$sha")")
      warn "${name}: commit ${sha:0:8} nie pochodzi z pull requesta - autorstwo z gita."
      continue
    fi
    json="$(pr_json "$number" || true)"
    if [ -z "$json" ]; then
      if [ "$DRY_RUN" = "1" ]; then
        warn "PR #${number}: brak dostępu do API, autorstwo w suchym biegu z gita."
        entries+=("$(git show -s --format='%s' "$sha") (#${number}) - $(git show -s --format='%an' "$sha") [autorstwo z gita]")
      else
        api_missing=1
      fi
      continue
    fi
    title="$(printf '%s' "$json" | jq -r '.title')"
    author="$(printf '%s' "$json" | jq -r '.user.login')"
    labels="$(printf '%s' "$json" | jq -r '[.labels[].name] | join(" ")')"
    case " $labels " in
      *" breaking "*|*" minor "*) level="minor" ;;
    esac
    entries+=("${title} (#${number}) - ${author}")
  done < <(git log --first-parent --reverse --pretty=tformat:'%H%x09%s' "$range" -- "$dir")

  if [ "$api_missing" = "1" ]; then
    die "Nie udało się odczytać danych pull requestów z API. Autorstwo wpisu musi pochodzić z PR-a, nie z commita mergującego, więc krok pada zamiast wpisać nieprawdę. W biegu CI ustaw sekret RELEASE_TOKEN; z laptopa uruchom \`gh auth login\`."
  fi
  if [ "${#entries[@]}" -eq 0 ]; then
    log "${name}: zmiany w ${dir}/ są, ale bez commita pierwszego rzędu - pomijam"
    continue
  fi

  new_version="$(next_version "$current" "$level")"
  log "${name}: ${current} -> ${new_version} (${level}), ${#entries[@]} zmian"
  released+=("${name} ${new_version}")

  {
    echo
    echo "## ${name} ${new_version} — $(date -u +%Y-%m-%d)"
    echo
    for entry in "${entries[@]}"; do echo "- ${entry}"; done
  } >> "$entry_file"

  if [ "$DRY_RUN" = "0" ]; then
    tmp="$(mktemp)"
    jq --arg v "$new_version" '.version = $v' "$manifest" > "$tmp"
    mv "$tmp" "$manifest"
    # Tabela wersji w README to druga kopia numeru. Przepisujemy ją i sprawdzamy,
    # że wiersz faktycznie się zmienił: cichy rozjazd znaczy README kłamiące
    # o tym, co jest w marketplace.
    if grep -qE "^\| \*\*${name}\*\* \| [0-9]+\.[0-9]+\.[0-9]+ \|" README.md; then
      sed -i -E "s#^\| \*\*${name}\*\* \| [0-9]+\.[0-9]+\.[0-9]+ \|#| **${name}** | ${new_version} |#" README.md
      grep -qF "| **${name}** | ${new_version} |" README.md \
        || die "Nie udało się przepisać wersji ${name} w README.md."
    else
      die "W README.md nie ma wiersza tabeli dla pluginu ${name}. Tabela wersji jest przepisywana przez krok wydania - przywróć wiersz w formacie: | **${name}** | <wersja> | ... |"
    fi
  fi
done

# --- Punkty odniesienia (pierwsze uruchomienie) ------------------------------
if [ "${#seed_tags[@]}" -gt 0 ]; then
  summary "Zakładam punkty odniesienia: ${seed_tags[*]}. Bez podbicia; wydadzą się dopiero następne zmiany."
  if [ "$DRY_RUN" = "0" ]; then
    for tag in "${seed_tags[@]}"; do
      git -c "user.name=${RELEASE_AUTHOR_NAME}" -c "user.email=${RELEASE_AUTHOR_EMAIL}" \
        tag -a "$tag" -m "Punkt odniesienia ${tag}"
    done
    push_ref "${seed_tags[@]/#/refs/tags/}"
  fi
fi

if [ "${#released[@]}" -eq 0 ]; then
  summary "Żaden plugin nie wymaga wydania."
  exit 0
fi

# --- Wpis w changelogu, jeden commit, tagi per plugin -----------------------
[ -f "$CHANGELOG" ] || die "Brak ${CHANGELOG}. Krok wydania nie zakłada go sam, bo nagłówek pliku jest treścią, nie szablonem."
grep -qF "$CHANGELOG_MARKER" "$CHANGELOG" || die "W ${CHANGELOG} nie ma markera wstawiania. Przywróć linijkę: ${CHANGELOG_MARKER}"

if [ "$DRY_RUN" = "1" ]; then
  log "[dry-run] wpisy, które weszłyby do ${CHANGELOG}:"
  cat "$entry_file"
  log "[dry-run] potem: commit \"${COMMIT_MARKER} Wydanie: ${released[*]}\", tagi, push"
  exit 0
fi

awk -v marker="$CHANGELOG_MARKER" -v entry_file="$entry_file" '
  { print }
  $0 == marker && !done {
    while ((getline line < entry_file) > 0) print line
    close(entry_file)
    done = 1
  }
' "$CHANGELOG" > "${CHANGELOG}.new"
mv "${CHANGELOG}.new" "$CHANGELOG"

# Tożsamość per wywołanie (`git -c`), nie `git config`: to drugie zapisuje się do
# .git/config i przy uruchomieniu z laptopa nadpisałoby człowiekowi jego własne
# ustawienia w tym repo.
as_release_bot=(git -c "user.name=${RELEASE_AUTHOR_NAME}" -c "user.email=${RELEASE_AUTHOR_EMAIL}")
git add "$CHANGELOG" README.md plugins
"${as_release_bot[@]}" commit -q \
  -m "${COMMIT_MARKER} Wydanie: ${released[*]}" \
  -m "$(printf '%s\n' "${released[@]}")"

tag_refs=()
for item in "${released[@]}"; do
  tag="${item/ /-}"
  "${as_release_bot[@]}" tag -a "$tag" -m "Wydanie ${tag}"
  tag_refs+=("refs/tags/${tag}")
done

branch="${GITHUB_REF_NAME:-$(git rev-parse --abbrev-ref HEAD)}"
push_ref "HEAD:refs/heads/${branch}" "${tag_refs[@]}"

summary "Wydane: ${released[*]} (gałąź \`${branch}\`). Po stronie użytkowników: \`/plugin marketplace update\`."
