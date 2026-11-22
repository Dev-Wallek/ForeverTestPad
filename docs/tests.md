# Tests im Spiel

`/tp tests` öffnet ein Fenster mit dem nächsten offenen Test aus `tests/tests.md`, in der Reihenfolge von `tests/next-tests.md`.

- **Start** beginnt einen Lauf: Die Prüfungen des Tests (`TestChecks.lua`) laufen jede Sekunde, erfüllte bekommen einen Haken. Jede Blockade (`ADDON_ACTION_BLOCKED` / `FORBIDDEN`) wird mit Addon und Funktion festgehalten. Ist das Fenster zu, zeigt ein Band oben den laufenden Test.
- **Bestanden**, **Nicht bestanden**, **Überspringen** schließen den Lauf ab (mit Notiz, falls eingetragen) und gehen zum nächsten offenen Test; Bestanden und Nicht bestanden machen einen Screenshot. Ein Test mit vollständiger Selbstprüfung (z. B. 88) besteht von selbst.
- Mit dem Pad, solange das Fenster offen ist: A Start, X Bestanden, Y Nicht bestanden, RB Überspringen, LB Screenshot, D-Pad links/rechts voriger/nächster Test, hoch/runter scrollt, B schließt. Die Notiz geht nur mit der Tastatur.
- **Screenshot** jederzeit; das Fenster ist dabei kurz weg. Die Bilder liegen im Ordner `Screenshots` des Spiels, die Zeiten stehen im Ergebnis.
- Ein Lauf übersteht `/reload`: danach läuft er weiter, abschließen wie sonst.

Ergebnisse landen in `ForeverTestPadDB.tests` (auf der Platte erst nach `/reload` oder Logout). `luajit tools/test_results.lua` listet sie. Nach einer Änderung an `tests.md` oder `next-tests.md`: `python3 tools/tests_to_lua.py`, dann `/reload`.
