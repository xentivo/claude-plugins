---
name: sekrety
description: Użyj gdy workflow dotyka sekretów, tokenów, uprawnień `permissions`, obcych akcji z marketplace'u albo logowania do chmury przez OIDC - w tym gdy automat ma mergować, komentować PR-a albo reagować na etykietę. Zbiór pułapek, na których pipeline albo cicho nie działa, albo oddaje za dużo uprawnień.
---

# Sekrety, tokeny i uprawnienia w pipeline

Pipeline ma dostęp do wszystkiego, czego potrzebuje deploy. Każdy krok, który
dostaje token albo klucz, jest miejscem, przez które ktoś może wyjść na zewnątrz.

Pełna zasada organizacji: `get_rule("ci-pipeline")` na serwerze Xentivo MCP.
Zasady o samych sekretach w repo: `get_rule("security")`.

## Ciche pułapki (nie dają błędu, tylko nie działają)

- **`secrets` nie jest widoczne w `if`** ani joba, ani kroku. Warunek na sekrecie
  napisz przez `env` na poziomie joba. Wersja z `if: secrets.X != ''` po prostu jest
  fałszem i krok nigdy nie leci.
- **Zdarzenia wywołane `GITHUB_TOKEN` nie startują kolejnych workflowów.** Automat
  mergujący tym tokenem wprowadzi kod do pnia bez odpalenia deployu: kod w pniu, na
  środowisku stara wersja, nigdzie ani jednej czerwieni. Potrzebny PAT albo token
  GitHub Appa, a przy jego braku job ma paść z jawnym komunikatem.
- **Auto-merge jest domyślny, więc bramką jest autor, nie etykieta.** Automat uzbraja
  każdy PR do gałęzi chronionej, a etykieta służy tylko do WSTRZYMANIA (opt-out). Przy
  takim modelu jedyną rzeczą, która odróżnia PR zespołu od PR-a z forka, jest
  **sprawdzenie prawa zapisu AUTORA PR-a** - bez niego kod z zewnątrz scala się sam po
  zielonym CI. Warunku na aktorze zdarzenia nie stawiaj: przy domyślnym uzbrajaniu
  blokowałby zdarzenia od osób z rolą `triage`, które tylko dokładają etykiety.
- **Token automatu potrzebuje prawa do PULL REQUESTÓW, nie tylko do repo.** Uzbrajanie
  idzie mutacją GraphQL `enablePullRequestAutoMerge`, więc REST-owe sprawdzenie
  uprawnień przechodzi, a samo uzbrojenie pada na `Resource not accessible by personal
  access token (repository.pullRequest)`. Token fine-grained: `Pull requests: Read and
  write` **oraz** `Contents: Read and write`, plus to repo na swojej liście; klasyczny:
  scope `repo`. Nieudane uzbrojenie ma kończyć job czerwono z wypisaną przyczyną - inaczej
  automat jest funkcją na papierze i nikt tego nie zauważa.
- **Wstrzymanie musi zawodzić zamknięte.** Rozbrojenie (`--disable-auto`) po nadaniu
  etykiety wstrzymującej: najpierw odczytaj stan auto-merge, a nieudany odczyt albo
  nieudane rozbrojenie zakończ błędem. Branie każdego niezerowego kodu wyjścia za „nie
  było czego rozbrajać" znaczy, że wygasły token przepuści merge, który człowiek jawnie
  zatrzymał.
- **Subject federated credentiala musi być w formacie immutable**, z numerycznymi ID
  organizacji i repo. Stary format przechodzi walidację w chmurze bez skargi i wywala
  się dopiero w biegu (`AADSTS700213`). Subject bierz znak w znak z treści błędu albo
  z API GitHuba, nie z pamięci.

## Reguły

- `permissions: contents: read` na górze pliku; rozszerzenie deklarujesz w tym jobie,
  który go potrzebuje, i tylko o to, czego potrzebuje.
- Obce akcje przypinaj do **SHA**. Akcja z prawem zapisu po PR-ze albo z kluczem API
  przy `@main` wykonuje u ciebie dowolny przyszły commit z tymi prawami.
- Jeśli akcję da się zastąpić kilkoma linijkami preinstalowanego CLI, zastąp ją -
  szczególnie akcję logującą do chmury.
- Logowanie do chmury przez OIDC, bez hasła service principala. Federated credential
  **per environment**, bo subject jest wiążący.
- Sekret zależny od środowiska (cała treść `.env`) to **environment secret**, nie
  sekret repo. Wtedy job stage'owy nie odczyta prodowego.
- `pull_request_target` tylko dla automatyki działającej NA PR-ze (auto-merge,
  etykiety) i **bez checkoutu** kodu z PR-a. Skutek uboczny, o którym trzeba wiedzieć:
  workflow bierze się wtedy z gałęzi bazowej, więc zmiany w takim pliku nie da się
  zobaczyć na PR-ze, który je wprowadza - działają dopiero po merge'u.
- Pierwszy krok joba sprawdza komplet sekretów i wypisuje **brakujące nazwy** oraz
  miejsce, gdzie się je ustawia.
- Wartości sekretów nigdy nie idą do logu. Tokena wyciągniętego w kroku maskuj
  (`::add-mask::`).

## Po napisaniu

Wypisz użytkownikowi, co musi ustawić **poza repo**: environments, sekrety w nich,
federated credentials, PAT dla automatu, „Allow auto-merge". Konfiguracji OIDC nie da
się sprawdzić lokalnie - testem jest pierwszy ręcznie uruchomiony bieg.
