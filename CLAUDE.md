# ForeverTestPad

Test-Addon für WoW Forever (WoW-Variante mit eigener Controller-UI): misst mit Sonden, was Controller-Code dort darf (Fokus, Tasten, Taint), und führt die Tests im Spiel durch. Die eigentlichen Funktionen entstehen als Module in einem Fork von ImprovedForever, der als Klon neben diesem Repo liegt; Plan und Entscheidungen liegen dort. Dieses Addon wird nicht ausgeliefert.

## Aufbau

- Das Repo ist das Addon: `ForeverTestPad.toc`, `ForeverTestPad.lua` (SavedVariables `ForeverTestPadDB`, Chat-Ausgabe, Log, `/tp` und `/testpad`), `Probe.lua` (Sonden, nur per `/tp probe <name>`). Das Spiel lädt nur, was die toc nennt; `tools/` und `docs/` stören dort nicht.
- `docs/sonde.md`: wie die Sonden laufen und was sie im Spiel gemessen haben.
- Test-Fenster `/tp tests` (`Tests.lua`, Prüfungen in `TestChecks.lua`): `docs/tests.md`. `TestData.lua` erzeugt `python3 tools/tests_to_lua.py` aus `../ImprovedForever/plans/tests.md`, nie von Hand ändern; Ergebnisse liest `luajit tools/test_results.lua` (aus dem Repo-Wurzelordner). Nach jeder Änderung an `tests.md` den Generator laufen lassen.
- Der Nutzer verlinkt diesen Ordner einmal von Hand in den AddOns-Ordner des Spiels.

## Regeln

- Code, der tainten kann, läuft nur auf eine Handlung des Nutzers (Befehl, Tastendruck, ein per `hooksecurefunc` beobachteter Aufruf des Spiels), nie beim Laden; Hooks dürfen beim Login gesetzt werden. Was davon im Spiel blockiert, steht in `docs/sonde.md`.

## Prüfungen

- Syntax: `luajit -bl <datei>`.
- Versehentliche globale Variablen: `luajit -bl <datei> | grep -oE 'G[GS]ET.*"[A-Za-z_0-9]+"'`; jede `GSET` außer `ForeverTestPadDB` und `SLASH_*`/`SlashCmdList` ist ein Fehler, jede `GGET` muss eine Spiel-API sein.
- Logs im Spiel: `TP.Log` schreibt nach `ForeverTestPadDB.probe`; auf der Platte erst nach `/reload` oder Logout, in `WTF/Account/<Konto>/SavedVariables/ForeverTestPad.lua`.
