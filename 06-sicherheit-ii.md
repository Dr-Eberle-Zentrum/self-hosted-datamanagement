---
title: 'Sicherheit: Firewall und Fail2Ban'
teaching: 45
exercises: 90
---

:::::::::::::::::::::::::::::::::::::: questions 

- Wie kommunizieren Computer im Netzwerk?

- Wie schütze ich meinen Server im Netzwerk?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Grundlagen der Netzwerkkommunikation verstehen

- Eine einfache Firewall einrichten

- Fehlerhafte Logins mit Fail2Ban überwachen

::::::::::::::::::::::::::::::::::::::::::::::::

## Netzwerkkommunikation

### OSI-Referenz-Modell

Um allgemeine Leitlinien für Hersteller von Hard- und Software zu etablieren, wurde das OSI-Referenz-Modell entwickelt, welches die Kommunikationsabläufe in Computernetzwerken definiert. Gemäß dem Modell läuft ein Datenpaket beim Sender durch sieben Kommunikationsschichten und beim Empfänger wieder durch die selben Schichten, allerdings in umgekehrter Reihenfolge. Jede dieser Schichten hat klar definierte Aufgaben und spezifische Protokolle. Ein Datenpaket wird dabei in einer Schicht verarbeitet, z.B. in der obersten Schicht (*Anwendungsschicht*) per HTTP abgerufen und dann an die nächste Schicht übergeben. Dort werden weitere Schritte unternommen. Z.B. könnte das jetzt fertig geschnürte HTTP-Paket zu einem HTTPS-Paket verschlüsselt werden. Am untersten Ende (auf der *Bitübertragungsschicht*) wird schließlich nur noch festgelegt, wie der Strom über die Leitung fließt.

Da auf jeder Schicht beim Sender weitere Informationen zum Datenpaket hinzugefügt werden (z.B. eine Veschlüsselung oder die IP-Adresse des Empfängers) wird das Datenpaket immer größer (sog. Overhead). Beim Empfänger wird das Paket wieder Schritt für Schritt "ausgepackt".

Eine ausführliche Erklärung zum OSI-Modell inkl. Video findet sich bei [Studyflix](https://studyflix.de/informatik/osi-modell-5524).

### IP-basierte Netzwerke

Um Kommunikationspartner im Netzwerk zu identifizieren, besitzt jedes Netzwerkfähige Gerät (genauer gesagt: jedes Netzwerinterface) eine Hardwareadresse: die **MAC-Adresse**. Die MAC-Adresse ist auf Schicht 2 des OSI-Modells definiert. Um nun zu definieren, wo sich diese MAC-Adresse im Netzwerk befindet, werden in Schicht 3 des OSI-Modells **IP-Adressen** eingeführt. Mit IP-Adressen werden zunächst logische Netzwerksegmente definiert. Dabei wird jedes Netzwerk mit einer IP-Adresse beschrieben. Diese Netzwerkadresse ist der Startpunkt des Netzwerkes (z.B. `192.168.178.0`). Mit der Subnetzmaske wird die Anzahl an möglichen Adressen innerhalb des Netzwerks festlegt (z.B. `255.255.255.0` oder in Kurzform `/24` für ein Netzwerk mit max. 254 Geräten). Innerhalb eines Netzwerks werden einzelne Geräte durch eine IP-Adresse definiert (z.B. 192.168.178.25). Wandert das Gerät in ein anderes Netzwerksegment erhält es eine andere IP-Adresse.

Um eine Kommunikation zwischen verschiedenen Netzwerken (z.B. einem Heimnetzwerk mit der Adresse 192.168.178.0 und der Subnetzmaske 255.255.255.0 und dem Internet) zu ermöglichen, wird ein Standardgateway benötigt. Dies ist i.d.R. die IP-Adresse des Routers. An diesen werden alle Pakete geschickt, die keine Adresse im lokalen Netzwerk haben, und werden dann z.B. ins Internet weiter geleitet.

Es werden unterschiedliche Typen von Netzwerken unterschieden: Private Netzwerke und öffentliche Netzwerke. Private Netzwerke sind nicht öffentlich erreichbar und sind durch Router und Firewalls von öffentlichen Netzwerken getrennt. Dadurch können private Netzwerke mit derselben IP-Adresskonfiguration mehrfach existieren, da sie sich gegenseitig nicht "sehen". 

Folgende Adressbereiche für private Netzwerke gibt es:

Table: Private Adressbereiche und spezielle Netzwerke

| Netzadressbereich   |   Subnetzmaske    | Max. Anzahl Geräte    |Bedeutung   |
|-----------------    |:---------   | :------ |--------------------------|
|10.0.0.0 bis 10.255.255.0 | 255.0.0.0 | 16777216 | Privates Netzwerk |
|172.16.0.0 bis 172.31.255.255 | 255.240.0.0 | 1048576 | Privates Netzwerk |
|192.168.0.0 bis 192.168.255.255 | 255.255.0.0 | 256 | Privates Netzwerk |
|169.254.0.0 bis 169.254.255.255 | 255.255.0.0 | 65536 | Link Local/APIPA = Standardbereich, wenn automatische Adresszuweisung fehlschlägt |
|127.0.0.1 bis 127.255.255.254 | 255.0.0.0 | 16777216 | Loopback-Adresse für Kommunikation innerhalb eines Geräts |

:::::: challenge
### IP-Adressen
Werden zentrale Dienste betrieben oder genutzt, muss man sich auch mit dem zugrunde liegenden Netzwerk befassen. Informieren Sie sich deshalb über Ihr Netzwerk:

- Welche IP-Adresse hat Ihr Computer?

- Wie lautet die Subnetzmaske?

- Welche IP-Adressen können Geräte in Ihrem Netzwerk erhalten?

- Welche IP-Adressen hat Ihr Router?

::: solution
Typische Adressen könnten wie folgt lauten:

- IP-Adresse: 192.168.178.25

- Subnetzmaske: 255.255.255.0

- Daraus folgt der Adressbereich 192.168.178.1 bis 192.168.178.254 (die erste Adresse ist als Netzwerkadresse und die letzte als sogenannte Broadcastadresse reserviert und nicht für Geräte verfügbar).

- Router geben sich meistens selbst die erste Adresse im Netzwerk, in diesem Beispiel also 192.168.178.1. Zusätzlich erhält der Router auch eine IP-Adresse im Netzwerk des Internetanbieters. Erst dadurch, dass der Router in beiden Netzwerken eine Adresse hat, kann er auch Datenpakete zwischen den Netzwerken verteilen.
:::
::::::

### Ports

Ist ein Datenpaket innerhalb eines IP-Netzwerks an einem Host (also einem Gerät) angekommen, muss noch geklärt werden, wohin das Paket innerhalb des Geräts gehört. Da auf einem Computer viele Programme gleichzeitig aktiv sind, muss entschieden werden, für welches der Programme ein Paket gedacht ist. Dazu werden **Ports** genutzt. Ein Programm, welches Daten aus dem Netzwerk empfangen soll, nutzt dabei einen bestimmten Port. Kommt am Gerät ein Datenpaket an, das mit dem Port des Programms adressiert ist, wird das Paket an das entsprechende Programm geleitet und von diesem verarbeitet. Zum Beispiel "lauscht" der SSH-Server standardmäßig auf Port 22 für eingehenden Datenverkehr. Wir haben diesen Port in [Lektion 4](04-remote-access.Rmd) manuell abgeändert.

Einige Ports sind fest für bestimmte Programme definiert und sollten nicht von anderen Programmen oder manuell belegt werden. Andere Ports können jedoch von Systemadministratoren frei genutzt werden. Die Portnummern reichen von 0 bis 65.535. Eine Auflistung aller Ports findet sich bei [Wikipedia](https://de.wikipedia.org/wiki/Liste_der_standardisierten_Ports).

Ein Port kann auf einem Gerät offen oder geschlossen sein, z.B. kann eine Firewall die Kommunikation über einen Port blockieren. Außerdem muss ein Prozess hinter einem Port "hören", damit eine Kommunikation aufgebaut werden kann. 

Um zu sehen, welche Prozesse auf welchen Ports hören, kann der Befehl `netstat -tulp` ausgeführt werden. Vorher muss dafür das Paket *net-tools* installiert werden.

## Firewall

Um Kommunikation in einem Netzwerk zu kontrollieren, werden Firewalls eingesetzt. Zu unterscheiden ist hierbei zwischen *Hardware- und Desktopfirewalls.* Eine Hardware- oder auch externe Firewall ist in der Regel ein dediziertes Gerät, welches primär unterschiedliche Netzwerke trennt. In einfacher Form kommt ein Heimrouter wie eine Fritz.Box dieser Aufgabe nach. Denn der Router trennt mit seiner Firewall das Internet vom Heimnetz und verhindert dadurch, dass aus dem Internet auf Geräte im Heimnetzwerk zugegriffen werden kann. In komplexeren Netzwerken (z.B. in Unternehmen) werden professionellere Geräte eingesetzt, welche mehr Funktionalität bieten.

Eine Desktop- oder auch personal firewall dagegen ist meistens in Form von Software auf einem Gerät installiert. Unter Microsoft Windows wäre dies die Windows Defender Firewall, die den PC vor Zugriffen aus einem angeschlossenen Netzwerk schützt. Unter Linux kann dafür die **uncomplicated firewall** (kurz: UFW) genutzt werden.

### Funktionsweise

Vereinfacht kann die Funktionsweise einer Firewall in mehrere Bereiche unterteilt werden. Dabei unterstützt nicht jede Firewall alle dieser Funktionen.

- Paketfilter: filtert nach Adressen der Datenpakete (IP-Adressen, MAC-Adressen, Ports, URLs) -> **Wer darf wohin?**

- Content/Proxy/Deep Packet-Filter: filtert nach dem Inhalt und kann so spezifische Inhalte blockieren. Z.B. kann Malware erkannt werden -> **Was darf unterwegs sein?**

- Kombinierte Filter: durch die Kombination verschiedener Kriterien wie Uhrzeit, Herkunft der Anfrage, Ziel der Anfrage oder die Häufigkeit der Anfrage kann Datenverkehr blockiert oder erlaubt werden -> **wie darf etwas unterwegs sein?**

- Geoblocking: häufig bieten Firewalls auch die Möglichkeit, Anfragen aus bestimmten Ländern zu blockieren. Allerdings können Angreifer solche Blockaden umgehen, indem sie Ihre Anfragen über Server in nicht blockierten Ländern leiten. Dennoch kann ein Geoblocking bisweilen massenhafte und wenig zielgerichtete Angriffsversuche unterbinden. -> **Woher darf etwas kommen?**

Ist ein Filterkriterium erfüllt, wird eine Aktion ausgeführt. Wird ein Paket **verworfen** (drop oder deny), wird es schlicht nicht weitergeleitet. Der Absender erhält darüber keine Auskunft. Wird ein Paket **zurückgewiesen** (deny oder reject) wird das Paket ebenfalls nicht weitergeleitet, der Absender wird allerdings direkt über den Kommunikationsabbruch informiert. Wird das Paket **aktezptiert** wird es an die Zieladresse weitergeleitet.

### Allgemeine Tips zur Firewall

- die Firewall sollte immer aktiv sein

- standardmäßig sollten eingehende Verbindungen blockiert werden

- eingehende Verbindungen sollten nur für einzelne Ports und Anwendungen geöffnet werden

- Sicherheit durch alternative Ports (wie beim SSH-Server) bringt nur ein wenig (siehe dazu den Wikipedia-Artikel zu [Security through obscurity](https://de.wikipedia.org/wiki/Security_through_obscurity))

- ein im Netzwerk exponiertes Programm (inkl. dem Betriebssystem) muss immer aktuell gehalten werden

- die Kommunikation sollte über verschlüsselte Protokolle stattfinden (TLS, SSH, HTTPS...)

- für noch mehr Sicherheit kann gesorgt werden, wenn auch der ausgehende Datenverkehr gefiltert wird und nur explizit notwendige Anfragen, z.B. für Softwareupdates, zugelassen werden aber Anfragen ins lokale Netzwerk unterbunden werden. Siehe dazu ein [Beispiel](https://www.linux-tips-and-tricks.de/en/raspberry/430-secure-raspberry-pi-against-internet-attacks-and-disable-attacks-into-the-local-network-with-a-firewall-using-iptables) mit der IP-Tables-Firewall

- Für Fortgeschrittene: mittels Port-knocking kann die Firewall nur kurzzeitig und explizit geöffnet werden und nach dem Ende der Kommunikation wieder geschlossen werden. Siehe dazu z.B. [dieses Tutorial](https://www.linuxbabe.com/security/secure-ssh-service-port-knocking-debian-ubuntu) im Netz.

### Umsetzung am Raspberry Pi

- Installation: `sudo apt-get install ufw`

- Regel hinzufügen: `sudo ufw allow <Portnummer>` oder `sudo ufw deny <Portnummer>`

- Standardregel für eingehenden Verkehr: `sudo ufw default deny incoming`

- Standardregel für ausgehenden Verkehr: `sudo ufw default allow outgoing`

- Zugriff auf SSH-Port nur aus dem lokalen Netzwerk zulassen (Netzwerkadresse anpassen!): `sudo ufw allow from 192.168.178.0/25 to any port 22`

- aktivieren: `sudo ufw enable`

- Status anzeigen lassen: `sudo ufw status`

- Status mit Nummer anzeigen lassen: `sudo ufw status numbered`

- Regel löschen: `sudo ufw delete <Nummer-der-Regel>`

Im Netz finden sich zahlreiche Anleitungen für die UFW. Empfehlenswert finde ich die Anleitungen von [DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-20-04-de) und  [PiMyLifeUp](https://pimylifeup.com/raspberry-pi-ufw/)

## Fail2Ban

Nachdem in der (uncomplicated) Firewall ein Port geöffnet wurde, wird die Kommunikation mit dem hinter dem Port wartenden Dienst aufgebaut. Jedoch ist es empfehlenswert diese Kommunikation weiterhin im Blick zu behalten.

Für einfache Szenarien kann das Programm **Fail2Ban** genutzt werden, um unerwünschte Eindringversuche zu erkennen und zu blockieren. Ein typischer Angriffsversuch, welcher mit Fail2Ban abgefangen werden kann, ist eine Brute-Force-Attacke, bei welcher durch massenhafte Anfragen versucht wird, Benutzername und Passwort zu erraten. Die dabei unweigerlich zahlreich auftretenden Fehlversuche werden in einer Protokolldatei im System notiert. Durch die Überwachung dieser Protokolldatei (auch als Logdatei bezeichnet) kann Fail2Ban die Absenderadresse der massenhaften Loginversuche erkennen und blockieren, indem die Adresse der Firewall als zu blockierende Adresse mitgeteilt wird.

Zu Fail2Ban gibt es im Netz verschiedne Anleitungen. Z.B. im offiziellen [Raspberry Pi Handbuch](https://www.raspberrypi.com/documentation/computers/configuration.html#block-suspicious-activity-with-fail2ban) oder wieder bei [PiMyLifeUp](https://pimylifeup.com/raspberry-pi-fail2ban/).

### Umsetzung am Raspberry Pi:

- Installation: `sudo apt-get install fail2ban`

- Aktivierung: `sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local`

- Beispielkonfiguration der Standardparameter mittels `sudo nano /etc/fail2ban/jail.local`

    - Standard Sperrzeit: `bantime = 20m`
    
    - Standardanzahl möglicher Fehlversuche: `maxretry = 3`
    
    - Standardzeit für "maxretry": `findtime = 10m`

- Zu überwachende Services/Ports werden am Ende der Datei `/etc/fail2ban/jail.local` mit `[<Name>]` definiert und mit Detaileinstellungen konfiguriert:

    - Aktivierung: `enabled = true`
        
    - Angabe des Ports: `port = <Portnummer des Services`
    
    - Angabe der zu überwachenden Logdatei: `logpath = <Pfad zur Logdatei>`
        
    - Angabe des Filters, mit dem die Logdatei geprüft wird: `filter = <Name der Datei im Verzeichnis /etc/fail2ban/filter.d/>`

- Beispiel für den SSH-Server:

```bash
#Standardeinstellungen vornehmen
bantime = 60m 
findtime = 15m
maxretry = 3 
# Im Bereich [sshd]
[sshd]
enabeld = true
port = <ssh-port>
logpath = %(sshd_log)s
backend = systemd
```

:::::: challenge
### Netzwerksicherheit
Sie sollen für Ihre Arbeitsgruppe einen kleinen Server mit diversen Diensten betreiben (z.B. einen Cloudserver). Wie gewährleisten Sie die Netzwerksicherheit, um unbefugten Zugriff auf den Server zu verhindern?

:::solution
Einige wichtige und grundlegende Maßnahmen können sein:

- Firewall auf dem Server aktivieren

- Eingehende Verbindungen blockieren

- nur einzelne Ports für die notwendigen Dienste und nur innerhalb des lokalen Netzwerkes freigeben

- Mit Fail2Ban oder vergleichbaren Tools fehlerhafte Loginversuche überwachen

- Regelmäßige Wartung: Sowohl der Server als auch alle anderen Netzwerkkomponenten (Router, Switche etc) müssen stets mit aktueller Soft- und oder Firmware ausgestattet werden.

- der SSH-Serverdienst sollte entsprechend [Kapitel 4](04-remote-access.Rmd) konfiguriert werden

- Noch mehr Sicherheit erhalten Sie durch eine Netzwerksegmentierung: sie trennen das Netzwerk in mehrere logische Bereiche auf, zwischen denen ein Router mit Firewall vermittelt.
:::
::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- Computer kommunizieren im Netzwerk nach Standards, das OSI-Schichten-Modell stellt einen Leitrahmen für diese Standards dar

- Versendete Daten im Netzwerk haben immer einen Absender- und einen Empfänger (in Form von MAC-Adresse, Netzwerk-ID, IP-Adresse und Port)

- Mit einer Firewall können Ports geöffnet und geschlossen werden

- Mit Fail2Ban können fehlerhafte Loginversuche festgestellt und blockiert werden

::::::::::::::::::::::::::::::::::::::::::::::::

