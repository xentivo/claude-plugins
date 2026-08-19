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

Ustalony przez autorkę. Stosuj go w tekstach pisanych jej głosem (posty, artykuły, newslettery, eseje). Nie stosuj w tekstach użytkowych, gdzie nie ma miejsca na autorkę: UX copy, komunikaty błędów, opisy funkcji, dokumentacja.

- **Wejście: własna myśl.** Pierwsza osoba, ale bez scenerii. Nie „stałam kwadrans na przystanku", tylko myśl, obserwacja, wątpliwość albo odczucie postawione wprost. Jedno, maksymalnie dwa zdania. Bez rozkręcania, bez tezy całości na starcie.
- **Środek: coś, co da się wskazać.** Kiedy tekst opiera się na twierdzeniu o świecie, podaj nazwisko i rok. Kiedy opiera się na doświadczeniu albo obserwacji z pracy, nazwisko jest zbędne i sztuczne, a jego miejsce zajmuje konkret: rozróżnienie, kontrprzykład, sytuacja z branży. W obu wariantach obowiązuje ten sam zakaz „badania pokazują".
- **Wątpliwość zostaje otwarta.** Prawdziwa, nie retoryczna. Znak, że jest prawdziwa: obie strony mają rację o czymś innym i nie da się tego rozstrzygnąć w akapicie. Pytanie postawione tylko po to, żeby za chwilę na nie odpowiedzieć, jest ozdobą i wypada.
- **Wyjście: drobiazg.** Ostatni akapit najkrótszy, jedno albo dwa zdania, o czymś zwyczajnym i konkretnym. Nie streszczenie, nie morał, nie wezwanie do działania. Jeżeli forma wymaga pytania do czytelnika (typowo post), pytanie idzie po drobiazgu jako osobna krótka linia, nie zamiast niego.
- **Akapity nierówne.** Najdłuższy zazwyczaj w środku.
- **Maksymalnie jeden żart na akapit.**
- Długość formy zmienia proporcje, nie zasady. W poście wejście to jedno zdanie, środek jeden konkret, wyjście jedna linia.

## Zakaz zmyślania

Model nie ma dostępu do doświadczeń autorki, więc nie wolno mu ich produkować. Dotyczy to zdarzeń, rozmów, miejsc, odczuć przypisanych autorce, danych, nazwisk, dat i tytułów badań.

Kiedy tekst potrzebuje konkretu, którego nie ma w materiale, zostaw oznaczone miejsce i napisz, czego brakuje:

`[DO UZUPEŁNIENIA: konkretna sytuacja z klientem, która to pokazuje]`
`[ŹRÓDŁO? twierdzenie wymaga nazwiska i roku]`

Puste miejsce jest w porządku, bo autorka je zapełni. Zmyślone wspomnienie i fałszywy przypis nie są w porządku, bo mogą pójść dalej niepostrzeżenie.

Wejście przez własną myśl działa tu na korzyść: myśl da się napisać z materiału, który jest w tekście, a scena wymagałaby wymyślenia przystanku.

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
> Nie umiem już czytać zdania „marka to coś więcej niż logo" bez podejrzenia, że nikt go nie sprawdził na sobie. Logo klient przetwarza w pół sekundy i zapomina. Sposób mówienia i to, na co marka reaguje publicznie, zostaje mu w głowie na lata, chociaż nie potrafi tego nazwać.
>
> [DO UZUPEŁNIENIA: konkretny przykład marki albo klienta, u którego to było widać]
>
> Kolorystyka i tak zostaje w brandbooku na pierwszej stronie.

Uwaga do tego przykładu: wejście jest myślą o czytanym zdaniu, nie zmyśloną rozmową. Nazwiska ani roku tu nie ma, bo tekst nie twierdzi nic o świecie, tylko o robocie.

**Przykład 3 (tekst czysty)**

Wejście:
> Czternastka jeździ w moją stronę, tylko nie w niedzielę.

Wyjście: bez zmian. W raporcie: brak trafień.
