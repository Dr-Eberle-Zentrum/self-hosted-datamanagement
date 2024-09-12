---
title: 'Installationsvorbereitung 4'
teaching: 45
exercises: 90
---

:::::::::::::::::::::::::::::::::::::: questions 

- Ist die aktuelle Verbindung zu meiner Cloud sicher?

- Wie kann ich Apache besser konfigurieren?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- TLS-Zertifikate mit Letsencrypt und Certbot

- Sicherheitsoptimierungen für Websites mit Apache

::::::::::::::::::::::::::::::::::::::::::::::::

## Kommunikationsweg:

Aktuell erreichen wir den Webserver, welcher uns die Website für Nextcloud ausliefert, mit dem HTTP-Protokoll über Port 80. Diese Verbindung ist unverschlüsselt. Das bedeutet, dass sämtliche Daten (z.B. Passwörter und Dateien) die zum Server geschickt oder vom Server verschickt werden, von einem "Zuhörer" auf der Leitung mitgelesen werden können (das geht z.B. mit dem Tool [Wireshark](https://www.wireshark.org/about.html) v.a. im LAN recht einfach, siehe z.B. diese Anleitung von [Varonis](https://www.varonis.com/de/blog/verwendung-von-wireshark)).

### Grundlagen der HTTPS-Verbindung

Um das Auslesen der Verbindung und damit das Abfangen sämtlicher Kommunikation zu unterbinden, muss die Verbindung verschlüsselt werden. Um eine HTTP-Verbindung zu verschlüsseln wird diese durch das TLS-Protokoll zu einer HTTP**S**-Verbindung erweitert. HTTPS ist heute glücklicherweise der Standard bei den meisten Internetseiten. Dass Sie eine HTTPS-Verbindung zu einer Seite aufgebaut haben, erkennen Sie in der Adresszeile Ihres Browsers anhand eines Schlosssymbols, bei besonders starken Zertifikaten ggf. zusätzlich auch anhand einer grünen Markierung (siehe die folgende Abbildung).

![HTTPS-Verbindung im Browser](fig/10-https-browser.png){alt='Browseradresszeile mit der Adresse https://uni-tuebingen.de. Durch ein Schlosssymbol wird die https-Verbindung dargestellt.'}

Die Grundlage des TLS-Protokolls stellen Zertifikate dar, die die Authentizität der Website bestätigen. 

Dazu ein nicht technisches Vergleichsbeispiel: Sie wollen bei einem Geschäftsvorgang die Identität einer Person überprüfen. Zeigt Ihnen die Person einen selbst ausgestellten Ausweis, werden Sie diesem Personalausweis nicht vertrauen. Zeigt die Person jedoch einen Ausweis, der von einer Behörde ausgestellt wurde, welcher Sie vertrauen, können Sie auch dem vorgelegten Ausweis vertrauen.

Übertragen auf die HTTPS-Verbindung sieht es wie folgt aus: Ein Website-Betreiber kann sich selbst ein TLS-Zertifikat ausstellen (unter Linux z.B. mit dem Programm *OpenSSL*) und dieses einem anfragendem Webbrowser oder sonstigem Client präsentieren. Allerdings kann einem solchen selbst ausgestellten Zertifikat nicht von Dritten vertraut werden. Der Browser wird die Verbindung als unsicher ablehnen und eine Warnmeldung zeigen. Damit ein Client dem Zertifikat vertrauen kann, muss dieses genau wie beim Personalausweis von einer zentralen Stelle ausgestellt werden. Diese zentralen Stellen (als *Zertifizierungsstellen* oder im Englischen als *Certificate Authority* bezeichnet) können auf Anfrage ein Zertifikat ausstellen, sofern die Identität des Anfragenden gewährleistet ist. 

Gleichzeitig besitzt die Zertifizierungsstelle selbst ein Zertifikat, dass deren Identität bestätigt. Dieses Zertifizierungsstellenzertifikat wiederum ist vom Hersteller Ihres Betriebssystems auf Ihrem PC hinterlegt und als vertrauenswürdig eingestuft worden. Überprüft der Browser nun das Zertifikat der Website, stellt er zunächst fest, dass das präsentierte Zertifikat von einer Zertifizierungsstelle ausgestellt wurde, welcher er vertraut. Außerdem wird überprüft, ob die aufgerufene Adresse auch der im Zertifikat hinterlegten Adresse entspricht.

Rufen Sie eine Website auf, die ein falsches Zertifikat präsentiert (z.B. für die falsche Adresse, ein abgelaufenes oder selbst ausgestelltes Zertifikat), erhalten Sie eine Warnmeldung. Diese sollten Sie ernst nehmen, da es auf einen Betrugsversuch hindeuten kann, in welchem eine angreifende Person sich für die Website ausgibt, die Sie eigentlich aufrufen wollten (z.B. die Seite Ihres Online-Bankings).

![Fehlgeschlagene HTTPS-Verbindung im Browser mit Sicherheitswarnung](fig/10_https-browser-unsecure.png){alt='Browserfenster, dass eine unsichere https-Verbindung zeigt, welche mit einer Warnung angezeigt wird: "Warnung: Mögliches Sicherheitsrisiko erkannt"'}

### TLS-Verschlüsselung einrichten

Um die eigene Website per HTTPS erreichen zu können, muss der Raspberry Pi ein Zertifikat von einer Zertifizierungsstelle erhalten, die von allen Computern anerkannt ist. Während dies früher nur gegen Bezahlung möglich war, existiert seit einigen Jahren mit [Letsencrypt](https://letsencrypt.org/) ein Anbieter, der kostenlose Zertifikate zur Verfügung stellt. Diese sind jedoch nur drei Monate gültig und müssen dann verlängert werden.

Um ein solches Zertifikat zu erhalten, muss man gegenüber Letsencrypt nachweisen, dass man die Eigentümerschaft über die Domain, für welche das Zertifikat angefragt wird, hat. Das heißt: wenn Sie für die Adresse server.ddns-provider.de ein Zertifikat erhalten wollen, müssen Sie nachweisen, dass sie den Webserver, der die Seite server.ddns-provider.de ausliefert, verwalten. Diesen Nachweis erbringen Sie nicht manuell, sondern mit Hilfe des Programms **Certbot**. Mit diesem Programm werden automatisiert einige Informationen zwischen Ihrem Webserver und den Servern von Letsencrypt ausgetauscht, anhand deren die Eigentümerrschaft nachgewiesen werden kann. Anschließend wird das Zertifikat ausgestellt und kann dann in den Einstellungen der Website integriert werden.

#### Zertifikat erhalten:

- Snapd (alternative Paketverwaltung) [installieren](https://snapcraft.io/docs/installing-snap-on-raspbian):

    - Installation: `sudo apt install snapd`
    
    - Neustart: `sudo reboot`
    
    - Kernpakete installieren: `sudo snap install core; sudo snap refresh core`
    
    - Certbot installieren: `sudo snap install --classic certbot`
    
    - Certbot-Befehle im System bekannt geben: `sudo ln -s /snap/bin/certbot /usr/bin/certbot`
    
- Überprüfen, ob der Webserver über HTTP auf Port 80 aus dem Internet erreichbar ist (vgl. [Lektion 8: Test der externen Erreichbarkeit](08-installationsvorbereitung-2.Rmd#Test der externen Erreichbarkeit))    

- Zertifikatsausstellung testen: `sudo certbot certonly --apache -d <server.ddns-provider.de> --dry-run` (Achtung: eigene Domain einsetzen)

- Wenn der Test erfolgreich war, kann die Zertifikatsausstellung durchgeführt werden: `sudo certbot --certonly -d <server.ddns-provider.de>`

#### System von HTTP auf HTTPS umstellen:

- Wurde das Zertifikat erhalten, wird im Router die **Portweiterleitung** für Port 80 gelöscht und stattdessen für Port 443 (Standardport für HTTPS-Verbindungen) eingerichtet. Anschließend wird auch am Raspberry Pi in der **Firewall** Port 80 geschlossen und Port 443 geöffnet.

- Apache-Webserver auf HTTPS umstellen: die Konfigurationsdatei der Webiste unter `/etc/apache2/sites-available/nextcloud.conf` muss angepasst werden

```apacheconf
<VirtualHost *:80>
  DocumentRoot /var/www/nextcloud/
  ServerName  server.ddns-provider.de

  RewriteEngine on
  RewriteCond %{SERVER_NAME} =server.ddns-provider.de
  RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>


<IfModule mod_ssl.c>
<VirtualHost *:443>
  DocumentRoot /var/www/nextcloud/
  ServerName  server.ddns-provider.de
  <IfModule mod_headers.c>
      Header always set Strict-Transport-Security "max-age=15552000; includeSubDomains"
    </IfModule>
  <Directory /var/www/nextcloud/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews
    LimitRequestBody 2147483647
    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>

SSLCertificateFile /etc/letsencrypt/live/server.ddns-provider.de/fullchain.pem
SSLCertificateKeyFile /etc/letsencrypt/live/server.ddns-provider.de/privkey.pem
Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>
</IfModule>
```

::::::challenge
Schauen Sie sich auch diese Apache-Konfigurationsdatei genau an und überlegen Sie sich, was die Einstellungen bewirken und welche Optionen Sie an Ihr Setup anpassen sollten.

::::::

- Wie nach jeder Änderung an den Konfigurationsdateien muss Apache neugestartet werden: `sudo systemctl restart apache2.service`

- Steuern Sie nun Ihre Website im Browser an, erreichen Sie den Nextcloudinstallationsassistenten über eine verschlüsselte HTTPS-Verbindung, erkennbar am Schlosssymbol in der Adresszeile.

- Überprüfen Sie die Stärke Ihrer HTTPS-Verbindung mit [SSLLabs](https://www.ssllabs.com/ssltest/). Dort tragen Sie Ihre Adresse ein, setzen aber den Haken bei "Do not show the results on the boards". Sie sollten ein A+-Ergebnis erhalten. Schauen Sie sich aber auch die Details des Berichts an. Evtl. sind dort noch Schwachstellen gelistet, die Sie verbessern können.

#### Fehlerbehebung

Sollte die HTTPS-Verbindung nicht erfolgreich sein, müssen Sie sich auf die Fehlersuche begeben. Hier einige Punkte, welche Sie überprüfen können:

- Ist der Raspberry Pi via localhost und im Heimnetzwerk unter seiner IP-Adresse über Port 443 erreichbar?

- Läuft der Apache-Webserver? Überprüfen Sie dessen Status mit `sudo systemctl status apache2.service`. Evtl. werden Ihnen hier bereits Fehlermeldungen angezeigt. Sie können außerdem die Apache-Log-Dateien unter `/var/log/apache2/` inspizieren

- Wurde das TLS-Zertifikat ordnungsgemäß ausgestellt? Überprüfen Sie, ob unter dem Pfad `/etc/letsencrypt/live/<server.ddns-provider.de>/ die Dateien *fullchain.pem* und *privkey.pem* vorhanden sind.

- Ist die Portweiterleitung in Ihrem Router richtig eingestellt?

- Funktioniert DDClient? (`sudo systemctl status ddlient` und `sudo ddclient --query`)

- Hat Ihr DDNS-Provider die richtige IP-Adresse für Ihre Domain eingetragen? Melden Sie sich dazu im Webportal Ihres DDNS-Providers an.

::::::::::::::::::::::::::::::::::::: keypoints 

- Unverschlüsselte HTTP-Verbindungen müssen vermieden werden.

- Für verschlüsselte HTTPS-Verbindungen muss ein TLS-Zertifikat erhalten werden.

- Mit Certbot können kostenlose Zertifikate von Letsencrypt erhalten werden.

- Für eine HTTPS-Verbindung müssen die Konfiguration des Webservers, der Firewall und des Routers angepasst werden.

::::::::::::::::::::::::::::::::::::::::::::::::

