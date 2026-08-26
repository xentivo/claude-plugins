---
name: wersja
description: Użyj gdy trzeba odczytać albo podbić numer wersji aplikacji - przed wydaniem, w PR-ze ze zmianą zachowania, przy pytaniu "jaka wersja stoi na tym środowisku" albo gdy wersja w UI nie zgadza się z tą w repo. Mówi, w którym pliku wersja żyje w danym ekosystemie, czym ją podbić i po czym poznać, że repo ma dwa źródła prawdy.
---

# Skąd bierze się numer wersji

Pełna zasada organizacji: `get_rule("versioning")` na serwerze Xentivo MCP. Tutaj
jest to, czego zasada nie może wiedzieć: gdzie konkretnie szukać w tym repo.

## Plik wersjonujący per ekosystem

Szukaj w **korzeniu repo**, w tej kolejności, i zatrzymaj się na pierwszym trafieniu.

| Ekosystem | Plik | Pole | Czym podbić |
|---|---|---|---|
| Node, TypeScript | `package.json` | `.version` | `npm version --no-git-tag-version patch\|minor` |
| Python (PEP 621, Poetry) | `pyproject.toml` | `[project] version` albo `[tool.poetry] version` | `poetry version patch`, dla `uv` edycja plus `uv lock` |
| Python (setuptools) | `setup.cfg`, `setup.py` | `version` | edycja plus synchronizacja z `__version__` pakietu |
| Rust | `Cargo.toml` | `[package] version` | `cargo set-version --bump patch` (cargo-edit) |
| .NET | `Directory.Build.props`, `*.csproj` | `<Version>` | edycja pliku |
| Java, Maven | `pom.xml` | `<version>` | `mvn versions:set -DnewVersion=X.Y.Z` |
| Java, Gradle | `gradle.properties` albo `build.gradle` | `version` | edycja pliku |
| Go | **brak** | - | wersją jest tag, patrz niżej |
| PHP (Composer) | `composer.json` bez pola `version` | - | wersją jest tag |

**Podbijaj komendą ekosystemu, nie ręczną edycją manifestu.** Komenda dotyka też
lockfile'a: `npm version` zmienia `package-lock.json` w dwóch miejscach. Ręczna edycja
samego `package.json` rozjeżdża lockfile, a wtedy `npm ci` przerywa build na
niezgodności, zamiast po cichu podnieść zależność.

## Repo bez pliku wersjonującego

Go i większość projektów PHP nie mają gdzie trzymać numeru: menedżer zależności czyta
go z taga. Wtedy **kolejny numer wyprowadzasz z ostatniego taga**, a wydanie jest
jednocześnie podbiciem:

```bash
git fetch --tags origin
git tag --sort=-v:refname | head -1
```

W takim repo nie ma czego podbijać w PR-ze i nie ma czego sprawdzać przed wydaniem
poza tym, którego commita tagujesz.

## Wersja w kodzie to bug, nie skrót

Znajdź, jak aplikacja pokazuje wersję, i sprawdź, czy czyta ją z pliku
wersjonującego. Wzorzec poprawny to wstrzyknięcie na etapie builda:

```ts
// next.config.ts - wersja wypalona w bundlu przy `next build`,
// bo klient nie ma dostępu do package.json w runtime
env: { NEXT_PUBLIC_APP_VERSION: require("./package.json").version }
```

Wzorzec do naprawy to stała:

```ts
export const APP_VERSION = "1.0";  // NIE. Milczy, kiedy package.json idzie w górę.
```

Ta jedna linia siedziała w `aria` do 18.08.2026 i zjadła osiem podbić z rzędu: reguła
była stosowana, numer w repo rósł, UI pokazywał `1.0`. Szukaj po nazwie: `grep -rn
"APP_VERSION\|__version__\|VERSION =" --include="*.ts" --include="*.py"`.

Jeśli znajdziesz drugie źródło, powiedz o tym **zanim** cokolwiek podbijesz. Podbicie
przy dwóch źródłach utrwala rozjazd, bo test „widzę nową wersję w UI" przestaje
odróżniać wdrożone od niewdrożonego.

## Czego nie brać za wersję

- **Licznik commitów, hash, data builda.** Metadane builda. Mogą stać w etykiecie
  obrazu po `+`, ale rosną przy każdym commicie, także takim, który nie zasługuje na
  podbicie.
- **Numer w nagłówku dokumentu.** `ARCHITEKTURA.md` w `aria` ma własny licznik wersji
  dokumentu. Z wersją aplikacji nie ma wspólnego nic poza formatem.
- **Tag obrazu w rejestrze.** Bywa równy wersji, bywa hashem. Źródłem jest plik
  wersjonujący albo tag repo, nie rejestr.
