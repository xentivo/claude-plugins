# Dziennik decyzji

Trwałe ustalenia architektoniczne i świadome kompromisy. Najnowsze na górze. Krótkie, atomowe wpisy. Nie duplikuj treści z `CLAUDE.md`.

---

## 2026-05-18 — Dystrybucja jako plugin claude-memory (repo = marketplace)

**Decyzja:** Skille spakowano w jeden plugin Claude Code `claude-memory`
(`plugins/claude-memory/`, manifest `.claude-plugin/plugin.json`, skille w
`skills/`). To repo jest jednocześnie marketplace
(`.claude-plugin/marketplace.json` w korzeniu). `.claude/skills/` USUNIĘTE —
plugin jest jedynym źródłem (wybór użytkownika: „tylko plugin"). Lokalizacja
zasobów przez `${CLAUDE_SKILL_DIR}` zamiast detekcji projekt/global.
Autor: Xentivo sp. z o.o. Opis: „Claude memory - zaoszczędź tokeny".

**Dlaczego:** Reużycie w innych projektach jedną komendą (`/plugin install`)
zamiast ręcznego kopiowania; wersjonowanie przez marketplace.
`${CLAUDE_SKILL_DIR}` to udokumentowany sposób odwołania do zasobów skilla
niezależny od miejsca instalacji — eliminuje kruche one-linery z `$HOME`.

**Konsekwencje:** Komendy są namespace'owane: `/claude-memory:resume|save|graph`
(nie da się skrócić). W tej sesji web skille nie działają, dopóki nie doda się
marketplace. Skill `save` woła generator z siostrzanego skilla przez
`${CLAUDE_SKILL_DIR}/../graph/generate_graph.py`. Zastępuje poprzednią decyzję
o instalacji globalnej przez `cp`.

---

## 2026-05-18 — Setup przenośny: skille samowystarczalne pod instalację globalną

**Decyzja:** Skille `resume`/`save`/`graph` uczyniono przenośnymi. Generator przeniesiono z `tools/` do folderu skilla (`.claude/skills/graph/generate_graph.py`); szablony pamięci wbudowano w `.claude/skills/save/assets/`. Skille lokalizują swoje zasoby projektowo (`​.claude/skills/...`) lub globalnie (`~/.claude/skills/...`). `save` zakłada `docs/claude-memory/` z szablonów, jeśli brak; `resume` nie traktuje braku pamięci jak błędu.

**Dlaczego:** Użytkownik chce reużywać setup w wielu projektach. Najmniej tarcia daje instalacja globalna (`~/.claude/skills/`) — wymaga, by skille nie zależały od plików w repo. Pamięć pozostaje per-projekt (decyzje/logi są różne), więc jest scaffoldowana, nie współdzielona.

**Konsekwencje:** Katalog `tools/` usunięty. Instrukcja przenoszenia w sekcji „Przenoszenie..." w `CLAUDE.md`. Przy zmianie generatora pamiętać, że bywa uruchamiany ze ścieżki globalnej.

---

## 2026-05-18 — Strukturalna mapa: własny generator stdlib zamiast Graphify

**Decyzja:** Dodano `tools/generate_graph.py` (Python, tylko biblioteka standardowa) generujący `graph.json` w korzeniu repo + Skill `graph`. Węzły = pliki; krawędzie = linki/wikilinki Markdown oraz importy (Python przez `ast`, JS/TS/shell lekkim regex). Wyjście deterministyczne (posortowane).

**Dlaczego:** Wcześniej świadomie pominięto Graphify jako zależność zewnętrzną (środowisko offline). Użytkownik chce warstwy strukturalnej, ale bez zewnętrznych narzędzi — własny generator stdlib daje większość zysku (odpytywanie mapy zamiast re-czytania repo, oszczędność tokenów) przy zerowych zależnościach i wersjonuje się z kodem.

**Konsekwencje:** `graph.json` odświeżany przez Skill `graph` oraz w kroku `save`. Generator nie robi pełnego AST wielu języków (poza Pythonem) — to świadomy kompromis: lekkość i zero zależności ponad kompletność. Git hook `pre-commit` tylko na wyraźną prośbę.

---

## 2026-05-18 — Pamięć jako Skille Anthropic, nie komendy slash

**Decyzja:** Logika `/resume` i `/save` żyje teraz jako Skille Anthropic w `.claude/skills/<nazwa>/SKILL.md` (frontmatter `name` + `description` z konkretnymi frazami-wyzwalaczami + `allowed-tools`). Stare pliki `.claude/commands/resume.md` i `save.md` usunięto.

**Dlaczego:** Format Skilli daje model-invoked auto-wyzwalanie po opisie (a `/resume`, `/save` nadal działają z palca), spójny standard Anthropic i jedno źródło prawdy. Trzymanie obu form groziło dryfem treści.

**Konsekwencje:** Odwołania w `CLAUDE.md` i `docs/claude-memory/README.md` wskazują na Skille. Nowe zachowania pamięci dodaje się jako Skille w `.claude/skills/`, nie jako komendy.

---

## 2026-05-18 — System pamięci: tylko warstwa plikowa, bez Obsidian/Graphify

**Decyzja:** Zaimplementowano pamięć Claude jako pliki w repo (`docs/claude-memory/` + komendy `/resume` i `/save`). Pominięto Obsidian (osobna aplikacja desktopowa) i Graphify (zewnętrzne CLI generujące `graph.json`).

**Dlaczego:** Agent pracuje w środowisku offline bez tych narzędzi. Monorepo ma już strukturalne mapy kontekstu (`AGENTS.md`), więc warstwa „graph.json” dawałaby mały zysk przy realnej zależności zewnętrznej. Warstwa pamięci deklaratywnej (logi sesji + decyzje) daje większość korzyści (brak amnezji między sesjami) przy zerowych zależnościach i wersjonuje się razem z kodem.

**Konsekwencje:** Jeśli pojawi się potrzeba mapy strukturalnej kodu — rozważyć osobne zadanie; nie blokuje warstwy pamięci.
