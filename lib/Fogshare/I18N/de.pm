package Fogshare::I18N::de;
#
# Fogshare - German Lexicon (de)
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

use Mojo::Base 'Fogshare::I18N';

our %Lexicon = (

    # -------------------------------------------------------------------------
    # General & Base
    # -------------------------------------------------------------------------
    'Error'                                                    => 'Fehler',
    'Page Not Found'                                           => 'Seite nicht gefunden',
    'Not Found'                                                => 'Nicht gefunden',
    'The requested resource or sharing portal does not exist.' => 'Die angeforderte Ressource oder das Sharing-Portal existiert nicht.',
    'The requested resource was not found on this server.'     => 'Die angeforderte Ressource wurde auf diesem Server nicht gefunden.',
    'Go Back'                                                  => 'Zurück',
    'Return Home'                                              => 'Zur Startseite',
    'Toggle theme'                                             => 'Design umschalten',
    'Scan to View on Mobile'                                   => 'Auf dem Smartphone öffnen',
    'QR Code'                                                  => 'QR-Code',

    # -------------------------------------------------------------------------
    # Directory Showcase (directory.html.ep)
    # -------------------------------------------------------------------------
    'Directory Index' => 'Verzeichnisindex',
    'File Name'       => 'Dateiname',
    'Size'            => 'Größe',
    'Action'          => 'Aktion',
    '.. (Parent)'     => '.. (Übergeordnetes Verzeichnis)',
    'Download'        => 'Herunterladen',
    'Empty directory' => 'Leeres Verzeichnis',

    # -------------------------------------------------------------------------
    # Expired Notice (expired.html.ep)
    # -------------------------------------------------------------------------
    '410 Gone'                                                      => '410 Abgelaufen',
    'This share link has expired or has been revoked by the owner.' => 'Dieser Freigabe-Link ist abgelaufen oder wurde vom Eigentümer widerrufen.',

    # -------------------------------------------------------------------------
    # Gate & Access Control (gate.html.ep)
    # -------------------------------------------------------------------------
    'Protected Access'                                             => 'Geschützter Zugriff',
    'Protected Resource'                                           => 'Geschützte Ressource',
    'Please enter the passcode to access this share.'              => 'Bitte geben Sie den Passcode ein, um auf diese Freigabe zuzugreifen.',
    'Passcode'                                                     => 'Passcode',
    'Unlock'                                                       => 'Entsperren',
    'Session remains valid for 24 hours'                           => 'Sitzung bleibt für 24 Stunden gültig',
    'Invalid passcode'                                             => 'Ungültiger Passcode',
    'Too many failed attempts. Temporarily locked for 15 minutes.' => 'Zu viele Fehlversuche. Vorübergehend für 15 Minuten gesperrt.',

    # -------------------------------------------------------------------------
    # Gatekeeper / Burn-After-Reading Quota (gatekeeper.html.ep)
    # -------------------------------------------------------------------------
    'Ephemeral Access'                                              => 'Einmaliger Zugriff',
    'Ephemeral Drop'                                                => 'Einmal-Freigabe',
    'Limited drop: [_1] access slots remaining.'                    => 'Limitierte Freigabe: Noch [_1] Zugriffe übrig.',
    'Remaining Slots: [_1]'                                         => 'Verbleibende Zugriffe: [_1]',
    'Click below to claim an access slot and bind to this session.' => 'Klicken Sie unten, um einen Zugriff zu beanspruchen und an diese Sitzung zu binden.',
    'Reveal Content'                                                => 'Inhalt anzeigen',

    # -------------------------------------------------------------------------
    # Authentication (login.html.ep)
    # -------------------------------------------------------------------------
    'Admin Login'                                       => 'Administrator-Anmeldung',
    'Authenticate with your administrator credentials.' => 'Melden Sie sich mit Ihren Administrator-Zugangsdaten an.',
    'Username'                                          => 'Benutzername',
    'Password'                                          => 'Passwort',
    'Sign In'                                           => 'Anmelden',
    'Invalid username or password'                      => 'Ungültiger Benutzername oder Passwort',
    'Logged out successfully.'                          => 'Erfolgreich abgemeldet.',

    # -------------------------------------------------------------------------
    # Showcase Page (showcase.html.ep)
    # -------------------------------------------------------------------------
    'Preview not available for this file type' => 'Für diesen Dateityp ist keine Vorschau verfügbar',
    'Direct Download'                          => 'Direkter Download',

    # -------------------------------------------------------------------------
    # User Manager (users.html.ep & Controller/Users.pm)
    # -------------------------------------------------------------------------
    'Account Manager'                                                             => 'Kontoverwaltung',
    'Admin Settings'                                                              => 'Administrator-Einstellungen',
    'Manage administrator credentials for this node.'                             => 'Verwalten Sie die Administrator-Zugangsdaten für diesen Knoten.',
    'Edit'                                                                        => 'Bearbeiten',
    'Delete'                                                                      => 'Löschen',
    'You'                                                                         => 'Aktuell',
    'Delete user [_1]?'                                                           => 'Benutzer [_1] wirklich löschen?',
    'New Password'                                                                => 'Neues Passwort',
    'Save / Update'                                                               => 'Speichern / Aktualisieren',
    'Update [_1]'                                                                 => '[_1] aktualisieren',
    '← Console'                                                                   => '← Konsole',
    'Logout'                                                                      => 'Abmelden',
    'Validation failed: Username must be >= 3 chars and password >= 6 chars.'     => 'Validierungsfehler: Benutzername mindestens 3 Zeichen, Passwort mindestens 6 Zeichen.',
    'Account [_1] updated successfully.'                                          => 'Konto [_1] erfolgreich aktualisiert.',
    'Action prohibited: You cannot delete your currently logged-in account.'      => 'Aktion nicht erlaubt: Sie können Ihr aktuell angemeldetes Konto nicht löschen.',
    'Action prohibited: Cannot remove the last remaining administrative account.' => 'Aktion nicht erlaubt: Das letzte verbleibende Administratorkonto kann nicht gelöscht werden.',
    'Account [_1] removed.'                                                       => 'Konto [_1] wurde gelöscht.',

    # -------------------------------------------------------------------------
    # Admin Dashboard & Navigation
    # -------------------------------------------------------------------------
    'Dashboard'                      => 'Dashboard',
    'Manager'                        => 'Benutzerverwaltung',
    'Page [_1] of [_2] ([_3] total)' => 'Seite [_1] von [_2] (insgesamt [_3])',
    '← Prev'                         => '← Zurück',
    'Next →'                         => 'Weiter →',
    'Share link is active:'          => 'Freigabe-Link ist aktiv:',
    'Passcode:'                      => 'Passcode:',
    'Copy Info'                      => 'Info kopieren',
    'Open ↗'                         => 'Öffnen ↗',
    'Files ([_1])'                   => 'Dateien ([_1])',
    'Active ([_1])'                  => 'Aktiv ([_1])',
    'Expired ([_1])'                 => 'Abgelaufen ([_1])',
    'Trash ([_1])'                   => 'Papierkorb ([_1])',

    # -------------------------------------------------------------------------
    # Tab 1: Files
    # -------------------------------------------------------------------------
    'Drag & Drop files or folders here' => 'Dateien oder Ordner hierher ziehen und ablegen',
    'browse files'                      => 'Dateien durchsuchen',
    'browse folder'                     => 'Ordner durchsuchen',
    'Auto-extract if .zip archive'      => '.zip-Archive automatisch entpacken',
    'Preparing...'                      => 'Vorbereitung...',
    'New Subfolder Name'                => 'Neuer Unterordnername',
    'New Root Folder Name'              => 'Neuer Ordnername im Stammverzeichnis',
    'Create Folder'                     => 'Ordner erstellen',
    'alphanumeric'                      => 'alphanumerisch oder Bindestrich',
    'repository'                        => 'Dateispeicher',
    'Name'                              => 'Name',
    'Modified'                          => 'Geändert',
    'Actions'                           => 'Aktionen',
    '[_1] active'                       => '[_1] aktiv',
    'Share'                             => 'Freigeben',
    'Move'                              => 'Verschieben',
    'Copy'                              => 'Kopieren',
    'Rename'                            => 'Umbenennen',
    'Delete this item permanently?'     => 'Dieses Element dauerhaft löschen?',

    # -------------------------------------------------------------------------
    # Tab 2: Active Shares
    # -------------------------------------------------------------------------
    'Active Shares ([_1])'             => 'Aktive Freigaben ([_1])',
    'Cute Slug'                        => 'Slug / Kurzlink',
    'Target'                           => 'Zielpfad',
    'Auth'                             => 'Authentifizierung',
    'TTL Remaining'                    => 'Verbleibende Gültigkeit',
    'Views / Quota'                    => 'Aufrufe / Kontingent',
    'Pronounce'                        => 'Aussprache anhören',
    'Click to copy pwd'                => 'Klicken, um Passwort zu kopieren',
    'Public'                           => 'Öffentlich',
    'Never'                            => 'Unbegrenzt',
    '[_1] slots'                       => '[_1] Zugriffe',
    '[_1] ago'                         => 'vor [_1]',
    'Move this active share to trash?' => 'Diese aktive Freigabe in den Papierkorb verschieben?',

    # -------------------------------------------------------------------------
    # Tab 3: Expired Shares
    # -------------------------------------------------------------------------
    'Expired Shares ([_1])'                  => 'Abgelaufene Freigaben ([_1])',
    'Move Selected to Trash'                 => 'Auswahl in den Papierkorb',
    'Move selected expired shares to trash?' => 'Ausgewählte abgelaufene Freigaben in den Papierkorb verschieben?',
    'Reason / Expired At'                    => 'Grund / Ablaufzeit',
    'Quota Exhausted'                        => 'Kontingent aufgebraucht',
    'Revoked'                                => 'Widerrufen',
    'Renew & Edit'                           => 'Erneuern & Bearbeiten',
    'To Trash'                               => 'In den Papierkorb',
    'Move share [_1] to trash?'              => 'Freigabe [_1] in den Papierkorb verschieben?',
    'No expired shares'                      => 'Keine abgelaufenen Freigaben',

    # -------------------------------------------------------------------------
    # Tab 4: Trash
    # -------------------------------------------------------------------------
    'Trash'                                                                 => 'Papierkorb',
    'Empty Trash'                                                           => 'Papierkorb leeren',
    'WARNING: Permanently purge all items in trash? This cannot be undone.' => 'WARNUNG: Alle Elemente im Papierkorb endgültig löschen? Dies kann nicht rückgängig gemacht werden.',
    'Original Lifespan'                                                     => 'Ursprüngliche Gültigkeit',
    'Config: [_1][_2]'                                                      => 'Konfig.: [_1][_2]',
    'Permanent'                                                             => 'Unbegrenzt',
    'Restore'                                                               => 'Wiederherstellen',
    'Purge'                                                                 => 'Endgültig löschen',
    'Purge this config permanently?'                                        => 'Diese Konfiguration endgültig löschen?',
    'Trash is empty'                                                        => 'Der Papierkorb ist leer',

    # -------------------------------------------------------------------------
    # Flash Notifications & Controller Error Messages
    # -------------------------------------------------------------------------
    'Share [_1] moved to Trash.'                                                           => 'Freigabe [_1] in den Papierkorb verschoben.',
    'Share [_1] purged permanently.'                                                       => 'Freigabe [_1] endgültig gelöscht.',
    'Moved [_1] selected share(s) to Trash.'                                               => '[_1] ausgewählte Freigabe(n) in den Papierkorb verschoben.',
    'Moved [_1] expired shares to Trash.'                                                  => '[_1] abgelaufene Freigaben in den Papierkorb verschoben.',
    'Purged [_1] items permanently from Trash.'                                            => '[_1] Elemente endgültig aus dem Papierkorb gelöscht.',
    'Renamed to [_1] successfully.'                                                        => 'Erfolgreich in [_1] umbenannt.',
    'Moved [_1] successfully.'                                                             => '[_1] erfolgreich verschoben.',
    'Copied [_1] successfully.'                                                            => '[_1] erfolgreich kopiert.',
    'Directory [_1] deleted permanently.'                                                  => 'Verzeichnis [_1] endgültig gelöscht.',
    'File [_1] deleted permanently.'                                                       => 'Datei [_1] endgültig gelöscht.',
    'The slug [_1] is a reserved system keyword.'                                          => 'Der Slug [_1] ist ein reserviertes System-Schlüsselwort.',
    'Share config [_1] not found anywhere.'                                                => 'Freigabekonfiguration [_1] nirgendwo gefunden.',
    'Invalid JSON payload for [_1].'                                                       => 'Ungültige JSON-Nutzlast für [_1].',
    'Target [_1] missing on disk. Cleaned.'                                                => 'Zielpfad [_1] fehlt auf dem Datenträger. Bereinigt.',
    'Modification prohibited: Resource actively occupied by [_1]. Revoke the share first.' => 'Änderung verboten: Ressource wird aktiv von [_1] verwendet. Widerrufen Sie zuerst die Freigabe.',
    'Move prohibited: Resource actively occupied by [_1]. Revoke share first.'             => 'Verschieben verboten: Ressource wird aktiv von [_1] verwendet. Widerrufen Sie zuerst die Freigabe.',
    'Deletion prohibited: Resource actively occupied by [_1]. Revoke the share first.'     => 'Löschen verboten: Ressource wird aktiv von [_1] verwendet. Widerrufen Sie zuerst die Freigabe.',
    'Move failed: Target entity [_1] already exists in destination.'                       => 'Verschieben fehlgeschlagen: Am Zielort existiert bereits ein Element namens [_1].',
    'Copy failed: Target entity [_1] already exists in destination.'                       => 'Kopieren fehlgeschlagen: Am Zielort existiert bereits ein Element namens [_1].',
    'Upload rejected: [_1]'                                                                => 'Upload abgelehnt: [_1]',
    'Invalid folder name.'                                                                 => 'Ungültiger Ordnername.',
    'Security Alert: CSRF token validation failed. Action rejected.'                       => 'Sicherheitswarnung: CSRF-Token-Validierung fehlgeschlagen. Aktion abgelehnt.',
    'Security Alert: Directory traversal detected.'                                        => 'Sicherheitswarnung: Verzeichnisüberschreitung (Directory Traversal) erkannt.',
    'Security Alert: Access to hidden or system files is strictly restricted.'             => 'Sicherheitswarnung: Zugriff auf versteckte oder Systemdateien ist strengstens untersagt.',
    'Security Alert: Unauthorized deletion path.'                                          => 'Sicherheitswarnung: Unbefugter Löschpfad.',
    'Move failed: Invalid source or destination path.'                                     => 'Verschieben fehlgeschlagen: Ungültiger Quell- oder Zielpfad.',
    'Move failed: Cannot move a directory into its own subdirectory.'                      => 'Verschieben fehlgeschlagen: Ein Ordner kann nicht in sein eigenes Unterverzeichnis verschoben werden.',
    'Copy failed: Invalid source or destination path.'                                     => 'Kopieren fehlgeschlagen: Ungültiger Quell- oder Zielpfad.',

    # -------------------------------------------------------------------------
    # Guest & Delivery Handlers (新增補充)
    # -------------------------------------------------------------------------
    'Internal Server Error'                                             => 'Interner Serverfehler',
    'Corrupted share metadata configuration.'                           => 'Beschädigte Freigabe-Metadatenkonfiguration.',
    'Forbidden'                                                         => 'Zugriff verweigert',
    'Automated access detected.'                                        => 'Automatisierter Bot- oder Crawler-Zugriff erkannt.',
    'Too Many Requests'                                                 => 'Zu viele Anfragen',
    'Too many verification attempts. Please wait.'                      => 'Zu viele Bestätigungsversuche. Bitte warten Sie einen Moment.',
    'Unauthorized'                                                      => 'Nicht autorisiert',
    'Reserved endpoint'                                                 => 'Reservierter System-Endpunkt',
    'Target Missing'                                                    => 'Ziel nicht gefunden',
    'The underlying file or directory has been removed from storage.'   => 'Die zugrunde liegende Datei oder das Verzeichnis wurde aus dem Speicher entfernt.',
    'Target [_1] does not exist.'                                       => 'Ziel [_1] existiert nicht.',
    'Directory traversal or unauthorized path access detected.'         => 'Verzeichnisüberschreitung oder unbefugter Pfadzugriff erkannt.',
    'Access Denied'                                                     => 'Zugriff verweigert',
    'Access to hidden files or system metadata is strictly prohibited.' => 'Zugriff auf versteckte Dateien oder System-Metadaten ist strengstens untersagt.',
    'Library Not Found'                                                 => 'Bibliothek nicht gefunden',
    'Virtual shared library [_1] does not exist in libs/.'              => 'Virtuelle freigegebene Bibliothek [_1] existiert nicht in libs/.',

    # -------------------------------------------------------------------------
    # Dialogs & Form Labels
    # -------------------------------------------------------------------------
    'New Share Link'                                           => 'Neuen Freigabe-Link erstellen',
    'Lifespan (0 = Permanent)'                                 => 'Gültigkeitsdauer (0 = Unbegrenzt)',
    'Max Access Slots (0 = Unlimited / No Burn)'               => 'Max. Zugriffe (0 = Unbegrenzt / Kein Auto-Löschen)',
    'Custom Cute Slug (Optional)'                              => 'Benutzerdefinierter Slug (Optional)',
    'Access Password (Plain text, optional)'                   => 'Zugangspasswort (Klartext, optional)',
    'Note (Shown on showcase page)'                            => 'Hinweis (Wird auf der Freigabeseite angezeigt)',
    'Cancel'                                                   => 'Abbrechen',
    'Create'                                                   => 'Erstellen',
    'Edit / Restore Share'                                     => 'Freigabe bearbeiten / wiederherstellen',
    'Target (Change file or directory to switch version)'      => 'Ziel (Datei oder Ordner ändern, um Version zu wechseln)',
    'Type to search paths...'                                  => 'Tippen, um Pfade zu suchen...',
    'New Lifespan (0 = Permanent)'                             => 'Neue Gültigkeitsdauer (0 = Unbegrenzt)',
    'Max Access Slots (0 = Unlimited)'                         => 'Max. Zugriffe (0 = Unbegrenzt)',
    'Password (Leave empty to keep, type __CLEAR__ to remove)' => 'Passwort (leer lassen zum Beibehalten, __CLEAR__ zum Entfernen)',
    'Save & Activate'                                          => 'Speichern & Aktivieren',
    'Confirm'                                                  => 'Bestätigen',
    'Move Resource'                                            => 'Ressource verschieben',
    'Copy Resource'                                            => 'Ressource kopieren',
    'Destination Directory (Empty for root level)'             => 'Zielverzeichnis (leer lassen für Stammebene)',
    'Type to search folders...'                                => 'Tippen, um Ordner zu suchen...',
    'Confirm Move'                                             => 'Verschieben bestätigen',
    'Confirm Copy'                                             => 'Kopieren bestätigen',
    'Root directory'                                           => 'Stammverzeichnis',
    'Gen'                                                      => 'Gen',
    'Leave empty to keep intact'                               => 'Leer lassen, um beizubehalten',
    'Note'                                                     => 'Hinweis',
    'e.g. Project assets download'                             => 'z. B. Projektdateien-Download',
    'Leave empty for public access'                            => 'Leer lassen für öffentlichen Zugriff',
    'New Name'                                                 => 'Neuer Name',

    # -------------------------------------------------------------------------
    # Time Units & Countdown
    # -------------------------------------------------------------------------
    'Seconds' => 'Sekunden',
    'Minutes' => 'Minuten',
    'Hours'   => 'Stunden',
    'Days'    => 'Tage',
    'Weeks'   => 'Wochen',
    'Months'  => 'Monate',
    'Years'   => 'Jahre',
    's left'  => 's verbleibend',
    'm left'  => 'm verbleibend',
    'h left'  => 'h verbleibend',
    'd left'  => 'd verbleibend',
    'Expired' => 'Abgelaufen',

    # -------------------------------------------------------------------------
    # Client-Side JavaScript Strings
    # -------------------------------------------------------------------------
    'Copied link: [_1]'                     => 'Link kopiert: [_1]',
    'Copy manually:'                        => 'Manuell kopieren:',
    'Uploading [_1] file(s)... ([_2]%)'     => '[_1] Datei(en) werden hochgeladen... ([_2]%)',
    'Upload failed: '                       => 'Upload fehlgeschlagen: ',
    'Network error occurred during upload.' => 'Beim Hochladen ist ein Netzwerkfehler aufgetreten.',

    # -------------------------------------------------------------------------
    # Default Public Portal
    # -------------------------------------------------------------------------
    'File Sharing Node'                        => 'Dateifreigabe-Knoten',
    'Private sharing portal is active.'        => 'Privates Freigabeportal ist aktiv.',
    'Direct access requires a dedicated link.' => 'Direkter Zugriff erfordert einen dedizierten Link.',
);

1;
