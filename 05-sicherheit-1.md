---
title: 'Sicherheit: Benutzer und Dateirechte'
teaching: 45
exercises: 90
---

:::::::::::::::::::::::::::::::::::::: questions 

- Wer darf was auf meinem System?

- Welche Benutzer gibt es unter Linux?

- Was sind Dateirechte?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Grundlagen der Benutzerverwaltung unter Linux

- Dateirechte verstehen und anpassen

- Befehle `chmod`, `chown`, `adduser`, `deluser` und `usermod` kennen lernen

::::::::::::::::::::::::::::::::::::::::::::::::

## Benutzerverwaltung

### Benutzerkategorien

Jeder User-Account in Linux besteht aus einem Loginnamen, einer User-ID, ggf. einem beschreibendem Namen und weiteren Metainformationen (z.B. Adresse, Telefonnummer etc). Auf einem üblichen Linux-System gibt es drei Typen von Benutzerkonten:

1. **root**: der Root-Account ist der Systemadministrator und hat damit die meisten Rechte im System. Er ist vergleichbar mit dem "Administrator"-Konto in Windows. Die User-ID des root-Accounts ist immer die 1.

2. **Standardaccount**: bei der Installation des Raspberry Pi OS wurde bereits ein erster Standardaccount erstellt. Standardaccounts sind i.d.R. mit echten Personen in Verbindung zu bringen, haben ein Benutzerverzeichnis unter `/home/` und können sich mit einem Passwort am System anmelden. Der erste Standardbenutzer erhält die User-ID 1000. Für alle weiteren wird die ID jeweils um 1 erhöht. Ein Standardaccount kann administrative Rechte erhalten. Wurden ihm diese erteilt, können mit dem [`sudo`-Befehl](#sudo) die eigenen Rechte eskaliert werden, d.h. Befehle mit administrativen Rechten ausgeführt werden. 

3. **Systemaccount**: Auf einem frisch installierten Linuxsystem gibt es bereits zahlreiche Systemaccounts. Sie haben i.d.R. User-IDs `<` 1000. Systemuser sind nicht mit echten Personen zu verbinden und können sich nicht interaktiv am System anmelden. Ein Systemaccount ist im Normalfall für eine explizite Aufgabe vorhanden. Z.B. ist der Account *www-data* für die Steuerung eines Webservers gedacht.

Sämtliche Benutzeraccounts des Systems können der Datei `/etc/passwd` entnommen werden (z.B. öffnen mit `less /etc/passwd`).

Möchte man einen neuen Account erstellen, nutzt man den Befehl `adduser`. Um z.B. den Account "Linus" hinzuzufügen lautet der Befehl wie folgt: `sudo adduser linus` Anschließend kann das Passwort sowie weitere Metainformationen des Accounts gesetzt werden. Es wird automatisch ein Homeverzeichnis für den User erstellt. Möchte man dies nicht, kann der Parameter `--no-create-home` dem Befehl angehängt werden.

### Gruppen

Neben einzelnen Accounts gibt es auch Gruppen, um mehrere Accounts zusammen zu fassen. Standardmäßig ist jeder Account (System- und Standardaccounts) auch Mitglied in seiner eigenen Gruppe. So ist z.B. der Systemaccount *www-data* auch Mitglied in der Gruppe *www-data*. Ein Account hat dabei immer die Rechte, die ihm selbst erteilt wurden plus die Rechte, die den Gruppen erteilt wurden, in welchen er Mitglied ist. Wird ein Recht an einer Stelle verweigert, so hat dies Vorrang vor einer Erlaubnis an anderer Stelle.

Um zu sehen in welchen Gruppen man Mitglied ist, kann der Befehl `id` genutzt werden. Der erste Standardbenutzer auf dem Raspberry Pi OS ist in mehreren Gruppen Mitglied. Um alle Gruppen und deren Mitglieder zu sehen kann die Datei `/etc/groups` geöffnet werden.

Möchte man einen Account einer Account-Gruppe hinzufügen, nutzt man den `usermod`-Befehl (kurz für user modification): `sudo usermod -aG <Gruppenname> <Username>` Möchte man einem Account administrative Rechte erteilen, muss dieser der *sudo*-Gruppe hinzugefügt werden: `sudo usermod -aG sudo <Username>`

### sudo

Mit dem `sudo`-Befehl können die eigenen Benutzerrechte eskaliert werden. Das heißt, Befehle mit erhöhten, also administrativen, Rechten ausgeführt werden. Dazu muss lediglich das `sudo`-Kommando vor den Befehl gestellt werden. Um z.B. einen neuen Account zu erstellen, muss vor den entsprechenden Befehl das *sudo* gestellt werden: `sudo adduser <username>`

:::callout
### Der `sudo`-Befehl

Um Befehle mit erhöhten Rechten auszuführen muss das `sudo`-Kommando vor den Befehl gestellt werden, z.B. `sudo adduser <username>`
:::

Der `sudo`-Befehl wird auch genutzt, um zwischen Accounts zu wechseln oder Befehle mit den Rechten eines anderen Accounts auszuführen. Um z.B. in den *Root*-Account zu wechseln genügt das Kommando `sudo -i`. Anschließend befindet man sich auf der Kommandozeile des Root-Accounts und alle Befehle werden mit Root-Rechten ausgeführt. Dementsprechend sollte man hier Vorsicht walten lassen. Um wieder zur vorhergehenden Kommandozeile des Standardaccounts zu kommen wird die Root-Befehlszeile mit dem Befehl `exit` verlassen.

Möchte man einen Befehl mit den Rechten eines anderen Accounts ausführen geschieht dies wie folgt: `sudo -u <username> <Befehl>` Um z.B. mit den Rechten des Accounts *www-data* die Datei *startpage.html* zu öffnen lautet der Befehl `sudo -u www-data nano startpage.html`

#### Passwortabfrage bei sudo-Befehl

Um zu verhindern, dass der sudo-Befehl ohne die Kenntnis des Passworts ausgeführt wird (z.B. wenn ein Angreifer einen Weg ins System gefunden hat und nun Zugriff auf den Account hat), sollte das System so konfiguriert werden, dass für den `sudo`-Befehl immer ein Passwort verlangt wird. Dieses wird nach erstmaliger Eingabe für die aktuelle Sitzung zwischengespeichert. Dazu muss die Datei `/etc/sudoers.d/010_<username>-nopasswd` mit dem *visudo*-Programm geöffnet werden: `sudo visudo /etc/sudoers.d/010_<username>-nopasswd` und wie folgt angepasst werden:

aus

```
<username> ALL=(ALL) NOPASSWD: ALL
```

wird

```
<username> ALL=(ALL) PASSWD: ALL
```
Dabei muss `<username>` durch den eigenen Usernamen ersetzt werden. Siehe dazu auch die [offizielle Raspberry-Pi-Dokumentation](https://www.raspberrypi.com/documentation/computers/configuration.html#require-a-password-for-sudo-commands).

::::::challenge
### Benutzerverwaltung

Sie sind mit Ihrem Standardaccount am System angemeldet, dieser hat bereits administrative Rechte. Nun wollen Sie Ihrem System den neuen Account *Linus* hinzufügen. Dieser Account soll ebenfalls administrative Rechte erhalten. Wie lauten die korrekten Befehle?

1. `sudo adduser linus` und `sudo visudo /etc/sudoers.d/010_pi-nopasswd`

2. `adduser linus` und `usermod -aG linus sudo`

3. `sudo adduser linus` und `sudo usermod -aG sudo linus`

4. `sudo visudo linus` und `sudo usermod -aG www-data linus`

:::solution
- Antwort 3 ist die richtige Lösung. 

Antwort 1 fügt zwar den User korrekt hinzu, aber der zweite Teil ändert allenfalls Eintellungen für den Account Pi. 

Bei Antwort 2 fehlt das `sudo`-Kommando vor den eigentlichen Befehlen und beim usermod-Befehl sind user und Gruppe vertauscht. 

Bei Antwort 4 macht der erste Teil gar keinen Sinn und der zweite ist zwar technisch korrekt, führt aber nicht zum gewollten Ziel.
:::
::::::

### Benutzerrechte

Jede Datei des Systems ist einem Besitzer und einer Gruppe zugeordnet. Darüber kann gesteuert werden, wer auf welche Dateien mit welchen Rechten zugreifen darf. Die genauen Rechte werden über den sogenannten ***mode*** gesteuert. Der *mode* gibt für jede Datei an, welche Rechte der Besitzer, die besitzende Gruppe und "andere Accounts" haben. Andere Accounts sind dabei alle anderen Accounts des Systems, auch Gastaccounts oder Systemaccounts.

Mit dem Befehl `ls -l <Dateipfad>` können die Inhalte eines Verzeichnisses und deren Berechtigungen angezeigt werden. Ohne Pfadangabe wird das aktuelle Verzeichnis gewählt. Die Ausgabe des Befehls `ls -l /home/linus` könnte z.B. wie folgt aussehen:

```bash
total 4
drwxrwxr-x 2 linus linus 4096 Aug 21 15:35 Ordner1
-rw-rw-r-- 1 linus linus   15 Aug 21 15:34 testdatei.txt
```
Dies ist wie folgt zu verstehen:

- <span style="color:rgb(165,30,55)">**d**</span>rwxrwxr-x = es handelt sich um ein Verzeichnis (d für directory, l für Link, - für Datei)

- d<span style="color:rgb(165,30,55)">**rwx**</span>rwxr-x = der Besitzer hat Lese- Schreib -und Ausführberechtigungen

- drwx<span style="color:rgb(165,30,55)">**rwx**</span>r-x = die besitzende Gruppe hat Lese- Schreib -und Ausführberechtigungen

- drwxrwx<span style="color:rgb(165,30,55)">**r-x**</span> = alle anderen haben nur Lese- und Ausführberechtigungen

- <span style="color:rgb(165,30,55)">**linus**</span> linus = die Datei/das Verzeichnis gehört dem User *linus*

- linus <span style="color:rgb(165,30,55)">**linus**</span> = die Datei/das Verzeichnis gehört der Gruppe *linus*

- <span style="color:rgb(165,30,55)">**4096**</span> = Dateigröße in Bytes

- <span style="color:rgb(165,30,55)">**Aug 21 15:35**</span> = Änderungszeit

- <span style="color:rgb(165,30,55)">**Ordner1**</span> = Verzeichnis-/Dateiname

Der ls-Befehl ist bei [Ubuntuusers](https://wiki.ubuntuusers.de/ls/) auch ausführlich erklärt.

Möchte man den Eigentümer einer Datei oder eines Verzeichnisses ändern, wird der Befehl `chown` genutzt (kurz für change ownership): `chown <neuer besitzer>:<neue Grupppe> <Datei/Verzeichnisname>`. Um z.B. die Datei *test.txt* dem User und der Gruppe *linus* zu übertragen lautet der Befehl wie folgt: `sudo chown linus:linus test.txt`. Soll ein gesamtes Verzeichnis übertragen werden, wird der Parameter `-R` (rekursiv) genutzt: `sudo chown -R linus:linus Ordner1`

Möchte man den *mode* ändern (also die Rechte für Besitzer und Gruppe), nutzt man den Befehl `chmod` (kurz für change mode): `sudo chmod <Modus> <Datei/Verzeichnis>` Der Modus setzt sich dabei stets aus drei Angaben zusammen: 

1. Angabe für wen etwas geändert wird (Gruppe oder Account)

    - `u` = user

    - `g` = group

    - `o` other (=alle anderen)

2. Angabe, ob ein Recht erteilt oder entzogen werden soll

    - `+` = Recht erteilen
    
    - `-` = Recht entziehen
    
3. Angabe zum betroffene Recht.

    - `r` = read (Leseberechtigung)
    
    - `w` = write (Schreibbrechtigung)
    
    - `e` = execute (Ausführen von Dateien oder Verzeichnisinhalt von Ordnern anzeigen lassen)

Eine ausführliche Erklärung zu Dateirechten findet sich wieder bei [Ubuntuusers](https://wiki.ubuntuusers.de/Rechte/)

#### Beispiel

Die Datei *test.txt* gehört dem User *linus* und der Gruppe *www-data*. Um nun dem User Lese- Schreib- und Ausführberechtigung zu erteilen, der Gruppe aber nur Leserechte, lauten die Befehle wie folgt: `sudo chmod u+rwx testdatei.txt` für die Userberechtigung und `sudo chmod g+r testdatei.txt` für die Gruppenberechtigung. Möchte man der Gruppe www-data wieder das Leserecht entziehen, lautet der Befehl wie folgt: `sudo chmod g-r testdatei.txt`

::::::challenge
### Dateiberechtigungen
Sie wollen mit Ihrem Standardaccount (dieser ist Mitglied der sudo-Gruppe) im Verzeichnis `/opt/` den neuen Ordner `webservice` erstellen. Der Ordner soll dem User *linus* und der Gruppe *www-data* gehören. Der User soll volle Rechte haben, die Gruppe soll lesen und ausführen dürfen, alle anderen sollen keine Rechte erhalten. Wie lauten die korrekten Befehle?

1.

    - `mkdir /opt/webservice` 
    
    - `chown linus:www-data /opt/webservice`
    
    - `chmod 750`

2. 

    - `sudo mkdir /opt/webservice` 
    
    - `sudo chown linus:www-data /opt/webservice`
    
    - `sudo chmod u+rwx`
    
    - `sudo chmod g+r`
    
    - `sudo chmod o-rwx`
    
3.

    - `sudo touch /opt/webservice` 
    
    - `sudo chmod linus:www-data /opt/webservice`
    
    - `sudo chown u+rwx`
    
    - `sudo chown g+r`
    
    - `sudo chown o-rwx`

4. 

    - `sudo mkdir /opt/webservice` 
    
    - `sudo chown linus:www-data /opt/webservice`
    
    - `chmod linus:+rwx`
    
    - `chmod www-data:+r`
    
    - `chmod others:-rwx`
    
:::solution
- Antwort 2 ist korrekt. Die drei `chmod`-Befehle könnten noch durch `sudo chmod 750` zusammengefasst werden, siehe dazu den [Ubuntuusers-Artikel zu Dateirechten](https://wiki.ubuntuusers.de/Rechte/#Darstellungsarten)

Antwort 1 schlägt fehl, da keine administrativen Rechte genutzt werden

Antwort 3 erstellt eine Datei anstatt eines Verzeichnisses. Außerdem sind die Befehle `chmod` und `chown` vertauscht.

In Antwort 4 ist der `chmod`-Befehl fehlerhaft

:::
::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- der *root*-Account ist der Adminstrator des Systems 

- Mitglieder der *sudo*-Gruppe haben administrative Rechte, welche sie mit dem `sudo`-Kommando nutzen können

- Dateien und Ordner sind immer einem Benutzer und einer Gruppe zugeordnet. Die Besitzverhältnisse können mit `chown` geändert werden.

- Dateien und Ordner haben einen *mode*, welcher die Rechte von Besitzer und besitzender Gruppe steuert, er kann mit `chmod` geändert werden

::::::::::::::::::::::::::::::::::::::::::::::::

