# Die 10 wichtigsten Tests

Kurzfassung von `tests.md`, geordnet nach dem, was ein Test freischaltet. Die Nummern sind die aus `tests.md`, dort steht jeder Schritt ausführlich. Jedes Mal mit `/console taintLog 1` spielen, wo ein Taint-Log verlangt ist.

| # | Tests | Was zu tun ist | Schaltet frei |
|---|---|---|---|
| 0 | 94 | Test-Fenster `/tp tests` ausprobieren; danach laufen alle weiteren Tests darüber | S-74 |
| 0b | 107–113 | Berufskarte an drei Rezepten, `/if prof audit`, Karte per Tippen, Zauberstab auf Viereck, Reload-Knopf, General-Schalter, Fischsammlung und Bags & Bank mit dem Pad | PR 1, PR 5, PR 6 (`prs.md`) |
| 0c | 117, 119–122 | Peek map auf L3, `/if peek`, drücken, `/reload`, `ImprovedForever.lua` bereitstellen; alte Belegung, Leisten-Slot, Rad, Halten/Tippen, Doppeldruck abgelehnt | S-104, S-105, danach der Belegungs-Plan (`bindings-overhaul.md`) |
| 1 | 86–88, 95 | Auktionshaus öffnen, `/dump ImprovedForever.Auction.Price(…)`, „Auction window“ aus, graues Item im Sell-Tab, Schwelle ändern, Kategorie „Below vendor price“ | S-69, S-90, S-91 und der Grau-Fix fertig |
| 1b | 96–99 | Hauptmenü > Stärkungseffekte (Auswahl am richtigen Platz); Info-Leiste verlinken, jeden Ort, Werte, Sitzungsgewinn; Stapel-Tooltip | Buff-Fix, Info-Leiste S-92–S-94, Stapelpreis fertig |
| 1c | 100–102 | Bags & Bank verlinken, Bank öffnen, zweiter Charakter, `/if bags` mit Pad und Maus, Kampf | S-82–S-85 fertig; danach kann BagSync weg |
| 1d | 114–116, 118 | Leinenumhang beim Ingenieur, Leinenstoff mit Schneider-Twink, Schalter „Other characters“; Improved-Forever-Rad bearbeiten | S-110, S-112, S-108 fertig |
| 2 | 48 | `/if perf 30`, Fenster öffnen und schließen, `/reload` | Performance S-41, S-43–S-53, S-66 |
| 3 | 69 | Taint-Log für die Ausnahmen (Quest mit Spoken, Einstellungsseite aus dem Addons-Tab, Spielfenster bei offenem ImprovedForever-Fenster), dann Kampf | S-58, Review-Befunde vor den PRs |
| 4 | 23–31 | Addons-Tab: Liste, Legende, Befehle und Seiten mit A, Fensterwechsel | S-28, danach S-29–S-31 |
| 5 | 90–91 | Wheel „Cancel buffs“ anlegen, Buffs abbrechen, auch im Kampf | S-72 fertig |
| 6 | 92–93 | Eckige Minikarte an/aus, Taint-Log mit Kampf; dabei schauen, ob neben Zoom +/− noch der Ereignis- oder Erweiterungs-Knopf am Rand erscheint | S-73 fertig, Eintrag in `docs/taint.md`, Knöpfe am eckigen Rand |
| 7 | 72 | Fenster anderer Addons (BagSync `/bgs`, Auctionator): Cursor, A, B, L2/R2 | S-32 |
| 8 | 34, 60 + Kampf | In der Gruppe Mitglieder und sich selbst anwählen, auch im Kampf | S-64 |
| 9 | 54–59 | Quest-Belohnungen im NPC-Dialog: Zauber, Währungen, Titel, Fertigkeitspunkte, Ehre | PR Quest-Belohnungen (`immersion-quest-rewards.md`) |
