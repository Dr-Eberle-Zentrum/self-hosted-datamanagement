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

Das OSI-Referenz-Modell wird genutzt um Kommunikationsabläufe in Computernetzwerken zu definieren. Das Modell hat 7 Schichten. Dabei ist die Schicht 1 die unterste Schicht (Bitübertragunsschicht) der Kommunikation und legt z.B. fest, wie ein Kabel und seine Stecker aufgebaut sind. Die oberste Schicht (Anwendungsschicht) ist dagegen die komplexeste und steuert die Kommunukation zwischen einem Programm und dem Netzwerk, z.B. wird mit HTTP definiert, wie Ressourcen von einem Webserver zu einem Browser transportiert werden.

Jeder der sieben Schichten sind bestimmte Protokolle zugeordnet und bei der Kommunikation laufen die zu übertragenden Daten beim Sender von der obersten Schicht zur untersten und beim Empänger von der untersten zurück zur obersten Schicht. Auf jeder Schicht werden den eigentlichen Daten Steuerungsinformation hinzugefügt, z.B. die IP-Adresse des Empfängers, bzw. extrahiert und verarbeitet, z.B. als Information zur Adressierung genutzt.

Eine ausführliche Erklärung inkl. Video findet sich bei [Studyflix](https://studyflix.de/informatik/osi-modell-5524).

### IP-basierte Netzwerke

In standardmäßigen Computernetzwerken wird heutzutage das Internet Protokoll (IP) genutzt. Dieses ist auf der Schicht drei des OSI-Referenz-Modells angesiedelt. Es baut aber auf den Standards der Schicht 2 auf. Wichtig ist, dass auf Schicht für jedes im Netzwerk kommunizierende Gerät eine eindeutige Hardwareadresse, die MAC-Adresse, definiert wird. Diese ist für jedes Netzwerkinterface eindeutig, d.h. der Raspberry Pi hat für die LAN-Schnittstelle und für das WLAN-Modul jeweils eine eigene MAC-Adresse. In der Schicht 3 wird nun das Internet Protokoll genutzt, um die Daten zwischen den Kommunikationspartnern zu verteilen. D.h. hier findet die Adressierung und Wegfindung zwischen Netzwerken und innerhalb eines Netzwerks statt. Mittels des Internet Protokolls werden Netzwerke definiert. Für die Definition eines Netzwerks wird zunächst die Subnetzmaskte benötigt, welche die Größe des Netzwerks (also die maximale Anzahl an Geräten im Netzwerk) definiert. Sodann wird mit der ersten IP-Adresse des Subnetzbereichs das Netzwerk selbst adressiert und mit der letzten Adresse wird der sogenannte Broadcast definiert, der ein Datenpaket an alle IP-Adressen des Netzwerks weiterleitet. Einzelne Geräte bekommen nun innerhalb dieses Bereichs eine IP-Adresse sowie ein Standardgateway zugewiesen. Das Standardgateway definiert die Adresse, an welche Datenpakete geschickt werden, welche nicht im selben Netzwerk zu finden sind (z.B. Datenpakete, die ins Internet geroutet werden sollen).

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

::::::::::::::::::::::::::::::::::::: keypoints 

- 

::::::::::::::::::::::::::::::::::::::::::::::::

