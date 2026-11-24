# Sonde

Alle Sonden schreiben nach `ForeverTestPadDB.probe`. Die Datei auf der Platte entsteht erst bei `/reload` oder Logout: `WTF/Account/<Konto>/SavedVariables/ForeverTestPad.lua` im Ordner `_forever_`. `/tp probe clear` leert das Log, `/tp` allein listet alle Sonden. Blockierte Aktionen (`ADDON_ACTION_BLOCKED`, `ADDON_ACTION_FORBIDDEN`) landen immer im Log, mit dem Addon, dem das Spiel die Schuld gibt.

## S-2: Tasten und Fokus

1. `/tp probe clear`, dann `/tp probe start`.
2. Fenster öffnen, in jedem L1, R1, L2 und R2 drücken.
3. `/tp probe stop`, dann `/reload`.

Das Log hat eine `state`-Zeile bei jeder Änderung von Fokus-Rahmen, `shownFrames` oder der Belegung von L1/R1/L2/R2, und eine `press`-Zeile bei jedem Tastendruck des Pads: Belegung der Taste, Element unter Forevers Cursor (`nav`) und alle sichtbaren Rahmen, die Pad-Tasten selbst annehmen (`receivers`).

### Ergebnis, Lauf 1 (Client 1.60.1, Build 16001)

| Fenster | Fokus-Rahmen | L1/R1 | L2/R2 |
|---|---|---|---|
| Händler | `MerchantFrame` | `MerchantFrameTabIndicatorsLeft/RightTabButton` | Forevers allgemeine Belegung |
| Charakter | `CharacterFrame` | `CharacterFrameTabIndicatorsLeft/RightTabButton` | allgemein |
| Berufe | `ProfessionsFrame` | `ProfessionsFrameLeft/RightTabButton` | allgemein |
| Zauberbuch | `PlayerSpellsFrame` | allgemein | allgemein |
| Weltkarte | `WorldMapFrame` | leer | allgemein |
| Spielmenü | `GameMenuFrame` | leer | allgemein |
| Addon-Liste | `AddonList` | leer | allgemein |
| kein Fenster | – | allgemein oder leer | leer |

"Allgemein" heißt `CLICK InputFunctionBindingButton_<Taste>`, Forevers eigene Tastenfunktion.

- Fenster mit Tabs legen L1/R1 auf ihre Tab-Knöpfe. Kein Fenster belegt L2/R2 selbst. Das bestätigt D-3.
- `shownFrames` hatte immer genau ein Fenster, weil jedes allein offen war.
- In der Addon-Liste landet Forevers Cursor zuerst auf `AddonListCloseButton`.
- Bei einem R2-Druck im Händlerfenster nahm `GamepadPetActionFlyout` (Begleiter-Ausklappmenü) Pad-Tasten an.
### Ergebnis, Lauf 2

- Mehrere Fenster gleichzeitig: `shownFrames` hält alle (z. B. `ProfessionsFrame,CharacterFrame,PlayerSpellsFrame`), L2/R2 wechseln den Fokus reihum, L1/R1 folgen dem fokussierten Fenster.
- Spieltaschen ohne Baganator: `ContainerFrameCombinedBags` kommt in `shownFrames`, L1/R1 bleiben allgemein.
- Baganator taucht nie in `shownFrames` auf, auch nicht beim Händler.
- Addon-Liste: Forevers Cursor erreicht nur `AddonListCloseButton` und die Zeilen der Liste, nie den Neu-laden-Knopf.
- Offen: Bank.

## S-3: Ergebnisse, Lauf 1

| Experiment | Ergebnis |
|---|---|
| `cursor` | nicht gelaufen: Baganator-Fenster war nicht offen |
| `settings` | Name statt Zahl: Fehler, `Settings.OpenToCategory` will die Kategorie-ID. Sonde sucht die ID jetzt über den Namen |
| `compartment` | Baganator und SkillUpForever öffnen ohne Fehler; RareScanner ist aus. SpeedyAutoLoot hat kein Fach, nur `/sal` |
| `ldb` | Spoken öffnet seine allgemeinen Einstellungen. Bekannte Starter: `Leatrix_Plus`, `Spoken`, `TitanUI` |
| `bags` | Hook auf `ToggleBackpack_Combined` lief nie. Sonde hängt jetzt an `OpenBackpack` |
| `pad1` | A ohne Priorität: Forevers Belegung bleibt oben, solange Forevers UI den Fokus hat; unsere kam nur zeitweise durch (ein Klick erreichte den Knopf). ForeverTestPad braucht Priorität, solange sein Fenster aktiv ist |
| `addons` | `SaveAddOns` + `ReloadUI` speichert (`changed={}` bei 38 Addons), auch außerhalb der Addon-Liste |
| `macro` | Je Klick liefen nur 3 der 30 Zeilen, also etwa 255 Zeichen: `macrotext` ist wie Makros auf 255 Zeichen begrenzt |

## S-3: Ergebnisse, Lauf 2

| Experiment | Ergebnis |
|---|---|
| `cursor` | Blockiert: `SmartNavigation:SelectButton` aus Addon-Code löst „Interface-Aktion fehlgeschlagen“ aus (`SmartNavigation.lua:84`). Forevers echter Cursor ist für ForeverTestPad tabu |
| `bags` | Der Weg ist `GamepadRadial.lua:619` → `ToggleBackpack_Combined` (`ContainerFrame.lua:176`) → `OpenBackpack`. ForeverTestPad schloss `ContainerFrameCombinedBags`; danach Esc und Kampf ohne Blockade |
| `settings` | `Settings.OpenToCategory` will eine Zahl; Baganator setzt seine Kategorie-ID auf den Namen. ForeverCore öffnet Einstellungen über `securecallfunction(C_SettingsUtil.OpenSettingsPanel, id)`, weil der Lua-Weg blockiert; die Sonde macht es jetzt genauso |

## S-3: Ergebnisse, Lauf 3

| Experiment | Ergebnis |
|---|---|
| `compartment Baganator` | Öffnet „Baganator anpassen“, keine Blockade |
| `compartment SkillUpForever` | Öffnet seine Einstellungsseite (über ForeverCores sicheren Weg), keine Blockade |
| `ldb Spoken` | Öffnet die Einstellungen, aber „Interface-Aktion fehlgeschlagen“: Spokens `OnClick` ruft `Settings.OpenToCategory`, und dessen Fokus-Code (`SettingsPanel` → `SmartNavigation:SelectButton`/`LeaveFocusGroup`) läuft unter ForeverTestPads Aufruf |
| `settings Baganator` | Kategorie-ID ist der Text `Baganator`, keine Zahl (`order=13`, `categorySet=2`) |
| `settings` (KeepOrSell) | KeepOrSell steht nicht in der Liste der Einstellungsseiten |
| Begleiter-Menü | `GamepadPetActionFlyout` öffnet mit LB+LT immer an `CENTER` → `UIParent:BOTTOMLEFT` 928,55, mit und ohne Immersion; Immersions Leiste liegt dort darüber |

Im Chat stand einmal "Interface-Aktion auf Grund eines Addons fehlgeschlagen", ohne `ADDON_ACTION_*`-Zeile im Log. ForeverTestPad hängt sich jetzt zusätzlich an die Funktion, die diese Zeile ausgibt, und schreibt den Aufruf-Stack ins Log.

## S-3: Taint-Experimente

Je Experiment einmal:

1. `/reload`, damit kein Taint vom vorigen Experiment bleibt.
2. Experiment wie unten ausführen.
3. Danach L2/R2, A, Esc und einen kurzen Kampf ausprobieren.

Das Taint-Log des Spiels ist nicht nötig; blockierte Aktionen stehen im ForeverTestPad-Log.

| Befehl | Vorher | Was es tut |
|---|---|---|
| `/tp probe cursor` | Baganator-Taschen offen | Setzt Forevers echten Cursor über `SmartNavigation:SelectButton` auf das erste Item. Danach Fenster bedienen, schließen, Kampf. |
| `/tp probe settings [Name]` | – | Öffnet eine Kategorie, wie sie im AddOns-Reiter der Einstellungen heißt (Vorgabe `KeepOrSell`), über den Weg von ForeverCore. Bei unbekanntem Namen nennt das Log alle Kategorien, bei einer ID aus Text die Zahlenfelder der Kategorie. |
| `/tp probe compartment [Addon]` | – | Ruft die `AddonCompartmentFunc` des Addons auf (Vorgabe `Baganator`; auch `RareScanner`, `SkillUpForever`, `Leatrix_Plus`). |
| `/tp probe ldb [Name]` | – | Ruft `OnClick` des LibDataBroker-Starters auf, mit seinem Minikarten-Knopf als Anker, sonst einem Rahmen von ForeverTestPad. Ohne Name listet das Log alle Starter. |
| `/tp probe pad1` | Baganator-Taschen offen | Legt A für 10 Sekunden ohne Priorität auf einen Knopf von ForeverTestPad und liest jeden Frame, was auf A liegt. In der Zeit A im Baganator-Fenster drücken. |
| `/tp probe addons` | – | Zeigt oben den Knopf „TP: Speichern + neu laden“. Addon-Liste öffnen, ein Addon umschalten, Knopf anklicken. Nach dem Neuladen steht im Log, ob sich ein Zustand geändert hat (`changed={}` heißt: alles gespeichert). Die Änderung danach wieder zurückstellen. |
| `/tp probe macro` | – | Zeigt den Knopf „TP: Makro“ mit 30 `/run`-Zeilen, zusammen über 1700 Zeichen. Anklicken; jede gelaufene Zeile steht im Log. Fragt das Spiel, ob Skripte erlaubt sind, mit Ja bestätigen. |
| `/tp probe rares` | – | An/aus. Liest Kreaturen nur über die Ereignisse von Namensplaketten, Mouseover und Ziel (`UnitClassification`), nie einen Plaketten-Rahmen: jede Kreatur einmal ins Log, Rares mit `RARE` und einer Chatzeile. In ein Gebiet mit Rares laufen, danach mit A NPCs ansprechen: ein `ADDON_ACTION_*` im Log hieße Taint. |
| `/tp probe threat` | Ziel ein Gegner, am besten in Gruppe oder mit Begleiter | An/aus. Loggt höchstens einmal je Sekunde jede Bedrohungsabfrage für Spieler, Begleiter und Gruppe gegen das Ziel, ob sie geheim ist, und wie oft jedes Bedrohungsereignis seit der letzten Zeile kam (S-131). |
| `/tp probe loot [all]` | – | An/aus. Loggt die Soft-Target-CVars, die Ortungsarten der Minikarte und jedes Soft-Interaktionsziel (Art, Name, tot). Mit `all` alle Interaktionssymbole als temporäre Werte an; aus stellt die des Pad-Modus zurück und loggt die CVars erneut (S-132). |
| `/tp probe mail [Name]` | Briefkasten, Senden-Reiter offen | Hängt das erste ungebundene Item des Rucksacks per API an und trägt mit Name den Empfänger ein (`SendMailNameEditBox:SetText`, Taint-Experiment). Loggt die Namensformen und die Bankarten (S-133). |
| `/tp probe xp` | einmal ohne, einmal mit Essens- oder XP-Buff | Loggt Erholung, Ausruhen, jede Aura mit Tooltip und die Tooltips der XP-Items (S-135). |
| `/tp probe layer` | in Gruppe | An/aus. Loggt bei Ziel-, Gruppen- und Gebietswechsel die Server-, Instanz- und Zonen-Teile der GUID des Ziels und ob du die Gruppe leitest (S-134). |

`/tp probe frame <Name>` schreibt einen Rahmen mit Ankern, Kindern und Eltern-Kette ins Log (sichtbar, Alpha, Ebene, Maus). `/tp probe watch <Name>` lässt die laufende Sonde zusätzlich jede Änderung von Sichtbarkeit und Ankern dieses Rahmens loggen.

Ergebnisse gehen danach hier ein, je Experiment: blockiert ja oder nein, mit der Log-Zeile.

## S-10: Befehlsliste

Die Befehlsliste sammelt ImprovedForevers Addons-Modul: `/if addons dump`, dann `/reload`, schreibt sie nach `ImprovedForeverDB.addonsLog`, je Addon eine Zeile `<Titel>: <Art> <Text>; …` (Arten `slash`, `settings` mit ID und „not openable“ bei Text-ID, `compartment`, `ldb`) und am Ende die ausgeblendeten Bibliotheks-Befehle.
