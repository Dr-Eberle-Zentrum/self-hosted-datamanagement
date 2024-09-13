---
title: 'Installation und Konfiguration'
teaching: 45
exercises: 90
---

:::::::::::::::::::::::::::::::::::::: questions 

- Wie installiere ich Nextcloud?

- Wie kann ich die Installation anpassen?

- Welche Optimierungen gibt es?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Nextcloud im Webbrowser installieren

- Nextcloud im Browser verwalten

- Nextcloud über die CMD verwalten

- Caching konfigurieren

::::::::::::::::::::::::::::::::::::::::::::::::

## Installation

Nachdem in den vorhrgehenden Lektionen die Installationsdateien heruntergeladen und druch Apache über eine HTTPS-Verbindung zur Verfügung gestellt werden, kann die eigentliche Installation beginnen. Dazu ruft man die eigen Domain im Webbrowser auf. Dort sollte der Nextcloudinstallationsassistent erreicht werden.

Im Assistenten muss ein Adminstrator-Konto für Nextcloud mit Username und Passwort angelegt werden. Es müssen außerdem die Zugangsdaten für die in [Lektion 9](09-installationsvorbereitung.Rmd) erstellte Datenbank eingegeben werden. Da auch das Datenverzeichnis in einem angepassten Pfad auf dem externen Speicher liegen soll (z.B. `/mnt/data/ncdata`), muss auch der Standardpfad für das Datenverzeichnis angepasst werden.

Mehr zum Installationsassistenten findet sich auch im [Handbuch](https://docs.nextcloud.com/server/stable/admin_manual/installation/installation_wizard.html).

## Konfiguration

Nach der Installation kann und sollte Nextcloud weiter konfiguriert werden, um das System zu optimieren und seinen Bedürfnissen anzupassen. Dafür bietet Nextcloud drei unterschiedliche Möglichkeiten an, die teilweise dieselben Konfigurationsmöglichkeiten anbieten, teilweise aber auch unterschiedliche.

- Konfiguration über die Weboberfläche

- Konfiguration auf der Kommandozeile mit dem OCC-Tool

- Konfiguration in der Datei `/var/www/nextcloud/config/config.php`

### Weboberfläche

### OCC-Tool

### Konfigurationsdatei

## Caching
::::::::::::::::::::::::::::::::::::: keypoints 

- 

::::::::::::::::::::::::::::::::::::::::::::::::

