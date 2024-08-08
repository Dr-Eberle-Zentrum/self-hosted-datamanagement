---
title: 'Hardware und Betriebssystem'
teaching: 45
exercises: 90
---

:::::::::::::::::::::::::::::::::::::: questions 

- Was steht am Anfang eines jeden IT-Projekts?

- Welche Betriebssystem-Optionen gibt es?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Raspberry Pi Set zusammen bauen
- Raspberry Pi erstmalig starten
- Erste administrative Schritte mit dem Raspberry Pi

::::::::::::::::::::::::::::::::::::::::::::::::

# Die Hard- und Software

## Hardware
Zu Beginn der meisten IT-Projekte steht die Frage, wo diese Projekte umgesetzt werden sollen. Dabei gibt es heutzutage unterschiedliche Möglichkeiten. Abgesehen von Tests auf lokalen Endgeräten wie PC oder Notebook, werden für viele Projekte spezialisierte Geräte genutzt. Vor allem für Firmen, Rechenzentren und andere Hochleistungsszenarien werden hierfür Computer mit Prozessoren, Festplatten, Arbeitsspeichern und anderer Hardware eingesetzt, die für diese anspruchsvollen Aufgaben geeignet sind.

Für dezentrale Projekte können sogenannte Embedded Devices genutzt werden. Hierbei handelt es sich häufig um Spezialanfertigungen für genau einen Einsatzzweck, z.B. als Kassensystem oder Waage im Supermarkt oder Informationdisplays im öffentlichen Raum. Für diese Geräte werden auch spezielle Betriebssysteme und Software benötigt.

Für kleinere Projekte wie Heimanwender können normale PCs genutzt werden. Passender für Projekte mit wenig Leistungsanspruch (und im Heimanwenderbereich ist das i.d.R. der Fall) sind Mini-PCs, bei denen sämtliche oder die meisten Bauteile (Prozessor, Arbeitsspeicher, Datenspeicher und externe Schnittstellen wie Netzwerk und USB) auf einer Platine verbaut sind. Diese sogenannten Systems-on-a-Chip (SoC) haben den Vorteil, dass sie besonders energiesparsam sind, wenig Platz benötigen, keinen oder kaum Lärm verursachen und im Vergleich mit herkömmlichen PCs oder gar professionellen Servern deutlich günstiger sind.

## Server vs. Client
Bezogen auf ihre Funktion innerhalb eines Computernetzwerks werden diese Gerät unterschiedlich bezeichnet:

1. Client

Klassische Endgerät wie PC, Notebook oder Smartphone. Hat keine zentralen Aufgaben. Ist ein Client-Gerät ausgefallen, ist das Netzwerk nicht betroffen.

2. Server

Übernimmt als Kommunikationsknotenpunkt zentrale Aufgaben im Netzwerk. Je nach Leistungsbedarf wird spezialisierte Hochleistungshardware, normale PCs oder SoCs genutzt. Fällt ein Server aus, fehlt damit i.d.R. eine zentrale Funktion im Netzwerk. Je nachdem welche Aufgaben der Server hat, kann dies zum vollständigen versagen des Netzwerks führen oder nur zur nicht Erreichbarkeit eines Dienstes (z.B. einer Website).

## Software

Unter Software kann all das verstanden werden, was nicht anfassbar ist. Also sämtlicher Programmcode, der auf einem Computer installiert ist. Dazu gehört sowohl das Betriebssystem, die Boot-Umgebung (welche das Betriebssystem lädt) aber auch alle anderen Programme wie Treiber, eine Firewall, ein Office-Programm oder ein Webserver-Programm.

Möchte man ein bestimmtes IT-Projekt umsetzen und hat die Hardware besorgt, gilt es auch die richtige Software auszuwählen. Hierbei ist zu beachten, dass Hard- und Software miteinander kompatibel sein müssen. Z.B. unterstützt nicht jedes Betriebssystem jede Art von Prozessor. 

Abhängig von den Programmen, die man nutzen möchte, kann das passende Betriebssystem gewählt werden. Für viele Serveranwendungen, wie die in diesem Kurs genutzte Software [Nextcloud][nextcloud], werden Linux-Betriebssysteme empfohlen. In vielen Fällen werden für die Funktion des Hauptprogramms (in unserem Fall Nextcloud) weitere Programme benötigt. Das sind häufig ein [Datenbankmanagementsystem](https://de.wikipedia.org/wiki/Datenbank#Komponenten_eines_Datenbanksystems) wie Mysql oder MariaDB, die Skriptsprache PHP, und ein Webserver wie [Apache2](https://httpd.apache.org/). In dieser Kombination spricht man auch von einem LAMP-Stack (**L**inux, **A**pache, **M**ysql/**M**ariaDB und **P**HP).

Die genauen Anforderungen an die Hard- und Software sind häufig den Handbüchern der Programme zu entnehmen. Allerdings hängt die richtige Wahl auch von der Intensivität der Nutzung, persönlichen Vorlieben oder Vorgaben innerhalb einer Organisation ab.

::::::challenge
### System requirements

Szenario: Sie wollen für eine kleine Forschungsgruppe (ca. 10 Personen) eine Datenmanagement-Lösung betreiben und als Serversoftware [Nextcloud][nextcloud] installieren.

Welche Hardware wählen Sie dafür? Schauen Sie sich dafür die [System requirements](https://docs.nextcloud.com/server/latest/admin_manual/installation/system_requirements.html) von Nextcloud an und wählen Sie aus einer der folgenden Hardware-Optionen:

1. [Raspberry Pi](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/) 4 mit 8GB RAM und einer externen [2 TB USB-HDD-Festplatte](https://www.idealo.de/preisvergleich/OffersOfProduct/204400140_-mysafe-advance-3-5-usb-3-0-2tb-i-tec.html)

2. [Raspberry Pi 5](https://www.raspberrypi.com/products/raspberry-pi-5/) mit 8GB RAM und einer [2 TB SSD-Festplatte](https://geizhals.de/crucial-p310-ssd-2tb-ct2000p310ssd2-a3234426.html?hloc=at&hloc=de)

3. [Odroid H4 Ultra](https://www.hardkernel.com/shop/odroid-h4-ultra/) mit [2 TB SSD-Festplatte](https://geizhals.de/crucial-p310-ssd-2tb-ct2000p310ssd2-a3234426.html?hloc=at&hloc=de)

4. Einen Tower Server ![SR10766 der Intel Xeon E-2400 Serie](files/server-angebot.pdf)

:::solution
Die genauen Hardwareanforderungen sind (v.a. am Anfang des Projekts und ohne Vorkenntnisse) schwer abzuschätzen. Geeignete Lösungen können aber die Nummern 2. und 3. sein. Die Nummer 4 wäre überdimensioniert und mit der Nummer 1. kommt das System an seine Grenzen. Auch der Raspberry Pi 5 ist für 10 Personen vermutlich zu schwach. Das hängt aber stark von der Art und Intensivität der Nutzung ab.
:::
::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- Hardwareaufbau: Fingerspitzengefühl ist gefragt. 
- Kühlung: insbesondere beim Raspberry Pi 5 ist eine aktive Kühlung empfehlenswert, ansonsten können Kühlkörper ausreichen
- Der Raspberry Pi ist zunächst wie ein normaler Desktop-PC zu bedienen

::::::::::::::::::::::::::::::::::::::::::::::::

