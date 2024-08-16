---
title: 'Remote Access: das SSH-Protokoll'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- Wie kann ein Computer aus der Ferne verwaltet werden, wenn er keinen Bildschirm hat?

- Wie kann eine SSH-Verbindung sicher über unsichere Netzwerke hergestellt werden?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Grundlagen des SSH-Protokolls verstehen

- SSH-Server sicher konfigurieren

- Sichere SSH-Verbindungen mit Schlüssel-Authentifikation aufbauen

- den Raspberry Pi im Headless-Setup aus der Ferne steuern
::::::::::::::::::::::::::::::::::::::::::::::::

## Das SSH-Protokoll

Server stehen häufig an unzugänglichen Orten (Keller, gekühlte Serverräume, weit entfernte Rechenzentren o.Ä.). Dennoch müssen sie verwaltet werden. Dies wird heutzutage mittels des SSH-Protokolls gemacht (früher wurde das inzwischen veraltete Telnet-Protokoll genutzt).

Das SSH-Protokoll baut eine sichere Verbindung zwischen einem Clientgerät (z.B. Ihrem Notebook) und einem Server (z.B. Ihrem Raspberry Pi) über ein (ggf. auch unsicheres) Netzwerk auf. Über diese Verbindung besteht in der Regel Zugriff auf die Kommandozeile des entfernten Geräts. Die Verbindung kann aber auch zum Übertragen anderer Daten genutzt werden. So können Daten übertragen werden (mit dem `scp`-Befehl), entfernte Dateisysteme lokal genutzt werden (per SSHFS, siehe [Wikipedia](https://de.wikipedia.org/wiki/SSHFS)) oder die graphische Ausgabe eines entfernten Programms lokal dargestellt werden [siehe diesen Heise-Artikel](https://www.heise.de/tipps-tricks/SSH-Tunnel-nutzen-so-geht-s-4320041.html).

::: callout

### Protokoll

Bei einem Protokoll handelt es sich um genau festgelegte technische Parameter für den Kommunikationsausstausch zwischen Computern. Ähnlich der Sprache und ihrer Grammatik, auf die sich zwei Menschen zum Kommunizieren einigen. Ein Protokoll hat einen genauen Einsatzzweck und eine klar definierte Funktionsweise. z.B. ist das HTTPS-Protokoll dafür gemacht, Daten zwischen einem Browser und einem Webserver verschlüssel mittels der TLS-Verschlüsselung zu übertragen.

:::

Das SSH-Protkoll nutzt dafür verschiedene Technologien zur Gewährleistung der sicheren Übertragung. Ähnlich einer [HTTPS-Verbindung](https://tiptopsecurity.com/how-does-https-work-rsa-encryption-explained/) werden beim Verbindungsaufbau zunächst die Kommunikationsstandards zwischen Client und Server ausgehandelt, dann werden sog. Session-Keys ausgetauscht, welche nur für die aktuelle Verbindung Gültigkeit haben. Mit diesen Session-Keys wird die eigentliche Verbindung in Form einer symmetrischen Verschlüsselung (welche deutliche schneller ist, als die zuvor stattfindende asymetrische Verschlüsselung, siehe dazu auch die Ressourcen von Studyflix zur [symetrischen](https://studyflix.de/informatik/symmetrische-verschlusselung-1610) und [asymmetrischen](https://studyflix.de/informatik/asymmetrische-verschlusselung-1609) Verschlüsselung).

:::: challenge

### Voraussetzung für die SSH-Verbindung

Sie haben wie in [01-hardware-betriebssystem.Rmd](Sitzung 2) besprochen auf Ihrem Raspberry Pi das Raspberry Pi OS installiert. Nun wollen Sie eine SSH-Verbindung von Ihrem Notebook mit Ihrem Raspberry Pi herstellen. Was sind die Bedingungen für eine erfolgreiche SSH-Verbindung?

:::solution
1. Netzwerkverbindung: der Server muss im Netzwerk erreichbar sein. Dazu müssen entweder Server und Client im Selben Netzwerk (z.B. demselben Heimnetzwerk) sein oder der Server muss im Internet erreichbar sein.

2. Software: Auf dem Raspberry Pi muss die SSH-Server-Software installiert sein (das **Paket openssh-server**) und auf dem Client ein SSH-Client-Programm (das  OpenSSH-Client-Programm für die Kommandozeile ist i.d.R. auf allen PCs installiert. Für Windows kann auch das graphische Programm [Putty](https://putty.org/) installiert werden).

3. Berechtigungen: die Anmeldung am entfernten Server ist nur möglich, wenn Sie die Berechtigungen haben. Sie benötigen also einen Account auf dem Raspberry Pi OS und dessen Passwort.

4. Firewall: eine etwaige Firewall am Server muss die SSH-Verbindung zulassen

5. Identifizierung: der Server muss für eine ordentliche Verbindung eindeutig identifizierbar sein. Dies geschieht durch sogenannte Host-Keys, die bei der erstmaligen Verbindung vom Server zum Client übertragen werden. Ändert sich der Host-Key (z.B. nach einer Neuinstallation oder weil ein bösartiger Akteur sich als Ihren Raspberry Pi ausgibt) und passt nicht mehr zum ursprünglichen, schlägt die Verbindung fehl. Erst wenn der neue Key akzeptiert wird ist eine Verbindung wieder möglich (gespeicherte Keys finden Sie in der Datei *know_hosts.conf* im Verzeichis *.ssh* in Ihrem persönlichen Ordner).
:::

::::::

### Grundlegender Verbindungsaufbau

Wenn die Voraussetzungen stimmen (siehe [Vorraussetzungen für die SSH-Verbindung](#voraussetzung-für-die-ssh-verbindung)), kann eine einfache SSH-Verbindung mit folgendem Befehl aufgebaut werden: `ssh <user>@<server>` Dabei ist <user> der Username am entferten Gerät und <server> ist die Adresse des Servers. Die Adresse kann entweder in Form einer IP-Adresse (z.B. 192.168.178.10) oder, als Hostname (z.B. mein-cloudserver) angegeben werden. Die Variante mit dem Hostname funktioniert jedoch nur, wenn dieser im lokalen Netzwerk bekannt ist (z.B. in einem Heimnetzwerk im Router eingezeigt wird.)

::: callout

### SSH-Verbindung

- So bauen Sie eine einfache SSH-Verbindung auf: **`ssh <user>@<server>`**

:::

## Schlüssel-Authtenfikation

Die einfache SSH-Verbindung genügt zwar schon, um das entfernte System zu verwalten. Allerdings könnte eine angreifende Person versuchen, den Usernamen und das Passwort zu erraten und damit Zugriff auf den Server erlangen (leider sind Passwörter häufig nicht allzu kreativ erdacht). Um dies zu verhindern, kann die Verbindung zusätzlich gesichert werden:

- am Client, indem statt Passwörtern kaum zu erratende Schlüssel zur Anmeldung genutzt werden

- am Server, indem zu häufige Fehlanmeldungen zu einem Blockieren führen

Die Anmeldung per Schlüssel erfolgt mit einem Schlüsselpaar. Ein solches Schlüsselpaar besteht aus einem privaten und einem öffentlichen Schlüssel. Während der öffentliche Schlüsse herausgegeben werden kann, muss der private Schlüssel privat bleiben und sollte das eigene Gerät niemals verlassen. Vereinfacht kann man sich das Konzept wie ein Vorhängeschloss und den dazugehörigen Schlüssel vorstellen. Das Schloss ist in dieser Analogie der öffentliche Schlüssel und wird in geöffnetem Zustand an den Server übergeben. Dieser "verschließt" damit die Tür zum SSH-Server. Zwar können alle sehen, dass Ihr (öffentliches) Schloss an der Tür hängt, aber nur Sie können mit Ihrem privaten Schlüssel die Tür wieder öffnen. 

Aufgrund der komplexen krytpographischen Struktur der Schlüssel sind diese deutlich schwerer bis gar nicht zu erraten. Zusätzlich empfiehlt es sich, den privaten Schlüssel mit einer Passphrase vor unbfugtem Zugriff zu schützen. Dann muss jedes mal, wenn der private Schlüssel genutzt wird, ein zusätzliches Passwort eingegeben werden.

:::callout

### Schlüsselauthentifikation

Für eine sichere SSH-Verbindung empfiehlt es sich, auf Passwörter zu verzichten und sich stattdessen mit einem Schlüsselpaar zu authentifizieren.

Ist ein Schlüsselpaar erzeugt, erfolgt die Verbindung etwas anders: `ssh <user>@<server> -i <Pfad-zum-privaten-schlüssel>` mit dem Befehlsparameter *-i* wird der der Pfad zum privaten Schlüssel am Client angegeben.

:::

### Schlüsselpaar erstellen

Die Erstellung eines Schlüsselpaars erfolgt am Client. Dazu wird auf der Kommandozeile ("Eingabeaufforderung" unter Windows) folgender Befehl abgesetzt: `ssh-keygen -t <Schlüsseltyp> -b <Schlüssellänge>` Es müssen Angaben zum Speicherort und der Passphrase gemacht werden. Wird kein Speicherort angegeben, wird das Schlüsselpaar im Ordner .ssh des Benutzerverzeichnisses gespeichert. 

Es stehen unterschiedliche Schlüsseltypen- und -längen zur Verfügung:

- RSA: weit verbreitet, kann mit sehr viel Rechenaufwand evtl. geknackt werden (siehe letzter Absatz [dieses Artikels](https://www.onlinesicherheit.gv.at/Services/News/RSA-Verschluesselung-Sicherheit.html)). Als Schlüssellänge sollte 4096 bit gewählt werden

- ecdsa: ist ein neueres Verfahren, das aber kurze Schlüssel nutzt

- ed25519: ist ein neues Verfahren, das auf sog. elliptische Kurven setzt und als am sichersten gilt. Dieses Verfahren empfehle ich zu nutzen.

Zur Wahl des Schlüsseltyps gibt es bei [goteleport](https://goteleport.com/blog/comparing-ssh-keys/#rsa-vs-dsa-vs-ecdsa-vs-eddsa) eine informative Vergleichstabelle.

::: callout
### **WICHITG**

Das Schlüsselpaar muss **am Client** erstellt werden. Sonst ist der private Schlüssel bereits mit der Erstellung auf einem fremden Gerät und damit kompromittiert.

:::

### Schlüssel übertragen

Ist das Schlüsselpaar erzeugt, muss der **öffentliche** (und nur der öffentliche!) Schlüssel zum Server übertragen werden (nur zur Erinnerung: nur der **öffentliche** Schlüssel wird übertragen). Dies kann je nach Betriebssystem des Clients unterschiedlich bewerkstelligt werden.

::: tab

### Windows

Unter Windows muss das Programm scp genutzt werden, mit welchem über eine SSH-Verbindung Dateien (in diesem Fall der öffentliche Schlüssel) übertragen werden können:

- Übertragung: `scp <ffentlicher-schlüssel.pub> <username>@<server>:/home/<username>/Desktop`

- einfache SSH-Verbindung zum Server: `ssh <username>@<server>`

- Verzeichnis erstellen: `mkdir .ssh`

- Datei für zugelassen Schlüssel erstellen: `touch .ssh/authorized_keys`

- Öffentlichen Schlüssel in Datei kopieren: `cat Desktop/<öffentlicher-schlüssel.pub> >> .ssh/authorized_keys`

- Überprüfung: `cat .ssh/authorized_keys`

- SSH-Verbindung verlassen: `exit`

- SSH-Verbindung mit privatem Schlüssel testen: `ssh <username>@<server> -i .ssh\<schluessel>`

### Mac

- ssh-copy-id

### Linux

- ssh-copy-id

:::

## Konfiguration des SSH-Servers

::::::::::::::::::::::::::::::::::::: keypoints 

- 

::::::::::::::::::::::::::::::::::::::::::::::::

