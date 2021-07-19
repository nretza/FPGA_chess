# FPGA-chess als Abschlussprojekt für das Elektronikpraktikum

- [FPGA-chess als Abschlussprojekt für das Elektronikpraktikum](#fpga-chess-als-abschlussprojekt-für-das-elektronikpraktikum)
  - [Übersicht und Funktionen](#übersicht-und-funktionen)
  - [Input](#input)
  - [state machine](#state-machine)
  - [Ausgabe](#ausgabe)
  - [Limitationen](#limitationen)

## Übersicht und Funktionen

![VGA OUTPUT](./photo.jpg)

Als Abschlussprojekt wurde ein simples Schachbrett mit neun Feldern in einer 3x3-Anordnung und einer Figur erstellt. Die Figur kann mittels der WASD-Tasten eines PS2-Keyboards und Bestätigung über einen Key am FPGA nach oben, unten, links und rechts verschoben werden. Der Output des Brettes samt Schachfigur erfolgt mittels VGA auf einen Monitor. Hier werden die neun Felder des Schachbrettes ausgegeben und die Figur über diesen dargestellt. 

das Schachbrett ist als state-machine umgesetzt, was bei einer einzelnen Figur deutlich leichter als eine umsetzung per RAM ist.

Zu Debugging-Zwecken werden außerdem der Zustand der state machine und die aktuell ausgewälte Bewegungsrichtung auf die HEX-Displays des FPGA ausgegeben.

## Input

Der Input erfolgt mittels PS2-Keyboards. Hierzu wurde das in den Labs herangezogene Modul `ps2decoder` verwendet, welches den ascii-Wert der zuletzt gedrückten Taste ausgibt. Hieraus konnten die Bewegungsrichtungen:
- W: nach oben
- A: nach rechts
- S: nach unten
- D: nach links

abgeleitet werden. Die Darstellung der Bewegungsrichtung erfolgte mittels HEX-Displays am FPGA, wozu in dem in den Labs verwendeten Modul `asciidecoder` einige Zeilen ür die WASD-Tasten ergänzt wurden, so dass diese über die Zahlen 1-4 darestellt werden können. 

## state machine

Die state machine für das Schachbrett war im `chess_state` modul mit neun states umgesetzt, was neun Feldern entspricht, auf denen sich die Figur befinden kann. Über einen Trigger in Form eines Keys am FPGA wurde ein `always`-Block ausgelößt, welcher je nach ausgewählter Bewegungsrichtung den State veränderte, korrespondierend mit der Bewegung der Schachfigur. Befindet sich die Schachfigur an einem Rand des Schachbretts und soll die Figur weiter in Richtung des Randes verschoben werden, ändert sich der Zustand der state machine nicht.

Zu Debugging-Zwecken wurde der Zustand der state machine auf den HEX-Displays des FPGAs ausgegeben.

## Ausgabe

Die Ausgabe des Schachbretts erfolgt mittels VGA. Hierzu wurden zuerst eine 65 MHz Clock mittels des `pll65` moduls und VGA-Signale mittels des im Lab verwendeten `xvga` moduls erzeugt. Diese Signale wurden dem `chess_display` modul übergeben, welches abhängig von den Werten in `hcount` und `vcount` die RGB_Werte des entsprechenden Pixels entsprechend der Farben des zugehörigen, 100x100 Pixel großen Feldes färbte. 

In einem weiteren schritt wurde der Zustand der state machine evaluiert, und die Koordinaten des derzeit aktiven Pixels im derzeit von der Figur besetzten Feld evaluiert. Ein "Artwork" der Figur war als 100-Bit langes `reg` umgesetzt, welches, aufgeteilt in 10x10 blöcke, mittels 1 und 0 die Umrisse einer Figur darstellt. Dieses Artwork wurde über Auswahl der Koordinaten auf 100x100 "hochskaliert", um der Größe eines Feldes zu etsprechen. Zuletzt wurde die Farbe eines Pixels überschrieben, wenn er sich im Feld der Schachfigur befindet und seine Koordinaten inerhalb dieses Feldes dem Wert von 1 im Artwork der Figur entsprechen.

## Limitationen

Das Schachbrett wurde als state-machine umgesetzt, die Ergänzung weiterer Felder ist an sich also reine copy-paste Arbeit. Anders sieht es bei der Ergänzung neuer Figuren aus, da durch diese die Anzahl der möglichen Zustände stark ansteigt. Hierzu müsste auf andere Lösungen, z.B. eine Umsetzung mittels RAM, zurückgegriffen werden. Dies erfordert jedoch grundlegene Änderungen im Projekt. Ebenso müsste dann weiter bestimmt werden, welche Figur gerade verschoben werden soll, was evtl. zum Umsetzen eines Auswahlcursors o.ä. führt. Hier wäre es auch möglich, die Figut belibig über das Brett zu verschieben, und nicht an eine Bewegung von Feld zu Feld gebunden zu sein.

Die Bewegung über das Brett muss über einen Key am FPGA bestätigt werden, und kann nicht direkt nach Eingabe auf dem Keyboard erfolgen. Das liegt daran, dass das Signal `ascii_ready` aus dem PS2-Decoder vor dem eigentlichen Ascii-Signal triggert. Würde dieses Signal also von der state machine als trigger verwendet werden, würde immer die vorletzte gedrückte Taste als Eingabe interpretiert werden. Somit ist ein externer Trigger von nöten.