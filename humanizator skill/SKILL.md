---
name: czlowiek
description: Przepisuje polski tekst tak, żeby przestał brzmieć jak AI, i doprowadza go do ustalonego głosu autorki (scena na wejściu, nazwane źródło w środku, otwarta wątpliwość, wyjście na drobiazgu). Używaj zawsze, gdy użytkowniczka mówi "humanizuj", "zhumanizuj", "przepisz to po ludzku", "brzmi jak AI", "usuń AI-owe tiki", "sprawdź pod kątem AI", "napisz to moim głosem", "popraw styl", albo gdy wkleja tekst i prosi o redakcję stylistyczną. Używaj też przy pisaniu nowych tekstów po polsku (posty, artykuły, newslettery, eseje), nawet jeśli nie wspomni o humanizowaniu, bo domyślny styl modelu wpada w te wzorce sam z siebie.
---

# Człowiek

Skill do dwóch rzeczy naraz: usuwania z polskiego tekstu wzorców typowych dla nieredagowanego wyjścia modelu i doprowadzania go do konkretnego głosu, który autorka wybrała.

Kolejność ma znaczenie. Najpierw odejmowanie (wzorce), potem dodawanie (głos). Odwrotnie wychodzi tekst gładki i pusty, co jest gorszym problemem niż myślnik w niewłaściwym miejscu.

## Proces

1. Przeczytaj tekst i wypisz sobie konkretne trafienia z katalogu poniżej. Cytuj dosłownie, nie „wydaje się, że jest tu paralela".
2. Przepisz. Nie łataj pojedynczych słów, bo większość tych wzorców siedzi w budowie zdania i akapitu.
3. Przeczytaj przepisaną wersję świeżym okiem i sprawdź, czy nie wprowadziłaś nowych trafień w miejsce starych. To się zdarza notorycznie: usunięta paralela wraca jako „raczej X niż Y".
4. Sprawdź, czy tekst po zabiegu nadal coś mówi. Jeżeli po usunięciu ozdób zostaje akapit, który da się skrócić do jednego zdania, powiedz to wprost, zamiast go wygładzać.

## Katalog wzorców

Pochodzi z Wikipedia:Signs of AI writing (WikiProject AI Cleanup) plus obserwacje z polskiego materiału. Żaden pojedynczy punkt nie jest dowodem, dopiero kilka razem.

**1. Negatywna paralela.** Najmocniejszy sygnał i najtrudniejszy do zauważenia, bo ma warianty bez słowa „nie".
- „To nie kaprys pamięci, tylko mechanizm"
- „raczej skomplikowały, niż uporządkowały"
- „mniej jak archiwum, a bardziej jak montażysta"
- „nie tyle nowość, ile intensywność"
- „Ładna teoria, tylko słabo się broni"
- „To nie luksus. To materiał."
Lek: napisz samo twierdzenie. Jeżeli kontrast jest prawdziwy i potrzebny, zostaw jeden na cały tekst.

**2. Trójki.** Trzyelementowe wyliczenia jako odruch, zwłaszcza trzy przymiotniki albo trzy krótkie zdania pod rząd dla rytmu. Lek: dwa elementy albo pięć, nierówne długości.

**3. Mgliste przypisy.** „Badania pokazują", „naukowcy twierdzą", „dzisiaj przyjmuje się", „podobno". Lek: nazwisko i rok. Jeżeli nie znasz źródła, NIE WYMYŚLAJ go. Zostaw `[ŹRÓDŁO?]` i napisz o tym w raporcie.

**4. Nadmuchana ważność.** „Odgrywa kluczową rolę", „stanowi świadectwo", „wpisuje się w szerszy trend", „pozostawił trwały ślad". Lek: podaj fakt i zostaw czytelnika w spokoju.

**5. Fałszywy zakres.** „Od intymnych spotkań do globalnych ruchów", „od milisekund do godzin" tam, gdzie nie ma spektrum. Lek: wymień to, co faktycznie jest.

**6. Domknięcia i podsumowania.** „Podsumowując", „ostatecznie", „w rezultacie", a także aforystyczna puenta w ostatnim zdaniu, która streszcza całość. To najczęstszy tik w dłuższych tekstach. Lek: skończ na konkrecie, nie na morale.

**7. Doklejona analiza.** „Co podkreśla", „co pokazuje szerszy kontekst", „co ilustruje". Lek: usunąć. Jeżeli fakt czegoś nie pokazuje sam, doklejona wykładnia tego nie naprawi.

**8. Wtręty redaktorskie.** „Warto zauważyć", „co ciekawe", „nie sposób pominąć", „trzeba przyznać". Lek: usunąć, treść zostaje ta sama.

**9. Myślniki.** Model wstawia je tam, gdzie człowiek pisze przecinek, nawias albo dwukropek. Lek: przeczytaj zdanie i wybierz właściwy znak. Myślnik w polskim ma swoje miejsca (wtrącenie, opuszczone słowo) i tam jest w porządku.

**10. Formatowanie.** Bold na co drugim pojęciu, wypunktowanie tam, gdzie akapit czyta się lepiej, nagłówki Z Dużych Liter. Lek: proza.

**11. Resztki asystenta.** „Mam nadzieję, że to pomoże", „daj znać, jeśli chcesz coś zmienić", zwroty listowe w tekście, który nie jest listem.

**12. Symetria.** Wszystkie akapity tej samej długości, wszystkie zdania w podobnym rytmie. Człowiek pisze nierówno: raz zdanie na pół akapitu, raz cztery słowa.

**13. Powtórzenie tego samego gestu.** Jeżeli w jednym tekście (albo w kilku z rzędu) dwa razy pojawia się ten sam ruch, na przykład zakończenie na „nie umiem powiedzieć, czy...", drugi trzeba wymienić. To wzorzec widoczny tylko z perspektywy całego zestawu, więc sprawdzaj świadomie.

**14. Słowa-wytrychy po polsku.** „Kluczowy", „istotny", „fascynujący", „wnikliwy", „przełomowy", „w dzisiejszym szybko zmieniającym się świecie", „na koniec dnia".

## Głos docelowy

Ustalony i wybrany przez autorkę. Stosuj go, chyba że wprost powie, że tekst ma być inny (na przykład czysto informacyjny UX copy, gdzie scena na wejściu nie ma sensu).

- **Wejście: scena.** Pierwsza osoba, konkretna sytuacja, dwa albo trzy zdania. Bez rozkręcania i bez tezy na starcie.
- **Środek: nazwisko i rok.** Fakt z konkretnym autorem i datą, podany gęsto, bez tłumaczenia czytelnikowi, dlaczego jest ciekawy.
- **Wątpliwość zostaje otwarta.** Prawdziwa, nie retoryczna. Znak, że jest prawdziwa: obie strony mają rację o czymś innym i nie da się tego rozstrzygnąć w akapicie.
- **Wyjście: drobiazg.** Ostatni akapit najkrótszy, zwykle jedno albo dwa zdania, o czymś zwyczajnym. Może wracać do sceny z wejścia, ale bez podkreślania, że wraca.
- **Akapity nierówne.** Najdłuższy zazwyczaj trzeci.
- **Maksymalnie jeden żart na akapit.**
- W formach krótkich (post, notka) ten sam głos, tylko scena skrócona do jednego zdania.

## Zmyślone szczegóły

Głos wymaga konkretów z pierwszej ręki, których model nie ma. Wolno je zaproponować, ale trzeba je oznaczyć, żeby autorka mogła je wymienić na prawdziwe albo wyrzucić:

`[DO UZUPEŁNIENIA: tu było kwadrans na przystanku, wstaw własną sytuację]`

Nigdy nie zostawiaj wymyślonego wspomnienia bez oznaczenia i nigdy nie wymyślaj nazwiska, daty ani tytułu badania, żeby zapełnić punkt 3. Fałszywy przypis jest gorszy niż mglisty.

## Format odpowiedzi

```
## Tekst

[przepisana wersja, bez komentarzy w środku]

## Co zmieniłem

- „dosłowny cytat" → poprawka (wzorzec 8)
- ...

## Do uzupełnienia

- [tylko jeśli są oznaczone miejsca albo brakujące źródła]
```

Wypisuj tylko rzeczywiste trafienia, maksymalnie osiem, od najpoważniejszych. Nie dopychaj listy, żeby wyglądała solidnie. Jeżeli tekst jest czysty, napisz, że jest czysty.

Jeżeli po redakcji uważasz, że tekst jest gładki, ale nie ma w nim treści, dopisz to na końcu jednym zdaniem. Katalog wzorców tego nie wyłapuje, a to najpoważniejsza wersja problemu.

## Przykłady

**Przykład 1 (wzorce 1, 3, 6)**

Wejście:
> Badania pokazują, że notowanie ręką pomaga pamiętać. To nie kwestia nostalgii, tylko biologii. Podsumowując: warto wrócić do zeszytu.

Wyjście:
> Notowanie ręką ma pomagać w pamiętaniu i ma to swoje źródło: badanie Pam Mueller i Daniela Oppenheimera z 2014 roku. Studenci pisujący odręcznie wypadali lepiej w pytaniach o rozumienie. Próby powtórzenia wyniku dawały jednak efekty dużo słabsze albo żadne.

**Przykład 2 (wzorce 2, 4, 6)**

Wejście:
> Marka to coś więcej niż logo. To wartości, język i energia, które razem tworzą spójną całość odgrywającą kluczową rolę w decyzjach klientów. Ostatecznie liczy się autentyczność.

Wyjście:
> Zapytałam kiedyś klientkę, czym różni się jej marka od konkurencji, i dostałam odpowiedź o kolorystyce. [DO UZUPEŁNIENIA: wstaw własną rozmowę] Odpowiedź nie była zła, tylko dotyczyła warstwy, którą klienci przetwarzają w pół sekundy i zapominają. Zostaje reszta, czyli sposób mówienia i to, na co marka reaguje.

**Przykład 3 (tekst czysty)**

Wejście:
> Czternastka jeździ w moją stronę, tylko nie w niedzielę.

Wyjście: bez zmian. W raporcie: brak trafień.
