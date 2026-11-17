---
title: 'Installationsvorbereitung 3'
teaching: 45
exercises: 90
---

:::::::::::::::::::::::::::::::::::::: questions 

- Welche weiteren Vorbereitungen sind nötig?

- Wie installiere und konfiguriere ich einen Datenbankserver?

- Wie konfiguriere ich einen Webserver?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Abhängigkeiten installieren: PHP, Datenbank und Webserver

- Datenbanken mit MariaDB erstellen

- Individuelle Website mit dem Apache-Webserver bereit stellen

::::::::::::::::::::::::::::::::::::::::::::::::

## Abhängigkeiten

Für das korrekte Funktionieren benötigen die meisten Programme dritte Programme, auf deren Funktionen sie zugreifen. Im Falle von Webanwendungen wie Nextcloud sind das vor allem ein Webserver (Apache2 in unserem Fall), ein Datenbankmanagementsystem (siehe [Datenbank](09-installationsvorbereitung-3.Rmd/#Datenbank)) und verschiedene Module der Skriptsprache PHP.

Dem [Nextcloud-Handbuch][nextcloud-doc] kann entnommen werden, dass einige PHP-Module benötigt werden, einige weitere je nach Einsatzzweck empfohlen sind. Die [Beispielinstallation unter Ubuntu 22.04](https://docs.nextcloud.com/server/latest/admin_manual/installation/example_ubuntu.html) listet auch die genauen Installationsbefehle auf:

```bash
sudo apt update && sudo apt upgrade
sudo apt install apache2 mariadb-server libapache2-mod-php php-gd php-mysql \
php-curl php-mbstring php-intl php-gmp php-bcmath php-xml php-imagick php-zip
```

Es empfiehlt sich jedoch, die genauen Anforderungen zu studieren und den obigen Befehl ggf. den eigenen und aktuellen Bedingungen anzupassen.

## Datenbank

Für die Speicherung von z.B. Userinformationen, Zugangsberechtigungen, Metadaten oder Referenzen auf die im Dateisystem gespeicherten Dateien benötigt Nextcloud eine Datenbank. Um eine Datenbank zu betreiben wird ein Datenbankmanagementsystem (kurz: **DBMS**) benötigt. Unter Debian-Linuxvarianten empfiehlt sich entweder PostgreSQL oder MariaDB. In diesem Kurs wird **MariaDB** genutzt. Da MariaDB ein Open-Source-Ableger von MySQL ist, können alle für MySQL gültigen Befehle auch für MariaDB genutzt werden.

Die Installation von MariaDB ist bereits mit den Abhängigkeiten erfolgt. Falls nicht, lautet der Befehl: `sudo apt-get install mariadb-server`

Um sich mit dem Datenbankmanagementsystem MariaDB zu verbinden, kann entweder der Befehl `mariadb` oder dessen Alias `mysql` genutzt werden. 

### Authentifizierung am DBMS

Um unautorisierten Zugriff auf Datenbanken zu verhindern, stellt MariaDB [unterschiedliche Möglichkeiten](https://mariadb.com/kb/en/authentication-plugins/) zur Anmeldung am DBMS bereit. Die einfachste ist dabei die Möglichkeit, einen auf dem Betriebssystem vorhandenen User zu nutzen ([Unix-Socket-Plugin](https://mariadb.com/kb/en/authentication-plugin-unix-socket/)). Standardmäßig hat der Root-Account des Betriebssystems auch Root-Rechte in MariaDB. Daraus folgt, dass bei einer Anmeldung mit dem Linux-Root-Account auch Root-Rechte in MariaDB erhalten werden: `sudo mariadb`. Möchte man sich dagegen mit einem User anmelden, der im DBMS gespeichert ist ([mysql_native_paassword-Plugin](https://mariadb.com/kb/en/authentication-plugin-mysql_native_password/)), muss dies explizit mit dem Parameter `-u <username>` angegeben werden: `mysql -u <username>` Hat der angegebene User nicht die nötigen Rechte im DBMS, schlägt die Anmeldung fehl.

Um einen User zum DBMS hinzuzufügen, wird wie folgt vorgegangen:

- mit Root-Rechten anmelden: `sudo mysql`

- User erstellen, welcher sich per Passwort am lokalen DBMS anmelden kann: `CREATE USER '<username>'@'localhost' IDENTIFIED BY '<password>';`

- Vom DBMS abmelden: `quit`

- Mit dem neu erstellten User anmelden: `mysql -u <username> -p `

- Passwort eingeben

### Datenbank erstellen

Um eine neue Datenbank zu erstellen wird der Befehl `create database` innerhalb der interaktiven MariaDB-Kommandozeile genutzt. Anschließend können mit dem `GRANT`-Befehl einem User Schreib- und Leserechte für die Datenbank erteilt werden.

Es gilt als *Best-Practice* für jeden Webservice einen eigenen User zu erstellen, welcher nur diejenigen Rechte erhält, die unbedingt nötig sind, um den Service zu betreiben. Auf jeden Fall sollte kein Webservice mit Root-Rechten auf das DBMS zugreifen. 

Im Falle von Nextcloud wird zunächst mit Root-Rechten ein User erstellt, eine Datenbank erstellt und dem User anschließend die notwendigen Rechte erteilt:

```sql
CREATE USER '<username>'@'localhost' IDENTIFIED BY '<password>';
CREATE DATABASE IF NOT EXISTS <datenbankname> CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON <datenbankname>.* TO '<username>'@'localhost';
FLUSH PRIVILEGES;
quit;
```

`<username>`, `<password>` und `<datenbankname>` sind jeweils durch eigene Werte zu ersetzen.

Siehe dazu auch das [Handbuch](https://docs.nextcloud.com/server/stable/admin_manual/installation/example_ubuntu.html)

Anschließend sollte der Login und der Zugriff auf die erstellte Datenbank getestet werden: `mysql -u <username> -p <datenbankname>`

## Softwaredownload

Da nun alle Vorbereitungen abgeschlossen sind, kann die Software heruntergeladen und der Download mittels eines Hashwertes überprüft werden:

```
wget https://download.nextcloud.com/server/releases/latest.tar.bz2
wget https://download.nextcloud.com/server/releases/latest.tar.bz2.sha256
sha256sum -c latest.tar.bz2.sha256 < latest.tar.bz2
```

:::callout
### Hashwerte:

Um die Korrektheit eines Downloads zu überprüfen, kann dessen Hashwert überprüft werden. Ein Hashwert ist ein Wert, der durch einen Algorithmus aus einer Datei abgeleitet wird. Wird die Datei verändert, verändert sich auch der Hashwert. Dadurch kann überprüft werden, ob eine heruntergeladene Datei noch immer der Datei entspricht, die ursprünglich zur Verfügung gestellt wurde oder ob die Datei auf dem Weg abgefangen und verändert wurde.

Mehr zu Hashwerten findet sich z.B. in diesen beiden YouTube-Videos: [Video 1](https://www.youtube.com/watch?v=VmVFe5gr_5A) und [Video 2](https://www.youtube.com/watch?v=shs0KM3wKv8)
:::

Nach dem Download muss die Software entpackt und in das Document-Root der Website kopiert werden (standardmäßig `/var/www/<servicename>`).

::::::challenge
### Dateiarbeit

Was machen die folgenden Befehle:

```bash
sudo tar -xjvf latest.tar.bz2 -C /var/www
sudo chown -R www-data:www-data /var/www/nextcloud
```

:::solution
Der tar-Befehl entpackt das heruntergeladene und komprimierte Archiv (*latest.tar.bz2*) in das Verzeichnis `/var/www`

Der chown-Befehl überträgt das entpackte Verzeichnis dem User und der Gruppe www-data. Dies ist wichtig, damit der Webserver später auf die Dateien zugreifen kann.
:::
::::::

## Website Grundkonfiguration

Nach dem Download der Dateien müssen diese als Website durch den Webserver bereit gestellt werden. Dazu muss für Apache2 eine neue Konfigurationsdatei für die Website erstellt werden: `sudo nano /etc/apache2/sites-available/nextcloud.conf`

In einer ersten sehr einfachen Version kann diese wie folgt aussehen:

```apacheconf
<VirtualHost *:80>
  DocumentRoot /var/www/nextcloud/
  ServerName  server.ddns-provider.de

  <Directory /var/www/nextcloud/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
```

::::::challenge
### Apache-Konfiguration

Schauen Sie sich den oben gezeigten Code der Apache-Konfigurationsdatei an. Können Sie die Einstellungen verstehen? Welche Einstellungen müssen Sie an Ihr Setup anpassen?

:::solution
Webserver sind eine komplexe Angelegenheit, die sehr viele Möglichkeiten zur Konfiguration bieten. Um alle Möglichkeiten zu kennen und zu verstehen, wäre ein eigener Kurs nötig. Idealerweise stellen die Hersteller des zu installierenden Webservices eigene Informationen zur Konfiguration bereit, da je nach Service unterschiedliche Konfigurationen nötig sind. Die wichtigsten Parameter im obigem Code-Beispiel sind:

DocumentRoot: Stammverzeichnis, in welchem sich die Website-Daten befinden.

ServerName: Webadresse, unter der die Website erreichbar sein soll

Die anderen Optionen können dem [Handbuch](https://docs.nextcloud.com/server/latest/admin_manual/installation/source_installation.html) entnommen werden.

:::
::::::

Ist die Konfigurationsdatei erstellt, muss dem Webserver mitgeteilt werden, dass diese aktiviert werden soll: `sudo a2ensite nextcloud.conf` Anschließend befindet sich im Verzeichnis `/etc/apache2/sites-enabled/` ein Link auf die Datei `/etc/apache2/sites-available/nextcloud.conf`

Der Apache-Webserver kann durch Module in seiner Funktion erweitert werden. Diese müssen aktiviert werden, damit sie verfügbar sind. Für Nextcloud sollten die Module *mod_rewrite*, *mod_headers*, *mod_env*, *mod_dir* und *mod_mime* aktiviert werden: `sudo a2enmod rewrite headers env dir mime`

Anschließend muss Apache2 neugestartet werden: `sudo systemctl restart apache2.service`

## Abschließende Schritte

Vor der Installation von Nextcloud muss eine (leere) Konfigurationsdatei für Nextcloud erstellt werden: `sudo touch /var/www/nextcloud/config/config.php`

### Datenverzeichnis

Um die Dateien, die später in Nextcloud gespeichert werden sollen, nicht auf dem Hauptlaufwerk des Raspberry Pis (der SD-Karte) zu speichern, wird auf dem externen Speicher (siehe [Episode 7: Installationsvorbereitung 1](07-installationsvorbereitung-1.Rmd)) ein Verzeichnis erstellt: `sudo mkdir /mnt/data/ncdata`

Zu Letzt muss sicher gestellt werden, dass der Webserver die nötigen Zugriffsrechte auf das Document-Root und das Datenverzeichnis hat:

- `sudo chown -R www-data:www-data /var/www/nextcloud`

- `sudo chown -R www-data:www-data /mnt/data/ncdata`

Steuert man nun seine beim DDNS-Provider gewählte Domain im Browser an, erreicht man den Nextcloud-Installationsassistenten. Bevor dieser gestartet wird, sind aber noch weitere Schritte notwendig.

::::::::::::::::::::::::::::::::::::: keypoints 

- Nextcloud benötigt weitere Programme zur Funktion: PHP, Datenbank und Webserver

- Mit MariaDB muss ein Datenbankuser und eine Datenbank für Nextcloud erstellt werden

- Die heruntergeladenen Dateien müssen mittels Konfigurationsdatei durch Apache zur Verfügung gestellt werden

::::::::::::::::::::::::::::::::::::::::::::::::

