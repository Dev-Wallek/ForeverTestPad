# Offene Tests im Spiel

Gesammelt aus den Plänen; ist ein Test bestanden, wird er hier gestrichen und im Plan abgehakt. Jedes Mal mit achten: kein `ADDON_ACTION_BLOCKED`, keine Taint-Meldung. Was einen Kampf braucht, steht gesammelt unter „Kampf“.

## Auktionspreise und Schwellen (S-69, S-91)

Der Scan geht höchstens alle 15 Minuten, also zwischen den Punkten warten.

86. Auktionshaus öffnen: „scanning…“ und nach einer Weile „auction scan done: …“ im Chat, kein Fehler. Danach `/dump ImprovedForever.Auction.Price(<itemID>)` für ein Item mit Preis: drei Zahlen (Schnitt der fünf billigsten, üblicher Preis, Tage); für ein unbekanntes: nichts.
87. Einstellungen, Auction-Tab, „Auction window“ aus, Auktionshaus öffnen: das Fenster des Spiels erscheint; nach 15 Minuten läuft der Scan trotzdem, Tooltips zeigen „Auction: usually / lowest“, `Price` gibt dieselben drei Zahlen. Danach „Auction window“ wieder an.
88. Sell-Tab: ein graues Item, das im Auktionshaus deutlich mehr bringt (z. B. Zerbrochener Fangzahn), steht unter „Auction“, nicht unter „Sell to a vendor“. Im Auction-Tab „Gain at least“ über seinen Gewinn: das Item wandert zurück; danach auf 1 silver (der Standard; dein gespeicherter Wert ist vermutlich noch „Any gain“).
95. Kaufen-Tab, linker Stick einmal hoch (vom ersten Eintrag): „Below vendor price“ zeigt nach einem neuen Scan Items mit grünem Abzeichen „+X each · +Y for N“ (Gewinn je Stück und für das billigste Angebot mit N Stück), der größte Gewinn je Stück oben; Auction-Tab „Below vendor: at least“ auf 1 silver: Items mit weniger Gewinn je Stück verschwinden; oder „Nothing under a vendor's pay in the last scan“. Ein Item kaufen: die Zeile rechnet neu oder verschwindet. In „Alle“ eines anderen Bereichs trägt ein Item unter Händlerpreis dasselbe Abzeichen (S-90).
103. Einstellungen, Auction-Tab, „Clear this realm's prices“ (zweimal), Auktionshaus öffnen, Scan abwarten. Kaufen: Silberrute suchen: die Zeilen zeigen „58 × 3 39 each“ wie das Fenster des Spiels, „Hold to Buy“ den Preis eines Stücks; Silberrute steht nicht unter „Below vendor price“; Tooltip „Auction: lowest“ etwa 3 Silber (`fix/auction-unit-price`).
104. Kaufen, Filter (L3) „Usable only“ an, z. B. Rüstung: nur Teile, die du tragen kannst, wie mit „Nur nutzbare“ im Fenster des Spiels; eine Qualität ankreuzen: nur diese (`fix/auction-buy-filters`).
106. Nach drei Tagen mit Scans: Kaufen, linker Stick zweimal hoch von der ersten Kategorie: „Bargains“ zeigt Items mit grünem „-NN%“-Abzeichen, die größte Ersparnis oben (oder „Nothing well under its usual price“); Auction-Tab „Bargains at“ auf 20 %: mehr Einträge (S-97).
99. Tooltip eines Stapels in der Tasche (z. B. 12 Leinenstoff): „Auction: usually ×12“ und „lowest ×12“ zeigen den ganzen Stapel, dahinter in Klammern grau ein einzelnes; ein einzelnes Item: nur der eine Preis, kein „×“.

## Wheel „Cancel buffs“ (S-72)

90. Im Wheels-Tab ein Wheel der Art „Cancel buffs“ anlegen und auf eine R3-Kombination legen: Seite „Class“ zeigt die Abbrech-Buffs deiner Klasse (Druide: Gestalten, Schurke: Verstohlenheit …), nicht aktive grau; Seite „On you“ die übrigen Buffs. Einen Buff wählen bricht ihn ab; das Wheel zeigt ihn danach grau bzw. nicht mehr.
91. Im Kampf: Gestalt bzw. Verstohlenheit (oder einen anderen Buff, der vor dem Kampf da war) über das Wheel abbrechen, je dreimal: kein `ADDON_ACTION_BLOCKED`. Ein im Kampf neu erhaltener Buff erscheint nach dem Kampf im Wheel.

## Eckige Minikarte (S-73)

92. `/console taintLog 1`, Minimap-Tab → „Look“ → „Square minimap“ an: Karte eckig, kein runder Rahmen oder Kompassring mehr, kein schraffierter weißer Kreis (Quest-Gebiet) auf der Karte, beim Ausschalten kommt der Rand eines Quest-Gebiets wieder, Addon-Knöpfe (Titan, BagSync) am Rand; Spiel-Option „Minikarte drehen“ an und aus: bleibt eckig. Wieder aus: rund wie vorher, ohne `/reload`. Nach `/reload` mit „an“: gleich eckig.
93. Mit eckiger Karte: Zoomen, Klick auf die Karte, Tracking-Menü aus dem Radialmenü, Charakter öffnen und mit B schließen, ein Kampf; je dreimal. Dann `/console taintLog 0`, `/reload`: `taint.log` nennt `ImprovedForever_Minimap` nicht, kein `ADDON_ACTION_BLOCKED`. Ich trage das Ergebnis in `docs/taint.md` ein.

## Test-Fenster (S-74)

94. `/reload`, `/tp tests`: das Fenster zeigt Test 86 (oder den ersten offenen aus `next-tests.md`), Esc schließt es; mit dem Pad: Cursor auf den Knöpfen, A drückt, rechter Stick scrollt den Text. Start: die Haken kommen, das Band oben erscheint bei geschlossenem Fenster. Screenshot: Fenster kurz weg, Bild im Ordner `Screenshots`. Überspringen springt zum nächsten. `/reload`; ich lese das Ergebnis mit `tools/test_results.lua`.

## Info-Leiste (S-92 bis S-94)

97. `ImprovedForever_Panel` verlinkt und an, `/reload`: oben eine dunkle Leiste mit „Level … %“ und dem Geld. Die Leiste steht immer oben, im Panel-Tab gibt es keine Ortswahl. Panel-Tab „Experience as numbers“ an: „Level N  aktuell / max  (noch X)“ mit Tausenderpunkten; aus: wieder Prozent. Ausrüstung: Haltbarkeit des am meisten abgenutzten Teils in %, orange unter 50, rot unter 25; nach Tod oder Reparatur ändert sie sich; Tooltip listet die abgenutzten Teile. Maus über einen Eintrag: Tooltip mit den genauen Zahlen.
98. Erfahrung per Kill oder Quest, Geld per Kauf und Verkauf: beide Zeilen ändern sich sofort. „Money this session“ an: grünes Plus nach einem Verkauf, rotes Minus nach einem Kauf. „Money“ auf „Move earlier“: Geld steht vorn; „Hide“: weg. Taint-Log an, Postkasten, Händler, Charakterfenster je dreimal öffnen und schließen: kein Blockiert-Fenster.

## Bags & Bank (S-82 bis S-85)

100. `ImprovedForever_Bags` verlinken und an, `/reload`, einmal die Bank öffnen und schließen; mit einem zweiten Charakter einloggen und dort auch; Spiel ganz beenden und neu starten: `/if bags`, Y zeigt beide Charaktere, jeder mit Taschen und Bank.
101. Taint-Log an, Fenster offen, dann ein Spielfenster (Charakter) öffnen, mit L2/R2 hin und her, schließen; einen Kampf beginnen: das Fenster schließt; im Kampf `/if bags`: es öffnet und bleibt, mit der Maus bedienbar, nach dem Kampf mit dem Pad. Kein Blockiert-Fenster.
102. Mit dem Pad: D-Pad über die Plätze (hoch/runter springt über Taschen-Überschriften in die richtige Spalte), der Tooltip des Spiels steht am gewählten Platz, L1/R1 Taschen/Bank, Y Charakter wählen, R3 öffnet das Wiki, B schließt. Mit der Maus: Tooltip, Mausrad, Klick aufs Porträt, mittlere Maustaste aufs Item.

105. Bags & Bank offen, ohne anderes Fenster: Select: Glow und Legende weg, die Figur läuft mit dem Pad; Select noch einmal: das Fenster hat das Pad wieder, ohne dass das Spiel etwas meldet. Mit dem Charakterfenster daneben: Select gibt das Pad dorthin, L2/R2 zurück. Taschen des Spiels öffnen: links daneben ein Taschen-Knopf mit RB+LS darunter; Klick oder R1 halten + L3 öffnet Bags & Bank, L3 allein sortiert weiter. So geöffnet steht es neben den Spieltaschen und bleibt dort, auch beim Suchen darin; Knopf und Modul tragen das neue Rucksack-Symbol. Die Tastenleiste unter dem Fenster steht ganz auf dem Bildschirm (S-96).

## Berufskarte (professions.md)

`ImprovedForever_Professions` an, `/reload`.

107. Berufsfenster öffnen, ein Rezept wählen: daneben (nicht darüber) die Karte „Levelling“ mit Farbleiste und „You: N“, „Chance of a point“, „Until grey: about N crafts“, „You can make“, den Zutaten mit Preis und Quelle (Händler, Auktion oder „?“) samt Summe, dazu Verkauf an Händler und im Auktionshaus, je mit Gewinn. Drei Rezepte prüfen: ein oranges, ein gelbes oder grünes, ein graues („Grey: no more points“). Ein anderes Rezept wählen und eines herstellen: die Karte rechnet neu. Fenster mit B schließen: Karte weg, kein Blockiert-Fenster.
108. In einem Beruf mit gelben oder grünen Rezepten: `/if prof audit`, im Chat „N recipes checked, M differ“; `/reload`, ich lese `profAudit`.

## Karte, Zauberstab, Neuladen, Schalter

109. Map-Tab „Tap to open and close“ an, die Karte auf eine freie Taste legen (z. B. L3): einmal tippen öffnet, noch einmal schließt. Karte öffnen und mit B schließen, dann tippen: öffnet beim ersten Druck. Auch im Kampf.
110. Mit Zauberstab: General-Tab „Square shoots the wand“ an, Ziel wählen, Viereck: der Zauberstab schießt; auch im Kampf; ohne Zauberstab bleibt Viereck wie vorher.
111. General-Tab „Reload the interface“ mit A: das Interface lädt neu.
112. General-Tab „Double tap Menu opens this panel“ und „Other addons' windows in L2 / R2“ je aus, `/reload`, wieder an, `/reload`: beide bleiben an und wirken.
113. Fischsammlung (`/if fishbook`) und Bags & Bank (`/if bags`) mit dem Pad: Glanz und Cursor, die Fenster des Spiels gedimmt, L2/R2 wechselt zu einem offenen Spielfenster und zurück, B und Esc schließen, danach steuert der Pad wieder das Spiel. Kein Blockiert-Fenster.

## Fenster anderer Addons (S-32)

72. Fenster anderer Addons, die Esc schließt (z. B. BagSync `/bgs`, Auctionator): öffnen, es hat den Pad (Cursor, Legende, Glanz falls das Fenster einen hat), D-Pad läuft durch Knöpfe und Häkchen, A drückt, B schließt; neben einem Spielfenster (Charakter) wechselt L2/R2 hin und her; aus dem ImprovedForever-Fenster geöffnet bekommt es den Pad, zu: das ImprovedForever-Fenster hat ihn wieder. Baganator wie vorher (Test 33, 67). General-Tab „Other addons' windows in L2 / R2“ aus: diese Fenster lassen den Pad dem Spiel, ein offenes gibt ihn sofort ab; wieder an: wie vorher, ohne `/reload`. Fenster, die nicht passen oder sich falsch verhalten, bitte nennen.

## Icons

12. Addon-Liste des Spiels: das Addons-Modul zeigt das Puzzleteil.

## Addons-Modul

14. `/if addons dump`: jedes installierte Addon mit Befehl, Einstellungsseite, Fach oder Starter steht in seiner Gruppe (u. a. `/sal`, `/if`, `/bgs`, `/bgr`, `/syn`, `/fcore`, `/spoken`).
23. Tab "Addons" mit Puzzle-Icon im ImprovedForever-Fenster; `/if addons` öffnet das Fenster auf ihm, auch wenn es schon auf einem anderen Tab offen ist.
24. Gruppen alphabetisch nach Addon-Titel, je eine Überschrift; D-Pad hoch/runter und linker Stick gehen durch die Einträge über die Überschriften hinweg, L1/R1 springt zum ersten Eintrag des vorigen/nächsten Addons, Mausrad scrollt, Cursor nur auf dem gewählten Eintrag.
25. Legende: auf einem Befehl "Run", auf Einstellungsseite, Fach oder Starter "Open"; auf einer Seite, die nicht öffnet ("not openable" im Dump), kein A.
26. A auf `/bgs` und `/titanpanel`: läuft wie getippt, ohne Blockade-Meldung im Chat; je dreimal. Dasselbe per Mausklick auf die Zeile.
27. A auf die Einstellungsseite eines Addons (z. B. BagSync) und auf einen Titan-Starter: sie öffnen sich.
28. Öffnet sich dabei oder sonst ein Fenster, das Forever kennt (Einstellungen, Charakter per Taste): es hat Glanz, Cursor und Pad, das ImprovedForever-Fenster bleibt offen ohne Glanz, Cursor und Legende; das neue Fenster liegt nicht verdeckt unter ihm.
29. Dieses Fenster mit B schließen: das ImprovedForever-Fenster hat den Pad sofort wieder (Glanz, Cursor, Legende), auch wenn vorher schon Charakter offen war.
30. Vom neuen Fenster mit L2/R2 Richtung ImprovedForever-Fenster: es bekommt den Pad, das andere bleibt offen; ebenso per Menü-Doppeldruck, Umschalt-Taste und `/if addons`, das Fenster schließt dabei nicht.
31. Esc im neuen Fenster, das alles schließt: kein Fehler, die Tasten gehören danach dem Spiel bzw. dem ImprovedForever-Fenster, falls es offen blieb.
68. Zuletzt geöffnet hat den Pad: aus dem ImprovedForever-Fenster das Wiki (Addons-Tab oder Befehl) öffnen, ebenso aus den Taschen „Zerstören“: das neue Fenster leuchtet, das alte nicht; schließen gibt den Pad zurück. Gegenprobe beim Händler: Händlerfenster und automatisch geöffnete Taschen, der Pad bleibt beim Händler (S-57).
69. Taint-Log für die Ausnahmen (S-58), je Fall dreimal, danach ein gamepad-fokussiertes Spielfenster (Charakter) schließen: `/console taintLog 1`, dann (a) eine Quest mit Belohnungen bei einem NPC öffnen, mit installiertem Spoken_Quests (Compendium-Knopf, automatisches Scrollen zu den Belohnungen); (b) im Addons-Tab mit A eine Einstellungsseite öffnen; (c) bei offenem ImprovedForever-Fenster ein Spielfenster öffnen. Den Kampf danach siehe „Kampf“. Dann `/console taintLog 0`, `/reload`; ich lese `_forever_/Logs/taint.log` selbst.

## Immersion: Begleiter-Pads

15. RB+RT (Jäger/Hexenmeister mit 2+ Begleiter-Zaubern): unser Abbild über der RB+RT-Kachel, Loslassen wirkt den Zauber.
16. Lage und Größe der Icons passen zu den Slots.
17. Mit allen drei Pad-Stilen (`padStyle`) und mit „gleich“ (`padSame`).
18. Bearbeitungsmodus und ausgeschaltete Controller-UI: alles wie ohne unsere Änderung.

## Immersion: Quest-Belohnungen

20. Feste Einzel-Belohnung (frisch nach dem Einloggen, Item noch nicht geladen): nur mit dem D-Pad erreichbar, Tooltip erscheint.
21. Der goldene Ring zeigt mit dem Pad die Wahl, mit der A abschließt.
22. Maus-Wahl und Abschluss per Klick wie vorher.
54. Quest, die einen Zauber lehrt (z. B. „Bergbau: Leitstein“): Zauber als rundes Symbol im Raster, je Zauber eine eigene Zeile links, nach den Wahl-Belohnungen und vor den festen; das D-Pad erreicht ihn, unser Symbol leuchtet, Tooltip des Zaubers an unserem Dialog; ebenso per Maus.
55. Quest mit Währung als Belohnung (falls Forever eine hat): Symbol mit Anzahl nach den festen Gegenständen in denselben Zeilen, D-Pad, Leuchten und Tooltip wie bei Gegenständen; das Gegenstands-Symbol mit gleicher Nummer leuchtet dabei nicht.
56. Titel, Fertigkeitspunkte, Ruf (nur Hauptfraktionen, wie im Spiel-Fenster) und Ehre erscheinen als Zeilen unter „270 EP“; jeweils mit dem Spiel-Fenster (Option „NPC dialog as subtitles“ aus) vergleichen, dass nichts fehlt oder zu viel ist.
57. Noch nicht geladene Belohnung (frisch nach dem Einloggen): Fragezeichen-Symbol an ihrem Platz, das Raster verrutscht nicht, das echte Symbol erscheint von selbst, sobald die Daten da sind; D-Pad-Richtungen passen dabei zum Raster.
58. Schließen und Annehmen/Abschließen mit diesen Belohnungen ohne Taint-Fehler, dreimal.
59. `/dump GetNumQuestLogRewardFactions, GetQuestLogRewardFactionInfo` im Chat: zweimal `function` oder `nil`? Ergebnis nennen (entscheidet, ob normaler Ruf auf der Abgabe-Seite kommt). Dazu: wirken die Belohnungszeilen vollgestopft?

## Immersion: Gruppen-Ziel und Auren

34. In einer Gruppe ein Mitglied anwählen (Pad und Maus): kein gelber Rahmen mehr links über dem Questtracker; die Karte des Mitglieds hat eine dünne goldene Linie am äußeren Rand, beim Zielwechsel springt sie mit, ohne Ziel ist keine zu sehen.
35. Mit den Raid-Stil-Gruppenfenstern (Spiel-Option an) und ohne: in beiden kein Rahmen, kein Bereitschafts-Symbol (Bereitschaftscheck starten) an der Stelle des unsichtbaren Gruppenfensters.
36. Eigenes Begleiter-Tier anwählen: die Begleiter-Karte bekommt die goldene Linie, nur eine, dünn und scharf am äußeren Rand, kein Leuchten um Porträt, Name oder Balken.
37. Bearbeitungsmodus und Einstellung „Karten“ aus: das Spiel-Gruppenfenster mit seinem eigenen gelben Zielrahmen wie ohne unsere Änderung.
38. `/if cards`: die Healer-Karte hat die dünne goldene Linie am äußeren Rand, nichts doppelt; zusammen mit Tank- und Healer-Fokus (`/if cards tank`, `/if cards healer`) sieht man Alarmrahmen und Ziellinie beide.
39. Restzeiten (beim Ziel außerhalb des Kampfes bestanden): ebenso kurz über den Symbolen der Buff-Leiste und unter den Debuffs auf Namensplaketten.
60. In einer Gruppe sich selbst anwählen: per Pad-Gruppenring (Mitte), per Maus (Klick auf die eigene Spielerkarte) und mit F1; dazwischen ein Mitglied und wieder sich selbst: kein gelber Rahmen links oben über dem Questtracker, auch nicht kurz aufblitzend.

## Immersion: Auren-Vorrang

96. Hauptmenü (Radial) > „Stärkungseffekte“: die Buffs des Spiels erscheinen an ihrem Platz, die Auswahl sitzt auf einem davon, X bricht den gewählten ab; B zurück: wieder unsere Reihe (`fix/immersion-view-buffs`).

42. Wenige Buffs, kein Debuff (z. B. 4 Buffs): alle stehen in der Reihe, keiner fehlt. Erst mehr Buffs, als drei Zeilen fassen (UI-Maßstab sehr klein, Party-Karten weit nach links): keiner fällt weg, die Symbole rücken in allen Zeilen enger zusammen, bis alle in drei Zeilen passen.
43. Reihenfolge: die bald ablaufenden stehen am rechten Ende (zur Mitte), die Debuffs rechts von den Buffs; die unterste Zeile sitzt unten auf derselben Höhe wie vorher, Tooltips über den Symbolen wie vorher.
44. UI-Maßstab ändern oder die Party-Karten mit `partyX` verschieben, ohne `/reload`: die Zeilen werden so breit wie der neue Platz, die Symbole behalten ihre Größe.
45. Auren des Ziels: deine Debuffs zuerst, die bald ablaufenden links; mit mehr als 8 je Gruppe fallen fremde und dauerhafte weg. Namensplaketten: deine Debuffs, die bald ablaufenden zuerst, ab mehr als 5 fallen die längsten weg.
46. Effekt-Beschriftungen („Buff row“ aus, „Buffs along the bottom (experiment)“ an): ein frisch erhaltener Buff bekommt seine Beschriftung („+5 STA“), auch wenn sie im ersten Moment fehlt.
61. Begleiter: ohne Begleiter beginnt die Buff-Reihe kurz nach dem Spielerrahmen; Begleiter rufen: die Reihe rückt hinter seine Karte, ohne `/reload`; Begleiter wegschicken: sie rückt wieder zurück.
62. Gruppe mit 2 Mitgliedern, Party-Karten mit `partyX` weit nach links: die Reihe endet kurz vor der linken Karte, keine Überlappung; ein drittes Mitglied kommt dazu: das Ende rückt mit der Karte nach links. Ohne Gruppe endet die Reihe wie vorher vor dem Platz einer vollen Gruppenreihe.
63. Mehr Buffs und Debuffs, als eine Zeile fasst (viele Gruppen-Buffs, Party-Karten nach links): die weiteren brechen in eine Zeile über der ersten um (nicht nach unten, nicht verschwunden), Zeitangaben und Tooltips lesbar, höchstens drei Zeilen; ist die dritte voll, rücken die Symbole zusammen statt einer vierten Zeile, keine Aura fehlt.
64. Sehr viele Auren (Buff-Essen, alle Gruppen-Buffs, viele Procs, UI-Maßstab sehr klein, Party-Karten weit nach links): alle Auren sichtbar in höchstens drei Zeilen, die Symbole überlappen sich wie ein aufgefächerter Stapel (je mindestens ein Drittel sichtbar); stehen die Symbole zu eng, sind die Zeitangaben ausgeblendet; Tooltip mit der Maus über jedem sichtbaren Teil; nach dem Ablaufen einiger Auren rücken die Symbole wieder auf normalen Abstand, die Zeitangaben kommen zurück.
70. Buff-Reihe unter Fenstern: Bank oder Rucksack über der Reihe verdeckt die Buff-Symbole (sie liegen nicht mehr darüber); ohne Fenster zeigt die Maus über jedem Buff-Symbol seinen Tooltip, auch über der Aktionsleiste.

## Messung (S-40)

48. `/if perf 30`, dann in den 30 s nacheinander je ein Spielfenster (Charakter), den Rucksack und eines von uns (ImprovedForever-Fenster) öffnen und schließen, je zwei Sekunden Pause dazwischen: danach nennt der Chat die 10 teuersten Handler (ms/s, Aufrufe/s, langsamster Aufruf), darunter „focus changed“ und seine Teile („focus: ring bindings“, „focus: wheel keys“, „focus: overrides“, „focus: touchpad“, „touchpad: windows changed“), die 5 langsamsten Einzelaufrufe, „addons with frames over 5 ms: …“ und je Addon von uns „addon …: … ms/frame recent, … ms peak“. Im Log steht zusätzlich eine Zeitleiste: je Fokuswechsel eine Zeile mit Dauer und den `UPDATE_BINDINGS` und `CVAR_UPDATE` (mit Namen) seit der Zeile davor. Bitte auch sagen, welches Fenster beim Schließen ruckelte und ob der Pad-Stil „Shapes“ (PlayStation) ist. Danach `/reload` und Bescheid geben; das `perfLog` lese ich selbst.
49. Einstellungen im Immersion-Tab umschalten, mit dem Zurücksetzen-Symbol und „Reset all“ zurücksetzen: wirkt sofort wie vorher, auch nach `/reload`.

## Immersion: Abklingzeit beim Leistenwechsel

50. Zauber mit langer Abklingzeit (30 s+) auf eine Taste der Hauptleiste, dieselbe Taste auf der LT-Leiste leer, auf der RT-Leiste ein Zauber ohne Abklingzeit. Zaubern, LT halten und loslassen, dann RT halten: die RT-Kachel zeigt keinen Ring, keine Zeit, kein graues Icon.
51. Wie 50, aber eine Taste mit Belegung im Bindings-Tab („pad overrides“ an): auf einer Leiste ohne Abklingzeit kein fremder Ring.

## Immersion: Abklingzeit-Reihe neben der Gruppe

66. Gruppe mit 2 Mitgliedern, Zauber mit Abklingzeit wirken: die Abklingzeit-Reihe rechts beginnt kurz hinter der rechten Gruppenkarte (nicht hinter einer vollen 4er-Reihe); Party-Karten mit `partyX` nach links: die Reihe rückt mit; ein Mitglied kommt dazu oder geht: der Anfang folgt der Karte; ohne Gruppe: Anfang wie bisher.

## Verkauf: Reagenzien und andere Charaktere (S-110, S-112)

114. Ein Charakter mit Ingenieurskunst und einem Leinenumhang in den Taschen: kein Schrott-Symbol auf dem Umhang, `/if junk why` mit dem Cursor darauf sagt „Used by your Engineering“; ein Charakter ohne Ingenieurskunst nennt ihn weiter Schrott.
115. Mit einem Schneider-Twink auf demselben Realm und derselben Fraktion (einmal mit ImprovedForever eingeloggt): ein anderer Charakter ohne Schneiderei hat Leinenstoff in den Taschen; im Sell-Tab steht er unter „Keep“ mit „Used by <Twink>'s Tailoring“; ein Schneiderei-Rezept (nicht seelengebunden) ebenso mit „A recipe for <Twink>'s Tailoring“.
116. Junk-Tab, „Other characters“ aus: Leinenstoff aus 115 steht wieder unter „Sell to a vendor“; wieder an: unter „Keep“.

## Improved-Forever-Rad (S-108)

118. Wheels-Tab, Rad „Improved Forever“: zeigt die fünf Fenster wie bisher; einen Slot mit Kreuz auf „Minimap labels“ oder „Reload“ setzen, einen mit Dreieck leeren, Rad im Spiel öffnen: es zeigt genau diese Slots und der gewählte tut, was er soll; Dreieck gehalten setzt auf die fünf Fenster zurück. Die Liste rechts enthält nur Improved-Forever-Funktionen, die Peek map darunter.

## Peek map als Aktion (S-104, S-105)

117. Bindings-Tab: Peek map (Liste „Misc“) auf L3 legen, `/if peek`, L3 drücken und halten, loslassen, `/if peek`, `/reload`; dann `ImprovedForever.lua` aus den SavedVariables bereitstellen (Log `peekLog`). Dazu eine Emote auf L1 + L3 legen, drücken: läuft die Emote, der Autorun oder beides?
119. Eine alte Peek-map-Belegung (vor dem Update gesetzt) steht nach dem Login als Aktion „Peek map“ auf derselben Taste und hält die Karte wie vorher.
120. Peek map in einen Leisten-Slot (Kreuzleiste) legen: Druck öffnet die durchsichtige Karte (nicht die normale), nochmal drücken schließt sie; B, L1/R1 und L2/R2 tun dabei, was sie ohne Karte tun. Dasselbe aus dem Improved-Forever-Rad.
121. Peek map auf L3 (aus 117) und auf eine Tastatur-Taste: ohne „Tap to open and close“ (Map-Tab) offen nur solange gehalten, mit der Einstellung öffnet ein Druck und der nächste schließt.
122. Mit Peek map auf L3: eine Emote auf L3 doppelt legen wird abgelehnt mit „… holds the peek map: pressed twice it can't run anything“; umgekehrt (erst Doppeldruck, dann Peek map auf L3) ebenso mit Grund.

## Autorun und getippte Peek map (S-114, S-116)

123. Bindings-Tab, nichts auf L3: L3 anwählen zeigt „Runs: Autorun (game)“, L1 + L3 zeigt „+ Autorun (game): move it with the Autorun action“. Aktion „Autorun“ (Liste „Misc“) auf L1 + L3 legen: L1 + L3 läuft automatisch, L3 allein läuft nicht mehr. Autorun auf L3 doppelt oder in einen Leisten-Slot legen wird abgelehnt mit „Autorun goes only on a press of its own …“.
124. `/console taintLog 1`. Peek map mit „Tap to open and close“ (Map-Tab) tippen: die Karte hat nie das Pad (kein Leuchtrahmen, kein Cursor, der rechte Stick dreht die Kamera), keine Legende darunter, L1/R1 und L2/R2 tun, was sie ohne Karte tun; nochmal tippen schließt. Ohne die Einstellung halten: unter der Karte stehen Quest wechseln und Zoom, L1/R1 zoomen, L2/R2 wechseln die Quest; Taschen öffnen, während gehalten: Legende weg, L1/R1 gehören den Taschen. Kein Taint-Eintrag.

## Rückmeldungen November (S-117 bis S-126)

125. Wheels-Tab: „Use on release“ an. `/if ringlog`, ein Rad öffnen, mit dem rechten Stick auf einen Slot zeigen, loslassen; dreimal, einmal langsam, einmal schnell; `/if ringlog`, `/reload`; dann `ImprovedForever.lua` bereitstellen (Log `ringLog`). Dazu notieren: wurde etwas benutzt, drehte die Kamera mit?
126. Panel-Tab: „Money this session“ an. Etwas verkaufen, `/reload`: der Gewinn steht weiter da; ausloggen und wieder einloggen: weg; ein zweiter Charakter hat seinen eigenen.
127. Der Balken der Leiste oben geht über die volle Breite, der Text darin beginnt und endet ein Stück vor dem Bildschirmrand.
128. Berufsfenster, Rezept mit einem Reagenz, das ein Händler verkauft und das im Auktionshaus gescannt ist: auf der Karte stehen beide Preise mit „(vendor)“ und „(auction)“; „Reagents per craft“ rechnet mit dem günstigeren.
129. Auktionshaus, Buy-Tab mit dem Pad: X öffnet die Tastatur mit „Search“, ein Wort tippen, Start: die Liste zeigt nur Passendes, danach hat das Auktionshaus wieder das Pad; Kreis schließt die Tastatur ohne Änderung. Mit ausgeschalteter Chat-Tastatur (Chat-Tab): das Suchfeld steht auch mit dem Pad da, X setzt den Cursor hinein (Eingabe über die Steam-Tastatur).
130. Auktionshaus, Kategorie „Below vendor price“ (oder eine andere eigene) mit Suchtext: nur Items, deren Name ihn enthält.
131. Bindings-Tab, Liste „Group“: „Invite target“, „Trade with target“, „Follow target“, „Inspect target“, „Leave group“ auf je eine Taste, einen Leisten-Slot oder ins eigene Rad legen; mit einem Spieler als Ziel tut jede, was ihr Name sagt; ohne Ziel bzw. ohne Gruppe kein Lua-Fehler.
132. Mit dem Pad: eine Gruppeneinladung annehmen und ablehnen, eine Handelsanfrage annehmen, im Handelsfenster ein Item legen, Gold eintragen und den Handel bestätigen; notieren, was nicht geht.
133. Immersion an, mit dem Pad: als Druide die Gestalten (oder als Paladin die Auren, als Krieger die Haltungen) über den Klassen-Knopf öffnen: der Ring erscheint über der Pad-Leiste, nicht unten an der Kachel des Spiels; ein Zauber mit Auswahl in einem Leisten-Slot (Portale des Magiers) öffnet seinen Ring über dessen Kachel; die Begleiter-Ringe wie vorher; Auswahl mit dem rechten Stick und Bestätigen gehen wie beim Spiel. Mit `/console taintLog 1`: kein Eintrag.
134. Nach dem neuen `RecipeData.lua`: im Auktionshaus ein Item öffnen, das ein Händler verkauft (Leinenstoff nicht, aber z. B. Faden oder Phiole): die Zeile über dem Diagramm nennt „a vendor sells it for …“; ein Item, das kein Händler verkauft, nicht.
135. Minimap-Tab: „Square minimap“ an: um die eckige Karte liegt ein bronzefarbener Rahmen mit Rauten an den Ecken, knapp außen am Rand, nichts von der Karte verdeckt, die Knöpfe am Rand weiter klickbar; aus: Rahmen weg, die Karte rund wie vorher. Passt er zum Rest der Oberfläche?
136. Einstellungsfenster mehrmals mit Menü×2 öffnen, auch mit dem Junk-Tab zuletzt offen: geht es nicht richtig auf, schließt es sich und im Chat steht „the panel failed to open, please report: …“; diese Zeile bitte melden. Offen: Menü×2 schließt es. Nach jedem Menü×2 ist das Menü-Rad des Spiels zu (auch nicht verdeckt hinter dem Fenster: nach dem Schließen ist keins zu sehen); mit `/console taintLog 1` kein Eintrag.
137. Junk-Tab „Destroy panel“ an. Ein Rad mit dem Slot „Destroy“: bei geschlossenen Taschen öffnet er das Destroy-Fenster. Taschen zu, R2 + R3: im Chat steht, dass es nur bei offener Tasche geht (öffnet R2 + R3 ein Rad, keine Meldung). Bindings-Tab „Destroy“ entbinden: „Destroy panel“ bleibt an, der Rad-Slot öffnet weiter, R2 + R3 bei offenen Taschen nicht mehr. „Destroy panel“ aus: Rad-Slot und `/if destroy` öffnen nicht, Meldung „the Destroy panel is off“. Bindings-Tab „Destroy“: unter dem Namen steht „R3 with L1, L2, R1 or R2 held“; auf Y oder R3 allein legen wird abgelehnt mit „Destroy: only R3 with L1, L2, R1 or R2 held …“, L1 + R3 geht.
138. Ein NPC als Ziel, außerhalb des Kampfes: Rad-Slot „Wiki: target“ (Liste „Improved Forever“) oder `/if wiki target` öffnet seine Wiki-Seite mit Fundort und Drops; ohne Ziel oder mit einem Spieler als Ziel eine Meldung im Chat; im Kampf „opens after combat“.
139. Auktionshaus, Buy-Tab, ein Item mit mindestens vier gescannten Tagen, das sich zuletzt um 5 % oder mehr bewegt hat: in seiner Zeile steht „rising +N%“ oder „falling −N%“, bei weniger als 5 % grau „steady +N%“, im Tooltip die Zeile „Auction: lately“. Stört es?
140. `/console taintLog 1`, `/tp probe clear`, `/tp probe rares`; durch ein Gebiet mit bekannten Rares laufen (Namensplaketten an), Kreaturen anvisieren und mit der Maus überfahren, danach mit A einen NPC ansprechen; `/tp probe rares`, `/reload`, `ForeverTestPad.lua` bereitstellen. Notieren: kam bei einem Rare die Chatzeile, und schon bevor er Ziel war?
141. `/console taintLog 1`. Karte in einem Gebiet mit Rares öffnen (z. B. Wald von Elwynn): an ihren Spawnpunkten liegen Totenköpfe, gleich groß beim Zoomen; die Maus darüber zeigt Name und Stufe; die Peek map zeigt sie auch. Map-Tab „Rares on the map“ aus: weg. Rad-Slot „Wiki: rares here“ oder `/if wiki rares`: Wiki-Seite mit den Rares der Zone, Kreuz öffnet einen, Viereck zeigt ihn auf der Karte. Danach Karte mit dem Pad bedienen und schließen, ein Fenster mit dem Pad schließen: kein Taint-Eintrag, kein Hängen des Cursors auf den Totenköpfen.
142. `/console taintLog 1`, Minimap-Tab „Square minimap“ an. In den Spieloptionen „Minikarte drehen“ an: die Minikarte wird rund wie die des Spiels, ohne eckigen Rahmen, und dreht; aus: wieder eckig mit Rahmen und Nordpfeil. Mit Drehen an „Square minimap“ ein- und ausschalten: sie bleibt rund, beim Einschalten sagt der Chat, warum. Danach ein Fenster mit dem Pad schließen: kein Taint-Eintrag.
143. `/console taintLog 1`, `/reload`, die normale Karte nicht öffnen. Erster Peek (gehalten oder aus dem Rad): die durchsichtige Karte erscheint an ihrem Platz, ohne dass kurz die normale Karte oder ein Leuchtrahmen zu sehen ist, und hat nicht das Pad (das Öffnen-Geräusch kommt doppelt). Dasselbe nach `/reload` mit Rad-Slot und mit einem Leisten-Slot, der vor dem Update belegt war. Im Kampf: die Peek map geht nicht auf, einmal im Chat „Peek map: not in combat …“; vor dem Kampf geöffnet, im Kampf loslassen oder nochmal drücken schließt sie. Danach ein Fenster mit dem Pad schließen: kein Taint-Eintrag.

## Neue Funktionen November (S-137 bis S-143)

Vorher den Ordner `ImprovedForever_Threat` in den AddOns-Ordner verlinken.

144. Addon-Liste: „Improved Forever: Threat“ mit Schild-Symbol; Einstellungen: Tab „Threat“ mit demselben Symbol und den Schaltern „Threat meter“, „When alone“, „Aggro warnings“. Modul in der Addon-Liste aus, `/reload`: Tab weg, kein Messer im Kampf; wieder an.
145. In einer Gruppe gegen einen normalen Gegner kämpfen: unter dem Zielfenster der Messer mit dir, Begleiter und Gruppe, der Höchste oben, Prozent rechts, Balken in der Farbe des Stands (grau, gelb, orange, rot). Allein nur mit Begleiter: zwei Zeilen; ganz allein kein Messer, mit „When alone“ an eine Zeile. Ziel weg oder freundlich: Messer weg.
146. Als Tank: kommt ein anderer nah an deine Bedrohung, steht oben rot „Losing aggro!“; als DD nahe an der Bedrohung des Tanks orange „Pulling aggro!“. „Aggro warnings“ aus: nur „Threat“.
147. Gegen einen Boss: der Messer zeigt nur Farben, keine Prozente, keine Fehlermeldung.
148. Immersion mit Zielkopf an: der Messer steht unter Immersions Zielkopf, die Überschrift in dessen Schrift. Gruppenkarten im Tank-Modus: der Rand nach Bedrohung wie vorher.
149. Minimap-Tab, „Loot and gathering“: „All interact icons“ an: Symbole über Leichen, Truhen, Kräutern und Erz in Reichweite (Screenshot). Einmal von Pad auf Maus und zurück wechseln: die Symbole bleiben. Aus: die Spieloption „Interaktionssymbole“ steht wie vorher.
150. „Track your gathering“ an, mit Kräuterkunde oder Bergbau: die Kräuter- bzw. Erzsuche der Minikarte ist an, auch nach einem Neueinloggen; ein Charakter ohne Sammelberuf: keine Ortung neu an, keine Fehlermeldung.
151. General-Tab, „Mail“: „Bank character“ zeigt nur deine Charaktere auf diesem Realm und dieser Seite; einen wählen. Am Briefkasten, Senden-Reiter: rechts neben dem Empfänger „Bank: <Name>“. Bindings-Tab: „Mail to Bank“ (Liste „Bags“) auf eine Taste legen; sie legt das Taschen-Item unter dem Cursor in den nächsten freien Platz, Strg + Rechtsklick ebenso; nichts wird verschickt. Beim 13. Item steht im Chat „The mail is full (12 items).“ „Mail to Bank“ aus: Taste und Klick tun nichts, der Hinweis ist weg.
152. `/console taintLog 1`. Ein Item mit „Mail to Bank“ anhängen, Namen eintippen, mit dem Knopf des Spiels senden, Postfenster mit dem Pad schließen; dann Kampf (unter „Kampf“).
153. Panel-Tab, „Rested“: ein Charakter mit voller Erholung einloggen: eine Zeile im Chat („Your rested experience is full …“), der XP-Baustein endet auf „(full)“; mit „Rested tips“ an steht ein Tipp dahinter. `/logout` außerhalb von Gasthaus und Stadt: eine Zeile im Chat (abbrechen); im Gasthaus: keine. „Rested reminders“ aus: keine Zeilen.
154. Überwachte Tasten, je einmal: Schrott markieren (L2 + L3 auf ein Taschen-Item), Sell All Junk per Taste beim Händler, Minikarten-Namen per Taste, Fischsammlung per Taste, Recent loot per Taste, Chat-Tastatur per Taste, Destroy (R2 + R3 bei offener Tasche): jede tut, was sie soll, genau einmal je Druck; die Taste tut daneben weiter ihr Eigenes. Dabei `/if perf 20`: in der Liste stehen Zeilen „key watch: …“.

## Kampf

Ein Kampf deckt mehrere Punkte ab: direkt davor einen oder mehrere Aufbauten (A) machen, dann kämpfen und auf `ADDON_ACTION_BLOCKED` achten. Jeder Punkt dreimal, in beliebigen Kämpfen. Zum Kampf vom Fenster weggehen ist erlaubt.

Vor dem Kampf (A), dann ein Kampf ohne Blockade:

- 69: nach den Fällen a–d des Taint-Logs (der Kampf gehört noch in dasselbe Log).
- 152: Mail to Bank benutzt und das Postfenster mit dem Pad geschlossen (im selben Taint-Log).

Im Kampf:

- 19: Begleiter-Menüs (RB+RT) benutzen.
- 34 / 60: in einer Gruppe Mitglieder und sich selbst anwählen; die goldene Linie bleibt, kein gelber Rahmen. Fehlt die Linie nur im Kampf, hält Forever `UnitIsUnit` im Kampf geheim: bitte melden (S-64).
- 39: Restzeiten über der Buff-Leiste und auf Namensplaketten.
- 41: in der Gruppe Ziele wechseln.
- 47 / 65: mit vielen Auren, volle drei Zeilen, Procs kommen und gehen: keine Aura fehlt. Erwartet: der Abstand ändert sich erst nach dem Kampf, kurz darf eine vierte Zeile entstehen; ausgeblendete Zeitangaben bleiben aus, solange die Symbole eng stehen.

Kampfbeginn:

- 32: bei offenem ImprovedForever-Fenster, vorn und im Hintergrund: es schließt ohne Blockade; im Kampf öffnet `/if addons` nicht, Hinweis im Chat.
