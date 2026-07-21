---
title: Startseite
---

## Voraussetzungen

Um am Kurs teilnehmen zu können, müssen Sie an der Universität Tübingen immatrikuliert sein und sich über das ALMA-System zum Kurs angemeldet haben.

::: callout
Sie sind nicht an der Universität Tübingen immatrikuliert? 

Kein Problem. Sie können die Materialien zum Selbststudium nutzen und so dennoch einiges lernen.

:::

Um den Kursinhalten folgen zu können, sollten Sie Interesse an Computertechnik, Systemadministration, Kommandozeile und Linux haben. Vorkenntnisse in diesen Bereichen sind nicht nötig (aber hilfreich).

Die hier veröffentlichten Materialien sollen Ihnen als Selbstlernmaterial dienen. Wesentlicher Bestandteil des Kurses sind jedoch die praktischen Live-Übungen.

## Allgemeine Informationen

::: callout

### Ihr Dozent

David Kirschenheuter, M.A.

Digital Humanities Center, Universität Tübingen

**Kontakt:**

- david.kirschenheuter@uni-tuebingen.de

- Keplerstraße 2, 72074 Tübingen

- 07071-29-73633

- Raum 141

:::

::: callout

### Kursräume und Materialien

- **[ILIAS-Kursraum:][ilias]** hier werden u. A. Tests durchgeführt und es gibt ein internes Diskussionsforum.

- **[Github][github]:** hier finden Sie alle Selbstlernmaterialien. Diese dienen als Vorbereitung auf die Tests in ILIAS und die praktischen Sitzungen im Seminarraum.

- **[Seminarraum](https://alma.uni-tuebingen.de:443/alma/pages/startFlow.xhtml?_flowId=showRoomDetail-flow&roomId=44&roomType=3&context=showRoomDetail&navigationPosition=organisation,searchroom):** Im Seminarraum 036 in der Keplerstraße 2 finden die wöchentlichen praktischen Sitzungen statt. Die Teilnahme daran ist optional aber sehr zu empfehlen. Während der Sitzungen können Sie an der Umsetzung des Projekts arbeiten und Fragen diskutieren. Außerdem gibt es anlassbezogen Input durch den Dozenten.

:::

### Hilfreiche Befehle und Workflows

#### Dateiübertragung mit scp

Mit dem scp-Befehl können Dateien sicher über das SSH-Protokoll kopiert werden. Mit dem scp-Befehl können Dateien sowohl vom Client-PC zum Server, also auch vom Server zum Client-PC kopiert werden.

Die grundlegende Sytnax für das kopieren vom Server zum Client-PC lautet: `scp user@server:<entfernter Dateipfad- und name> <lokaler Dateipfad>`, z.B. `scp linus@192.168.50.100:/homer/linus/nextcloud.conf C:\Users\Linus\Desktop\nextcloud.conf` 

Die grundlegende Syntax zum kopieren vom Client-PC zum Server lautet: `scp <lokaler Pfad> user@server:<enterfernter Pfad>` z.B. `scp nextcloud.config linus@192.168.50.100:/homer/linus/nextcloud.conf`

Ergänzt werden muss der Befehl mit dem Parameter `-P Portnummer` für die Angabe des SSH-Ports und `-i <Pfad zum SSH-privat-key>`für die Angabe des SSH-Schlüssels.

Der komplette Befehl mit Key und Port kann wie folgt aussehen: `scp -P 23816 -i .ssh/raspberrypi linus@192.168.50.100:/etc/apache2/sites-available/nextcloud.conf C:\Users\Linus\Downloads\nextcloud.conf`
