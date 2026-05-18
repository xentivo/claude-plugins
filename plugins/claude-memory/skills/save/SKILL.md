---
name: save
description: Zapisuje log bieżącej sesji do plikowej pamięci Claude (docs/claude-memory/sessions/) i w razie potrzeby dopisuje trwałą decyzję do decisions.md. Dystrybuowany jako plugin claude-memory; jeśli pamięć nie istnieje w projekcie, zakłada ją z wbudowanych szablonów. Używaj na końcu sesji przed jej zamknięciem, po zakończeniu większego zadania, oraz gdy użytkownik prosi o „zapisz sesję", „zapisz pamięć", „utrwal stan" lub wpisze /save. Opcjonalny argument: krótki slug opisujący sesję.
allowed-tools: Read, Write, Edit, Bash(python3:*), Bash(git:*), Bash(mkdir:*), Bash(cp:*), Bash(test:*)
---

# Zapis stanu sesji do pamięci projektu

Zapisz stan tej sesji do plikowej pamięci projektu (`docs/claude-memory/`):

0. **Inicjalizacja, jeśli brak pamięci.** Jeśli katalog `docs/claude-memory/`
   nie istnieje, załóż go z wbudowanych szablonów tego Skilla.
   `${CLAUDE_SKILL_DIR}` wskazuje katalog tego Skilla niezależnie od miejsca
   instalacji (plugin, projekt, globalnie):

   ```
   mkdir -p docs/claude-memory/sessions
   cp "${CLAUDE_SKILL_DIR}/assets/README.md" docs/claude-memory/README.md
   cp "${CLAUDE_SKILL_DIR}/assets/decisions.md" docs/claude-memory/decisions.md
   cp "${CLAUDE_SKILL_DIR}/assets/_TEMPLATE.md" docs/claude-memory/sessions/_TEMPLATE.md
   ```

1. Utwórz nowy plik
   `docs/claude-memory/sessions/<YYYY-MM-DD>-<krótki-opis>.md`
   (datę weź z dzisiejszej daty z kontekstu; opis ze sluga przekazanego
   argumentu, a jeśli pusty — z głównego tematu sesji). Wzoruj się na
   `docs/claude-memory/sessions/_TEMPLATE.md`.
2. Wypełnij: gałąź, cel, co zrobiono, kluczowe pliki (z realnymi
   ścieżkami), decyzje/ustalenia, TODO / następny krok. Zwięźle, po polsku,
   perspektywa „co i dlaczego".
3. Jeśli w sesji zapadła trwała decyzja architektoniczna lub świadomy
   kompromis — dopisz atomowy wpis na górze
   `docs/claude-memory/decisions.md` (najnowsze na górze). Nie duplikuj
   tego, co już jest w `CLAUDE.md`.
4. Odśwież strukturalną mapę repo (Skill `graph`). Generator żyje w
   skillu siostrzanym `graph` w tym samym pluginie:

   ```
   python3 "${CLAUDE_SKILL_DIR}/../graph/generate_graph.py"
   ```

5. Nie commituj automatycznie. Pokaż użytkownikowi, co zapisano, i zapytaj,
   czy dołączyć logi pamięci i `graph.json` do najbliższego commita (pamiętaj
   o regułach wersjonowania z `CLAUDE.md`, jeśli istnieje).
