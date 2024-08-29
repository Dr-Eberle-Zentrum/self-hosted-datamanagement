---
title: 'Installationsvorbereitung 1'
teaching: 45
exercises: 90
---

:::::::::::::::::::::::::::::::::::::: questions 

- Wie kann ich Datenverlust vermeiden?

- Wie kann ich meinen Speicherplatz erweitern?

- Wie beginne ich die Installation von Nextcloud?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Backups des gesamten Betriebssystems erstellen

- Dateisysteme erstellen und einbinden

- Programmkomponenten von Nextcloud verstehen
::::::::::::::::::::::::::::::::::::::::::::::::

## Systembackup

Nachdem der Raspberry Pi in den bisherigen Lektionen grundlegend eingerichtet wurde, empfiehlt es sich nun den aktuellen Stand zu sichern. Dadurch besteht später die Möglichkeit diese Sicherung wieder herzustellen für den Fall, dass bei der weiteren Arbeit etwas schief geht.

Um das gesamte System zu sichern, muss die SD-Karte (bzw. der Datenträger auf welchem das System installiert ist) geklont werden. Dabei wird ein Image aller Partitionen erstellt. Dieses kann später wie das Image eines Betriebssystems neu auf die SD-Karte installiert werden. Um alle Daten sauber kopieren zu können, muss der Raspberry Pi heruntergefahren werden und anschließend wird SD-Karte mit Hilfe eines anderen Computers kopiert. Je nach Betriebssystem dieses anderen Computers bestehen unterschiedliche Möglichkeiten. Nachfolgend werden für jedes Betriebsystem eine Möglichkeit vorgestellt.

:::tab
### Windows

Unter Windows kann das Programm Win32 Disk Imager genutzt werden. Das Programm ist etwas in die Jahre gekommen, funktioniert aber noch. Das Programm kann bei [Sourceforge](https://sourceforge.net/projects/win32diskimager/) heruntergeladen werden. Nach der Installation wird die SD-Karte mit dem PC verbunden und anschließend in Win32 Disk Imager als *Datenträger* ausgewählt, ein Speicherpfad für das Backup angegeben (Dateiendung: .img) und der Datenträger eingelesen. Anschließend ist die Backup-Datei genau so groß wie der gesamte gesicherte Datenträger, da auch der freie Speicherplatz mitgesichert wurde. Deshalb empfiehlt es sich die Datei mit 7Zip oder anderen Kompressionsprogrammen zu komprimieren.

![SD-karte mit Win 32 Disk Imager sichern: 1. Speicherpfad angeben, 2. Datenträger wählen, 3. Lesen-Button betätigen](fig/07_Win32_Disk_Imager.png){alt='Screenshot des Win32 Disk Imagers. Mit Nummern werden die einzelen Schritte hervorgehoben, die nötig sind, um ein Backup zu erstellen. 1. Speicherpfad angeben, zweitens Datenträger wählen, drittens Lesen-Button betätigen'}

### Linux

Für Linux steht das Kommandozeilen-Programm **dd** zu Verfügung. Damit kann das Image erstellt und gleichzeitig kopiert werden. Oder die Schritte werden nach einander ausgeführt.

- In einem Schritt: `dd if=/dev/sdb | gzip > /Home/User/Desktop/backup.gz`

Dabei ist */dev/sdb* der Pfad zur Gerätedatei der SD-Karte

- In zwei Schritten (evtl. sinnvoll, wenn die Geschwindigkeit zu langsam ist, benötigt aber mehr (temporären) Speicherplatz): `dd if=/dev/sdb of=/Home/User/Desktop/backup.img bs=1M` und `gzip /Home/User/Desktop/backup.img`

Eine Anleitung zu dd findet sich z.B. bei [Bitblokes.de](https://www.bitblokes.de/sd-karte-des-raspberry-pi-sichern-dd-oder-partclone/)

### MacOS

Für MacOS steht das Kommandozeilen-Programm **dd** zu Verfügung. Damit kann das Image erstellt und gleichzeitig kopiert werden. Oder die Schritte werden nach einander ausgeführt.

- In einem Schritt: `dd if=/dev/sdb | gzip > /Home/User/Desktop/backup.gz`

Dabei ist */dev/sdb* der Pfad zur Gerätedatei der SD-Karte

- In zwei Schritten (evtl. sinnvoll, wenn die Geschwindigkeit zu langsam ist, benötigt aber mehr (temporären) Speicherplatz): `dd if=/dev/sdb of=/Home/User/Desktop/backup.img bs=1M` und `gzip /Home/User/Desktop/backup.img`

Eine Anleitung zu dd findet sich z.B. bei [Bitblokes.de](https://www.bitblokes.de/sd-karte-des-raspberry-pi-sichern-dd-oder-partclone/)

:::

## Externer Speicher

Aktuell verfügt der Raspberry Pi nur über den Speicherplatz auf der SD-Karte. Dieser Speicherplatz kann schnell ausgehen, wenn größere Datenmengen im Cloudserver gespeichert werden sollen. Außerdem ist eine SD-Karte kein verlässliches Speichermedium. Deshalb kann es empfehlenswert sein, mit Hilfe zusätzlicher Speichermedien den Speicherplatz zu erweitern.

An den USB-Ports können externe Datenträger angeschlossen werden. Dies können USB-Sticks, HDD-Festplatten (mit eigener Stromversorgung) oder USB-SSD-Festplatten sein. Der Raspberry Pi 5 bietet außerdem über die PCIe 2.0-Schnittstelle die Möglichkeit mit Hilfe eines M.2-Zusatzmoduls eine NVMe-SSD anzuschließen (Details dazu siehe [Raspberrypi.com](https://www.raspberrypi.com/products/m2-hat-plus/)).

### Festplatten einbinden (*mounten*):

Damit der externer Datenträger vom Betriebssystem verwendet werden kann, muss dieser an einer zu definierenden Stelle des Verzeichnissbaums eingebunden werden. Dieser Vorgang wird als **mounten** oder **einhängen** bezeichnet. Dies erfolgt zunächst einmalig und nachdem ein Dateisystem auf dem Datenträgererstellt wurde dauerhaft:

- Aktuelle Laufwerke identifizieren: `lsblk`

- Externen Datenträger verbinden

- erneut Laufwerke identifizieren: `lsblk` Der neue Datenträger sollte auftauchen und mit einem Pfad ähnlich `/dev/sda` oder `/dev/nvme/` erscheinen

- Partition erstellen: `sudo fdisk /dev/sda` (dabei muss /dev/sda an den eigenen Datenträger angepasst werden)

- Im folgenden interaktiven Dialog von fdisk wird mit `g` eine GPT-Partitionstabelle erstellt, mit `n` eine neue Partition und mit `w` werden die Änderungen auf den Datenträger geschrieben

- Auf der neuen Partition ein (linuxkompatibles ext4-)Dateisystem erstellen: `sudo mkfs.ext4 /dev/sda` (Pfade wieder anpassen)

- Mountpoint (Einhängepunkt für den Datenträger) erstellen: `sudo mkdir /mnt/data` (Pfad ggf. nach eigenen Wünschen anpassen)

- Datenträger mounten: `sudo mount /dev/sda1 /mnt/data` 

Zu diesem Vorgang finden sich im Netz auch diverse Anleitungen, z.B. bei [basic-tutorials.de](https://basic-tutorials.de/ratgeber/software/usb-datentraeger-mit-dem-raspberry-pi-formatieren-und-verbinden/)

Beim Elektronikkompendium findet sich noch mehr zum Thema [Festplatten](https://www.elektronik-kompendium.de/sites/com/0610291.htm), [Partitionen](https://www.elektronik-kompendium.de/sites/com/0705011.htm) und [Mounting](https://www.elektronik-kompendium.de/sites/raspberry-pi/2102191.htm).


Nachdem das Dateisystem erstellt und einmalig gemountet ist, muss dies noch dauerhaft gemacht werden. Denn das mounten über `mount /dev/sdx` geht bei einem Neustart des Gerätes verloren und Referenzen, z.B. aus dem Cloudserver, auf den externen Datenträger wären ungültig. Um Datenträger dauerhaft unter dem gleichen Dateipfad verfügbar zu machen, müssen diese Datenträger mit ihrem *unversal unique identifier*, oder kurz **UUID** in der Datei **`/etc/fstab`** eingetragen werden:

- UUID herausfinden und notieren oder in die Zwischenablage kopieren: `sudo blkid` 

- In der Datei `/etc/fstab` eine neue Zeile ergänzen:

```
UUID=<kopierte UUID> /<Pfad>/<zum>/<Mountpoint>   ext4    auto,nofail,noatime,users,rw    0   0
```

Dadurch wird der Datenträger bei jedem Neustart und beim ausführen des Befehls `sudo mount -av` im angegeben Pfad eingehängt. Es wird außerdem das Dateisystem genannt (ext4) und einige Optionen mitgegeben. z.B. bedeutet die Option *nofail*, dass das Betriebssystem auch dann startet, wenn der externe Datenträger nicht angeschlossen ist.

- Nachdem der Eintrag in der *fstab-Datei* erstellt ist, wird das mounten getestet: `sudo mount -av`

- Nach einem Neustart kann mit `sudo df -h` überprüft werden, ob der externe Datenträger richtig eingebunden wurde.

Weitere Anleitungen zum dauerhaften einbindinden von Datenträgern finden sich z.B. beim [Elektronikkompendium](https://www.elektronik-kompendium.de/sites/raspberry-pi/2012181.htm) oder bei [PiMyLifeUp](https://pimylifeup.com/raspberry-pi-mount-usb-drive/).

## Grundlagen der Installation

Vor jeder (größeren) Installation, sollte das Handbuch der Software studiert werden. Da in diesem Kurs die Software Nextcloud als Dateispeicher- und Kollaborationsdienst installiert werden soll, sollte das [Nextcloud Administration Manual][nextcloud-doc] studiert werden.

:::::: challenge
### Installationsvarianten

Informieren Sie sich über die Installationsvarianten von Nextcloud. Ein Einstiegspunkt ist das Kapitel [Installation on Linux](https://docs.nextcloud.com/server/stable/admin_manual/installation/source_installation.html). Empfehlenswert ist auch das Lesen des Kapitels [Example installation on Ubuntu 22.04 LTS](https://docs.nextcloud.com/server/stable/admin_manual/installation/example_ubuntu.html).

Welche der im Handbuch erwähnten Installationsvarianten erscheint Ihnen für das Raspberry Pi Projekt am sinnvollsten?

::: solution
Für den Raspberry Pi gibt es ein von der Community betriebens Projekt: [NextcloudPi](https://nextcloudpi.com/). Damit kann sehr schnell auf einem Raspberry Pi (oder vergleichbaren Systemen) ein Nextcloud-Server installiert werden. Der Nachteil ist jedoch eine etwas eingeschränkte Konfigurierbarkeit, da hier alles sozusagen "auf einen Klick" gemacht wird. Dadurch ist auch der Lernerffekt deutlich verringert.

Grundlegend sind auch die Optionen mit Docker eine gute Option. Hier steht ein offizielles Image zur Verfügung ([Nextcloud AIO](https://github.com/nextcloud/all-in-one#nextcloud-all-in-one)), das allerdings auch wieder vorgefertigt und daher weniger Anpassbar ist. Da Docker jedoch noch einmal eine weitere Komplexitätsschicht hinzufügt und v.a. dann interessant ist, wenn auf einem Computer mehrere Dienste betrieben werden, wird diese Variante hier nicht weiter verfolgt.

Als empfehlenswerte Variante für diesen Kurs wird die manuelle Installation gewählt. Dies hat den Vorteil, dass damit das gesamte System nach den eigenen Wünschen angepasst werden kann und dadurch auch ein hoher Lerneffekt zustande kommt.
:::
::::::

### Komponenten

Der Nextcloud-Server besteht aus mehreren Komponenten. Nextcloud selbst ist dabei nur ein Teil. Für die Funktionalität werden jedoch noch eine Datenbank, ein Webserver und ein Datenverzeichnis benötigt. Außerdem kann später mithilfe von Apps die Funktionalität erweitert werden.

Table: Nextcloud-Komponenten

|Komponente|Funktion|Hinweis|
|-------|-------|-------------|
|Nextcloud-Server|die Hauptsoftware|Kernprogramm zur Datenverwaltung und Steuerung|
|Datenbank|Speichert Benutzer, History, Metadaten u.v.m.|SQLite für Testzwecke, MariaDB oder PostgreSQL für produktiven Einsatz|
|Webserver|Koordiniert Kommunikation|z.B. Apache oder NGINX; steuert Anfragen und Antworten, verschlüsselt die Kommunikation|
|Datenverzeichnis|Speicherort der Clouddaten|Es sind verschiedene Verzeichnisse und Speichertechnologien möglich|
|Apps|Funktionserweiterung|Zahlreiche Möglichkeiten im [Nextcloud App store](https://apps.nextcloud.com/)|

::::::::::::::::::::::::::::::::::::: keypoints 
- Zur Sicherung des gesamten Systems kann die SD-Karte an einem zweiten PC geklont werden

- Datenträger können unter Linux an einer beliebigen Stelle des Verzeichnisses Baumes eingehängt werden

- Einmaliges mounten erfolgt mit dem `mount`-Befehl, dauerhaftes mounten durch Eintragung in der Datei `/etc/fstab`

- Nextcloud bietet unterschiedliche Installationsvarianten- und Komponenten. In diesem Kurs wird die manuelle Installation mit MariaDB und Apache gewählt.

::::::::::::::::::::::::::::::::::::::::::::::::

