---
title: 'Hardware und Betriebssystem'
teaching: 45
exercises: 90
---

:::::::::::::::::::::::::::::::::::::: questions 

- Was steht am Anfang eines jeden IT-Projekts?

- Was ist ein Server, was ein Client?

- Welche Betriebssystem-Optionen gibt es für den Raspberry Pi?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Begriffsklärung
- Betriebssystem installieren
- Raspberry Pi zusammenbauen und erstmalig starten
- Erste administrative Schritte mit dem Raspberry Pi

::::::::::::::::::::::::::::::::::::::::::::::::

# Die Hard- und Software

## Hardware
Zu Beginn der meisten IT-Projekte steht die Frage, wo diese Projekte umgesetzt werden sollen. Dabei gibt es heutzutage unterschiedliche Möglichkeiten. Abgesehen von Tests auf lokalen Endgeräten wie PC oder Notebook, werden für viele Projekte spezialisierte Geräte genutzt. Vor allem für Firmen, Rechenzentren und andere Hochleistungsszenarien werden Computer mit spezialisierter Hardware wie Prozessoren, Festplatten oder Arbeitsspeichern eingesetzt, die für diese anspruchsvollen Aufgaben geeignet sind und häufig nicht mit Hardware vergleichbar ist, die in PCs verbaut wird.

Neben eigener Hardware besteht heute auch die Möglichkeit, seine Projekte auf fremder Hardware umzusetzen. Diese fremde Hardware befindet sich in einem entfernten Rechenzentrum ("der Cloud") und ist über das Internet erreich- und steuerbar. Häufig wird die Hardware dabei virtualisiert, d.h. das z.B. die Leistung eines echten Prozessors mithilfe von Software für mehrere virtuelle Computer zur Verfügung gestellt wird.

Für dezentrale Projekte können sogenannte Embedded Devices genutzt werden. Hierbei handelt es sich häufig um Spezialanfertigungen für genau einen Einsatzzweck, z.B. als Kassensystem oder Waage im Supermarkt oder als Informationsdisplay im öffentlichen Raum. Für diese Geräte werden auch spezielle Betriebssysteme und Software eingesetzt.

Für kleinere Projekte wie Heimanwender können normale PCs genutzt werden. Passender für Projekte mit wenig Leistungsanspruch (und im Heimanwenderbereich ist das i.d.R. der Fall) sind Mini-PCs, bei denen sämtliche oder die meisten Bauteile (Prozessor, Arbeitsspeicher, Datenspeicher und externe Schnittstellen wie Netzwerk und USB) auf einer Platine verbaut sind. Diese sogenannten Systems-on-a-Chip (SoC) haben den Vorteil, dass sie besonders energiesparsam sind, wenig Platz benötigen, keinen oder kaum Lärm verursachen und im Vergleich mit herkömmlichen PCs oder gar professionellen Servern deutlich günstiger sind.

## Server vs. Client
Bezogen auf ihre Funktion innerhalb eines Computernetzwerks werden Geräte unterschiedlich bezeichnet:

1. Client

Klassisches Endgerät wie PC, Notebook oder Smartphone. Hat keine zentralen Aufgaben. Ist ein Client-Gerät ausgefallen, ist das Netzwerk nicht betroffen.

2. Server

Übernimmt als Kommunikationsknotenpunkt zentrale Aufgaben im Netzwerk. Je nach Leistungsbedarf wird spezialisierte Hochleistungshardware, normale PCs oder SoCs genutzt. Fällt ein Server aus, fehlt damit i.d.R. eine zentrale Funktion im Netzwerk. Je nachdem welche Aufgaben der Server hat, kann dies zum vollständigen versagen des Netzwerks führen oder nur zur nicht Erreichbarkeit eines Dienstes (z.B. einer Website).

## Software

Unter Software kann all das verstanden werden, was nicht angefasst werden kann. Also sämtlicher Programmcode, der auf einem Computer installiert ist. Dazu gehört sowohl das Betriebssystem, die Boot-Umgebung (welche das Betriebssystem lädt) aber auch alle anderen Programme wie Treiber, eine Firewall, ein Office-Programm oder ein Webserver-Programm.

Möchte man ein bestimmtes IT-Projekt umsetzen und hat die Hardware besorgt, gilt es auch die richtige Software auszuwählen. Hierbei ist zu beachten, dass Hard- und Software miteinander kompatibel sein müssen. Z.B. unterstützt nicht jedes Betriebssystem jede Art von Prozessor (siehe auch diesen [Wikipedia-Artikel](https://de.wikipedia.org/wiki/Prozessorarchitektur). 

Abhängig von den Programmen, die man nutzen möchte, kann das passende Betriebssystem gewählt werden. Für viele Serveranwendungen, wie die in diesem Kurs genutzte Software [Nextcloud][nextcloud], werden Linux-Betriebssysteme empfohlen. In vielen Fällen werden für die Funktion des Hauptprogramms (in unserem Fall Nextcloud) weitere Programme benötigt. Das sind häufig ein [Datenbankmanagementsystem](https://de.wikipedia.org/wiki/Datenbank#Komponenten_eines_Datenbanksystems) wie Mysql oder MariaDB, die Skriptsprache PHP, und ein Webserver wie [Apache2](https://httpd.apache.org/). In dieser Kombination spricht man auch von einem LAMP-Stack (**L**inux, **A**pache, **M**ysql/**M**ariaDB und **P**HP).

Die genauen Anforderungen an die Hard- und Software sind häufig den Handbüchern der Programme zu entnehmen. Allerdings hängt die richtige Wahl auch von der Intensivität der Nutzung, persönlichen Vorlieben oder Vorgaben innerhalb einer Organisation ab.

::::::challenge
### System requirements

Szenario: Sie wollen für eine kleine Forschungsgruppe (ca. 10 Personen) eine Datenmanagement-Lösung betreiben und als Serversoftware [Nextcloud][nextcloud] installieren.

Welche Hardware wählen Sie dafür? Schauen Sie sich dafür die [System requirements](https://docs.nextcloud.com/server/latest/admin_manual/installation/system_requirements.html) von Nextcloud an und wählen Sie aus einer der folgenden Hardware-Optionen:

1. [Raspberry Pi 4](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/) mit 8GB RAM für ca. 100€ und einer externen [2 TB USB-HDD-Festplatte](https://www.idealo.de/preisvergleich/OffersOfProduct/204400140_-mysafe-advance-3-5-usb-3-0-2tb-i-tec.html)

2. [Raspberry Pi 5](https://www.raspberrypi.com/products/raspberry-pi-5/) mit 8GB RAM für ca. 110€ und einer [2 TB SSD-Festplatte](https://geizhals.de/crucial-p310-ssd-2tb-ct2000p310ssd2-a3234426.html?hloc=at&hloc=de)

3. [Odroid H4 Ultra](https://www.hardkernel.com/shop/odroid-h4-ultra/) mit einer [2 TB SSD-Festplatte](https://geizhals.de/crucial-p310-ssd-2tb-ct2000p310ssd2-a3234426.html?hloc=at&hloc=de)

4. Einen Tower Server [SR10766 der Intel Xeon E-2400 Serie](files/server-angebot.pdf)

:::solution
Die genauen Hardwareanforderungen sind (v.a. am Anfang des Projekts und ohne Vorkenntnisse) schwer abzuschätzen. Geeignete Lösungen können aber die Nummern 2. und 3. sein. Die Nummer 4 wäre überdimensioniert und mit der Nummer 1. kommt das System an seine Grenzen. Auch der Raspberry Pi 5 ist für 10 Personen vermutlich zu schwach. Das hängt aber stark von der Art und Intensivität der Nutzung ab.
:::
::::::

# Praktische Umsetzung

Im Folgenden werden die Schritte zur praktischen Umsetzung erklärt. Diese können gemeinsam während der Präsenzsitzungen oder selbstständig durchgeführt werden.

## Installation des Betriebssystems

Für unser Projekt nutzen wir als Hardware den Raspberry Pi 4 oder 5. Als Betriebssystem installieren wir das offizielle Betriebssystem des Herstellers: [Raspberry Pi OS 64-Bit][raspberrypios]. Dabei handelt es sich um ein Linux-Betriebssystem aus der Reihe der Debian-Linux-Systeme. Damit ist unser System sehr ähnlich zu den Linux-Betriebssystemen Debian, Ubuntu oder Linux Mint.

Grundlegend können auf einem Raspberry Pi unterschiedliche Betriebssystem installiert werden. Sie müssen jedoch mit dem ARM-Prozessor kompatibel sein. Möglich sind z.B. Ubuntu, Windows, viele Linux-Distribution oder Spezialanwendungen wie [LibreElec](https://libreelec.tv/) als Medienstreaming-Server.

Für die Installation des Betriebssystems wird vom Hersteller der Hardware das Programm [Raspberry Pi Imager](https://www.raspberrypi.com/software/) zur Verfügung gestellt. Dieses wird auf dem eigenen (Windows, Linux)-PC oder Mac installiert. Anschließend kann damit das Betriebssystem auf die SD-Karte oder Festplatte des Raspberry Pi geschrieben werden.

### Vorgehen:

1. Betriebssystem auswählen: Rapsberry Pi OS 64 Bit

![Raspberry Pi Imager mit ausgewähltem Betriebssystem (hier in der 32 Bit-Variante).](fig/02_imager_write.png){alt='Startbildschirm des Raspberry Pi Imager. Es ist zu sehen, dass als Betriebssystem das Raspberry Pi OS 32 Bit ausgewählt ist'}

2. Speicher auswählen: die SD-Karte muss im PC eingesteckt sein und nun ausgewählt werden.

3. Über das Zahnradsymbol die erweiterten Einstellungen öffnen

![Erweiterte Einstellungen des Raspberry Pi Imager](fig/02_imager_settings.png){alt='Startbildschirm des Raspberry Pi Imager. Es ist zu sehen, dass als Betriebssystem das Raspberry Pi OS 32 Bit ausgewählt ist'}

4. Folgende Optionen einstellen:

    1. Hostname: ein Name für deinen Raspberry Pi (keine Sonderzeichen, keine Leerzeichen)
  
    2. *SSH aktivieren* auswählen
  
    3. Benutzername und Passwort festlegen (und merken!)
  
    4. WLAN-Zugang konfigurieren
  
    5. Spracheinstellungen festlegen: *Europe/Berlin* und *de*
  
    6. Telemetrie deaktivieren

5. Inhalte mit dem *Schreiben* Button auf die SD-Karte schreiben

## Hardware zusammen bauen

1. Gehäuse öffnen (Pfeile am Deckel beachten)

2. Raspberry Pi Board auf die Zapfen des Gehäuses setzen

3. Wenn noch nicht geschehen: Kühlkörper aufkleben

4. Gehäuse schließen und falls vorhanden zuvor den Lüfter einsetzen

5. Netzkabel und HDMI-Kabel anschließen (noch nicht mit dem Stromnetz verbinden)

6. SD-Karte einsetzen

7. Monitor verbinden

8. Maus und Tastatur anschließen

9. Netzteil in die Steckdose stecken

## Erster Start

Der erste Start ist i.d.R. etwas langsam, da im Hintergrund noch ein paar einmalige Prozesse ablaufen. Diesen Startvorgang einfach abwarten, bis der Desktop des Raspberry Pi OS erscheint.

Nun können erste Grundeinstellungen vorgenommen werden:

1. Im Hauptmenü (oben links) unter Einstellungen auf Raspberry Pi Konfiguration gehen

  1. Autologin deaktivieren
  
  2. Interfaces: SSH aktivieren (wenn noch nicht passiert)
  
  3. Performance: ggf. Raspberry Pi Lüfter konfigurieren
  
  4. Localisation: ggf. Sprache einstellen
  
2. Bluethooth ausschalten (Symbol oben rechts)

Der Raspberry Pi ist nun grundlegend eingerichtet und einsatzbereit. Die Nutzung unterscheidet sich hierbei zunächst nicht von einem herkömmlichen PC. In den folgenden Lektionen wird der Mini-Computer jedoch in seiner Funktionalität erweitert, um als Server genutzt werden zu können.

# Weitere Quellen

- Empfehlung: [Grundlagen mit der Linux-Kommandozeile](https://dr-eberle-zentrum.github.io/DataBASHing/basics.html) aneignen

- [Youtube: Raspberry Pi Basisinformation](https://www.youtube.com/watch?v=uXUjwk2-qx4&t=103s)

- [Elektronik-Kompendium: Raspberry Pi Grundkonfiguration](https://www.elektronik-kompendium.de/sites/raspberry-pi/2002221.htm)
  
::::::::::::::::::::::::::::::::::::: keypoints 

- Für viele Heimanwender und Kleinprojekte reichen Mini-PCs (SoC) aus.
- Für große Projekte wird spezialisierte Serverhardware benötigt
- In diesem Kurs wird auf einem Raspberry Pi mit Linux-Betriebssystem die Cloud-Software [Nextcloud][nextcloud] installiert. 
- Die Installation des Betriebssystems erfolgt mit dem Raspberry Pi Imager
- Der Raspberry Pi mit dem Raspberry Pi OS kann sowohl wie ein herkömmlicher PC, als auch wie ein Server genutzt werden

::::::::::::::::::::::::::::::::::::::::::::::::

