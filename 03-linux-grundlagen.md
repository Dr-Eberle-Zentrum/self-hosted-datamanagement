---
title: 'Linux Schnellstart'
teaching: 45
exercises: 90
---

:::::::::::::::::::::::::::::::::::::: questions 

- Was sind markante Unterschiede zwischen Linux und Windows/Mac

- Wie ist das Dateisystem von Linux aufgebaut?

- Wie kann ich unter Linux Software verwalten?

- Wie bediene ich die Kommandozeile?
::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Essentielle Verzeichnisse kennenlernen

- Software installieren und verwalten

- Erste Schritte mit der Linux-Kommandozeile
::::::::::::::::::::::::::::::::::::::::::::::::

## Status Quo:

- Das Betriebssystem wurde installiert

- Der erste Start wurde durchgeführt

- Der Raspberry Pi ist mit dem Netzwerk verbunden und der SSH-Dienst ist aktiviert

## Raspberry Pi OS

Beim Raspberry Pi OS handelt es sich um eine **Linux-Distribution**. Da das Kernstück eines jeden Linux-Systems, der **Linux-Kernel**, unter einer offenen Lizenz steht, kann und wird dieses Kernstück von vielen Organisationen und Personen genutzt. Erst durch die Kombination mit weiterer Software wie Treibern, Dienstprogrammen und ggf. einer graphischen Oberfläche wird ein vollwertiges Betriebssystem daraus. Die vielen unterschiedlichen Zusammenstellungen mit dem Linux-Kernel als Kernstück werden als Distribution bezeichnet.

Einen Eindruck über die Fülle an unterschiedlichen Distributionen gibt die [Linux Distribution Timeline](https://commons.wikimedia.org/wiki/File:Linux_Distribution_Timeline.svg) auf Wikipedia.

Das Raspberry Pi OS wird von der Raspberry Pi Ltd. entwickelt. Es ist speziell auf die Hardware des Raspberry Pis angepasst, ressourcensparend und basiert auf der Debian-Distribution. Deshalb sind Anleitungen für Debian-Linux-Systeme häufig auch für das Raspberry Pi OS passend.

## Linux Schnellstart:

### Dateisystem

Das Linux-Dateisystem ist für alles Linux-Distributionen weitestgehend einheitlich. Die oberste Hierarchie-Ebene ist dabei immer das Verzeichnis `/` (Slash). Dieses ist vergleichbar mit dem "C:"-Laufwerk unter Windows.

Weitere wichtige Verzeichnisse sind:

- die Benutzerverzeichnisse unter `/home/<username>/`, z.B. `/home/david/`

Hier liegen die Dateien, Dokumente und Konfigurationen der User. Schreib- und Leserechte haben nur die jeweiligen Benutzer und die Administratoren. Die Verzeichnisse sind mit dem Pfad `C:\Users\<username>\` unter Windows vergleichbar.

- Die Systemverzeichnisse (z.B. `/etc/`, `/var/`, `/mnt/`, `/lib/`, `/bin/`, `/sys/`)

Diese Verzeichnisse beinhalten Systemdaten, z.B. Programme, Programmbibliotheken, temporäre Dateien, Log-Dateien oder systemweite Konfigurationen. Deshalb haben in diesen Verzeichnissen i.d.R. nur Administratoren Schreibrechte.

Im Vergleich mit dem Dateisystem von Windows fällt auf, dass es unter Linux nur einen Verzeichnisbaum für alle Dateien, Festplatten und Laufwerke gibt. Auch zusätzliche Festplatten oder externe Datenträger werden in Linux-Systemen zunächst durch eine Gerätedatei im Verzeichnis `/dev/` identifiziert und können dann über sogenannte Einhängepunkte oder Mountpoints an einer beliebigen Stelle des Verzeichnisbaumes verfügbar gemacht werden ("eingehängt" oder "gemountet" werden). Unter Windows haben zusätzliche Datenträger und Laufwerke stets ihre eigene unabhängige Verzeichnishierarchie, was die Verwaltung von Festplatten weniger flexibel macht.

![Vergleich der Dateisysteme von Linux, Mac und Windows](fig/03_Filesystem.png){alt='Die Abbildung zeigt nebeneinander drei Verzeichnisbäume. Je einen für die Betriebssystem Linux, Mac und Windows. Dabei wird insbesondere die unterschiedliche Art der Einhängung von zusätzlichen Datenträgern wie Festplatten oder USB-Sticks hervorgehoben.'}

#### Systemweite Konfigurationen in `/etc/`

Das Verzeichnis `/etc/` enthält zahlreiche Konfigurationsdateien für die systemweite Verwaltung von Programmen. Viele Programme haben hier eigene Unterordner (z.B. `/etc/apache2` für die Konfiguration des Apache-Webservers). Möchte man die Konfiguration eines Programms systemweit ändern, ist das `/etc/` Verzeichnis i.d.R. ein guter Startpunkt. Schreibrechte haben hier nur Administratoren.

#### Programmverzeichnnisse: `/bin/`, `/sbin/`, `/usr/bin/` `/usr/sbin/`

- `/bin/`: Essentielle Systemprogramme (Start, Restore, Basisprogramm des Betriebssystems) 

- `/usr/bin/`: ergänzende Systemprogramme

- `/sbin/` und `/usr/sbin/`: nur für Administratoren nutzbare Programme

#### Dynamische Programmdateien: `/var/`

Das Betriebssystem erzeugt ständig neue Dateien, z.B. werden in den Log-Dateien Systemereignisse protokolliert. Solche dynamischen Inhalte werden i.d.R. im `/var/`-Verzeichnis gespeichert.

#### Einhängepunkte `/mnt/` und `/media/`

Externe Laufwerke und Wechselmedien werden standardmäßig in den Verzeichnisse `/mnt/` und `/media/` eingebunden. Dies ist allerdings kein zwingende Vorgabe und häufig gibt es gute Gründe eine Festplatte an einer anderen Stelle des Verzeichnisbaumes einzuhängen, z.B. im Home-Verzeichnis eines Users.

### Weitere Quellen

Mehr zur Verzeichnisstruktur von Linux findet sich z.B. bei [Ubuntusers](https://wiki.ubuntuusers.de/Verzeichnisstruktur/) oder bei der Tuxacademy im Handbuch zur [Linux-Essentials-Zertifizierung](https://www.tuxcademy.org/product/lxes/) auf den Seiten 146-154.

## Paketverwaltung
Programme (oder auch Pakete, Packages, Software oder Apps) werden in Linux i.d.R. durch eine zentrale Paketverwaltung ähnlich einem App-Store auf dem Smartphone installiert. Da auch Android auf dem Linux-Kernel aufbaut, sind die Prozesse zur Softwareverwaltung im Raspberry Pi OS vergleichbar mit den Prozessen, die im Hintergrund ablaufen, wenn man auf dem Smartphone eine App installiert und aktualisiert.

### Paketquellen

Zur Installation verfügbare Software wird unter Linux in Paketrepositorien (oder auch Paketkatalogen oder Paketquellen) aufgelistet und verfügbar gemacht. Ein Repositorium wird i.d.R. vom Hersteller des Betriebssystems zur Verfügung gestellt und ähnelt in der Funktion dem Google-Play-Store auf einem Android-Smartphone.

Die in den Repositorien des OS-Herstellers beinhaltete Software sind in kompatibel mit dem Betriebssystem und je nach konkretem "Unterkatalog" auch getetest. Allerdings handelt es sich nicht immer um die neueste Version, da neue Versionen aufgrund der Tests und Abhängigkeiten zu anderer Software erst zeitverzögert in die Kataloge aufgenommen wird.

Bevor Software Software installiert werden kann, muss das Betriebssytem die aktuelle Version des Katalogs herunterladen. Dies erfolgt auf der Kommandozeile mit dem Befehl `sudo apt-get update` oder `sudo apt update`. Möchte man anschließend ein Programm installieren, muss der Name des entsprechenden Pakets bekannt sein. Die Installation erfoglt dann mit `sudo apt-get install <Paketname>`. 

Der Vorteil der zentralen Paketverwaltung ist, dass in den Repositorien stetst festgehalten ist, welche Version eines Programms die aktuelle ist. Druch den Abgleich der Versionen aller installierter Programme mit dem Repositorium kann die Paketverwaltung so schnell ermitteln, für welche Programme es Aktualisierungen gibt. Um diese dann zu installieren, muss der Befehl `sudo apt-get upgrade` ausgeführt werden.

#### Fremdquellen

Ist den Paketquellen des OS-Herstellers nicht die nötige Software enthalten, können auch Fremdquellen zum System hinzugefügt werden. Hierbei handelt es sich um Paketkataloge, die nicht vom OS-Hersteller (oder der Community) überprüft wurden. Deshalb besteht hier stets die Gefahr, dass die enthaltende Softwar das System beschädigt oder es sich um Malware handelt. Es gibt jedoch immer wieder Fälle, bei welchen solche Fremdquellen nötig sind. Wie diese dem System hinzugefügt werden können, ist z.B. [hier](https://linuxize.com/post/how-to-add-apt-repository-in-ubuntu/) für die Ubuntu-Distribution geschildert und kann so auch für das Raspberry Pi OS übernommen werden.

#### Weitere Befehle

Weiter wichtige Befehle für die Paketverwaltung sind z.B.

- `sudo apt-get autoremove <Paketname>`: entfernt Abhängigkeiten von Programmen, die selbst nicht mehr installiert sind. Dadurch wird das System aufgeräumt.

- `sudo apt list --upgradeable`: zeigt aktualsierbare Programm an

- `sudo apt-get remove <Paketname>`: entfernt ein Paket, nicht jedoch dessen Konfigurationsdateien

- `sudo apt-get purge <Paketname>`: entfernt ein Paket inkl. dessen Konfigurationsdateien

#### Stolpersteine bei der Paketverwaltung

- Abhängigkeitsprobleme: v.a. bei der manuellen Installation von Paketen oder der Nutzung von Fremdquellen besteht die Möglichkeit, dass ein Programm ein anderes Programm als Abhängigkeit benötigt. Diese Abhängigkeit ist aber nicht in den Paketquellen enthalten. Dadurch kommt es zu einem nicht automatisch auflösbaren Abhängigkeitsproblem. Mögliche Maßnahmen sind die manuelle Installation der Abhängigkeiten (die aber weiter Abhängigkeiten haben können) oder der Downgrade auf eine kompatible Version.

- Paketname: häufig sind die Paketnamen für eine Programm nicht eindeutig. Um den genauen Namen für die Installation zu finden, können die Programmkataloge durchsucht werden: `sudo apt-cache search <Suchbegriff>`. Alternativ kann natürlich auch im Internet nach dem genauen Namen eines Pakets gesucht werden.

::::::challenge

### Webserver

Sie möchten auf Ihrem Linux-Server eine Website hosten. Dazu wollen Sie den Webserver Apache installieren. Wie gehen Sie vor?

:::solution
Der erste Schritt bei der Softwareverwaltung sollte immer die Aktualisierung der Paketquellen sein: `sudo apt-get update`.

Auch kann es nicht schaden, das System auf den aktuellen Stand zu bringen, bevor neue Software installiert wird: `sudo apt-get upgrade`.

Dann müssen Sie herausfinden, wie das Paket, das den Apache-Webserver für das Raspberry Pi OS liefert, heißt. Das können Sie mit einer Internetrecherche oder dem Befehl `sudo apt-cache search apache` tun.

Wenn Sie wissen, wie das Paket lautet, können Sie dieses mit dem Befehl `sudo apt-get install <Paketname>` installieren.
:::

::::::

## Kommandozeile

### Grundlegende Bedienung

- *Pfeiltasten* hoch/runter: durch bisherige Befehle blättern und diese wieder aufrufen

- *Tab-Taste:* Autovervollständigung von Pfaden und Befehlen. Erste Buchstaben eines Pfades tippen, dann TAB-Taste für die Autovervollständigung oder anzeigen von Optionen.

- *STRG + C*: bricht den laufenden Befehl ab

- Kopieren: mit dem Cursor Text auswählen, dann *STRG + Umschalt + C*

- Einfügen: *STRG + Umschalt + V*

- Cursor-Position: mit Pfeiltasten ändern, geht nicht per Mausklick

### Mit der Kommandozeile im Dateisystem navigieren

- Verzeichnis wechseln: `cd <Pfadangabe>`, z.B. `cd /home/david/Dokumente`

-in das eigene Home-Verzeichnis wechseln: `cd`

- Eine Ebene nach oben gehen: `cd ..`

- Zwei Ebenen nach oben gehen: `cd ../..`

- Aktuelle Positin im Dateisystem anzeigen: `pwd`

- Verzeichnisinhalt anzeigen lassen: `ls` oder mit mehr Informationen `ls -l`

### Dateioperationen:

- Datei erstellen: `touch <Dateipfad>/<Dateiname>`

- Verzeichnis anlegen: `mkdir <Dateipfad>/<Neuer-Ordner>`

- Inhalt einer Textdatei ausgeben: `cat <Datename>`

- Oberste oder letze 10 Zeilen einer Datei anzeigen lassen: `head <Dateiname>` und `tail <Dateiname>`

- Datei kopieren/verschieben/löschen:

    - Copy: `cp <Quelldatei> <Zieldatei>`
    
    - Move: `mv <Quelldatei> <Zeildatei>`
    
    - remove: `rm <Dateiname>` oder remove recursive: `rm -r <Verzeichnispfad>

### Textdateien bearbeiten: Nano-Editor

Es gibt viele Texteditoren für Linux. Weit verbreitet sind z.B. **nano** und **vim**, wobei nano der einsteigerfreundlichere Editor ist. Deshalb arbeiten wir im Kurs mit dem nano-Editor.

- Datei im Nano-Editor öffnen: `nano <Dateipfad>/<Dateiname>`

- Navigation erfolgt ohne Maus, nur mit den Pfeiltasten navigieren!

- Datei schließen und speichern: *STRG + X*, dann *J*, dann *ENTER*

- Schließen ohne zu speichern: *STRG + X*, dann *N*

- Komplette Zeile löschen: *STRG + K*

- Kopieren und einfügen wie auf dem Terminal

- Text suchen: *STRG + W*, dann Suchbegriff eingeben oder für weitere Treffer direkt mit *ENTER* bestätigen

- Zu bestimmter Zeile springen: *STRG + /*, dann Zeilennummer eingeben


::::::::::::::::::::::::::::::::::::: keypoints 

- Raspberry Pi OS ist das Linux-Betriebssystem unserer Wahl

- Das Dateisystem unter Linux besteht aus einem einzigen Verzeichnisbaum. "/" ist dabei die obersterte Ebene

- Software wird unter Linux zentral verwaltet. Die Verwaltung erfolgt bei der Debian-Familie mit den Programmen *apt-get* oder *apt*

- Ein Linux-Server wird i.d.R. über die Kommandozeile gesteuert. Dabei erfolgt die Arbeit ohne Maus. Programmsteuerung, Dateioperationen und die Dateierstellung werden per Tastatur erledigt.

::::::::::::::::::::::::::::::::::::::::::::::::

