# Pipeline

Plugin do [Claude Code](https://code.claude.com/): budowanie i poprawianie pipeline'ów
CI/CD zgodnie z zasadą `ci-pipeline` organizacji Xentivo.

## Zawartość

| Komponent | Ile | Do czego |
|---|---|---|
| Skille | 3 | `bramka-pr`, `deploy`, `sekrety` - procedury dla trzech obszarów pipeline'u |
| Komendy | 1 | `xvo-zbuduj-pipeline` - zbuduj albo uzupełnij pipeline repozytorium |
| Agenci | 0 | niepotrzebni |
| Hooki | 0 | niepotrzebne |
| MCP | 0 | nie wystawia serwera, ale skille i komenda **czytają** zasady z serwera Xentivo MCP |

## Po co

Zasada `ci-pipeline` idzie przez MCP do wszystkich repozytoriów, a narzędzia do jej
stosowania nie były nigdzie: leżały w `.claude/` repozytorium `mcp-org-rules`, czyli
działały wyłącznie przy pracy nad samą zasadą. Pipeline buduje się w innych repo.

## Podział obowiązków

**Treść normatywna żyje w `content/ci-pipeline.md` w `xentivo/mcp-org-rules`** i idzie
przez MCP. Ten plugin trzyma samą procedurę i dociąga resztę przez `get_rule`.
Kopiowanie reguł do `SKILL.md` dałoby drugą wersję prawdy, która rozjedzie się przy
pierwszej poprawce zasady - dlatego skille odsyłają do `get_rule("ci-pipeline")`
zamiast cytować.

Wniosek praktyczny: **plugin bez dostępu do serwera Xentivo MCP jest połowiczny.**
Procedura poprowadzi przez kroki, ale uzasadnienia i historie wpadek zostaną poza
zasięgiem.

## Instalacja

```
/plugin marketplace add xentivo/claude-plugins
/plugin install pipeline@xvo-plugins
```

## Użycie

Skille odpalają się same, gdy dotykasz plików w `.github/workflows/`. Komenda jest do
wywołania z ręki:

```
/pipeline:xvo-zbuduj-pipeline                    # całość
/pipeline:xvo-zbuduj-pipeline bramka PR          # tylko checki na pull requestach
/pipeline:xvo-zbuduj-pipeline deploy na stage    # tylko deploy
```

Komenda ma `disable-model-invocation: true` - nie wywoła się sama z siebie, bo pisze
pliki w `.github/`.
