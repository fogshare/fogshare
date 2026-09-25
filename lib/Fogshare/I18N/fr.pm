package Fogshare::I18N::fr;
#
# Fogshare - French Lexicon (fr)
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

use Mojo::Base 'Fogshare::I18N';

our %Lexicon = (

    # -------------------------------------------------------------------------
    # General & Base
    # -------------------------------------------------------------------------
    'Error'                                                    => 'Erreur',
    'Page Not Found'                                           => 'Page non trouvée',
    'Not Found'                                                => 'Introuvable',
    'The requested resource or sharing portal does not exist.' => 'La ressource demandée ou le portail de partage n’existe pas.',
    'The requested resource was not found on this server.'     => 'La ressource demandée est introuvable sur ce serveur.',
    'Go Back'                                                  => 'Retour',
    'Return Home'                                              => 'Retour à l’accueil',
    'Toggle theme'                                             => 'Changer de thème',
    'Scan to View on Mobile'                                   => 'Ouvrir sur mobile',
    'QR Code'                                                  => 'Code QR',

    # -------------------------------------------------------------------------
    # Directory Showcase (directory.html.ep)
    # -------------------------------------------------------------------------
    'Directory Index' => 'Index du répertoire',
    'File Name'       => 'Nom du fichier',
    'Size'            => 'Taille',
    'Action'          => 'Action',
    '.. (Parent)'     => '.. (Dossier parent)',
    'Download'        => 'Télécharger',
    'Empty directory' => 'Répertoire vide',

    # -------------------------------------------------------------------------
    # Expired Notice (expired.html.ep)
    # -------------------------------------------------------------------------
    '410 Gone'                                                      => '410 Expiré',
    'This share link has expired or has been revoked by the owner.' => 'Ce lien de partage a expiré ou a été révoqué par son propriétaire.',

    # -------------------------------------------------------------------------
    # Gate & Access Control (gate.html.ep)
    # -------------------------------------------------------------------------
    'Protected Access'                                             => 'Accès protégé',
    'Protected Resource'                                           => 'Ressource protégée',
    'Please enter the passcode to access this share.'              => 'Veuillez saisir le code d’accès pour ouvrir ce partage.',
    'Passcode'                                                     => 'Code d’accès',
    'Unlock'                                                       => 'Déverrouiller',
    'Session remains valid for 24 hours'                           => 'La session reste valide pendant 24 heures',
    'Invalid passcode'                                             => 'Code d’accès incorrect',
    'Too many failed attempts. Temporarily locked for 15 minutes.' => 'Trop de tentatives échouées. Verrouillé temporairement pendant 15 minutes.',

    # -------------------------------------------------------------------------
    # Gatekeeper / Burn-After-Reading Quota (gatekeeper.html.ep)
    # -------------------------------------------------------------------------
    'Ephemeral Access'                                              => 'Accès éphémère',
    'Ephemeral Drop'                                                => 'Partage éphémère',
    'Limited drop: [_1] access slots remaining.'                    => 'Partage limité : encore [_1] accès disponible(s).',
    'Remaining Slots: [_1]'                                         => 'Accès restants : [_1]',
    'Click below to claim an access slot and bind to this session.' => 'Cliquez ci-dessous pour consommer un accès et le lier à cette session.',
    'Reveal Content'                                                => 'Afficher le contenu',

    # -------------------------------------------------------------------------
    # Authentication (login.html.ep)
    # -------------------------------------------------------------------------
    'Admin Login'                                       => 'Connexion administrateur',
    'Authenticate with your administrator credentials.' => 'Connectez-vous avec vos identifiants d’administrateur.',
    'Username'                                          => 'Nom d’utilisateur',
    'Password'                                          => 'Mot de passe',
    'Sign In'                                           => 'Se connecter',
    'Invalid username or password'                      => 'Nom d’utilisateur ou mot de passe invalide',
    'Logged out successfully.'                          => 'Déconnexion réussie.',

    # -------------------------------------------------------------------------
    # Showcase Page (showcase.html.ep)
    # -------------------------------------------------------------------------
    'Preview not available for this file type' => 'Aperçu non disponible pour ce type de fichier',
    'Direct Download'                          => 'Téléchargement direct',

    # -------------------------------------------------------------------------
    # User Manager (users.html.ep & Controller/Users.pm)
    # -------------------------------------------------------------------------
    'Account Manager'                                                             => 'Gestion des comptes',
    'Admin Settings'                                                              => 'Configuration administrateur',
    'Manage administrator credentials for this node.'                             => 'Gérer les identifiants administrateur de ce nœud.',
    'Edit'                                                                        => 'Modifier',
    'Delete'                                                                      => 'Supprimer',
    'You'                                                                         => 'Actuel',
    'Delete user [_1]?'                                                           => 'Supprimer l’utilisateur [_1] ?',
    'New Password'                                                                => 'Nouveau mot de passe',
    'Save / Update'                                                               => 'Enregistrer / Mettre à jour',
    'Update [_1]'                                                                 => 'Mettre à jour [_1]',
    '← Console'                                                                   => '← Console',
    'Logout'                                                                      => 'Déconnexion',
    'Validation failed: Username must be >= 3 chars and password >= 6 chars.'     => 'Échec de validation : le nom d’utilisateur doit comporter au moins 3 caractères et le mot de passe au moins 6.',
    'Account [_1] updated successfully.'                                          => 'Compte [_1] mis à jour avec succès.',
    'Action prohibited: You cannot delete your currently logged-in account.'      => 'Action interdite : vous ne pouvez pas supprimer le compte actuellement connecté.',
    'Action prohibited: Cannot remove the last remaining administrative account.' => 'Action interdite : impossible de supprimer le dernier compte administrateur restant.',
    'Account [_1] removed.'                                                       => 'Compte [_1] supprimé.',

    # -------------------------------------------------------------------------
    # Admin Dashboard & Navigation
    # -------------------------------------------------------------------------
    'Dashboard'                      => 'Tableau de bord',
    'Manager'                        => 'Gestion des utilisateurs',
    'Page [_1] of [_2] ([_3] total)' => 'Page [_1] sur [_2] ([_3] au total)',
    '← Prev'                         => '← Précédent',
    'Next →'                         => 'Suivant →',
    'Share link is active:'          => 'Le lien de partage est actif :',
    'Passcode:'                      => 'Code d’accès :',
    'Copy Info'                      => 'Copier les infos',
    'Open ↗'                         => 'Ouvrir ↗',
    'Files ([_1])'                   => 'Fichiers ([_1])',
    'Active ([_1])'                  => 'Actifs ([_1])',
    'Expired ([_1])'                 => 'Expirés ([_1])',
    'Trash ([_1])'                   => 'Corbeille ([_1])',

    # -------------------------------------------------------------------------
    # Tab 1: Files
    # -------------------------------------------------------------------------
    'Drag & Drop files or folders here' => 'Glissez-déposez des fichiers ou dossiers ici',
    'browse files'                      => 'parcourir les fichiers',
    'browse folder'                     => 'parcourir les dossiers',
    'Auto-extract if .zip archive'      => 'Extraire automatiquement si archive .zip',
    'Preparing...'                      => 'Préparation...',
    'New Subfolder Name'                => 'Nom du nouveau sous-dossier',
    'New Root Folder Name'              => 'Nom du dossier racine',
    'Create Folder'                     => 'Créer un dossier',
    'alphanumeric'                      => 'alphanumérique ou tirets',
    'repository'                        => 'dépôt',
    'Name'                              => 'Nom',
    'Modified'                          => 'Modifié le',
    'Actions'                           => 'Actions',
    '[_1] active'                       => '[_1] actif(s)',
    'Share'                             => 'Partager',
    'Move'                              => 'Déplacer',
    'Copy'                              => 'Copier',
    'Rename'                            => 'Renommer',
    'Delete this item permanently?'     => 'Supprimer définitivement cet élément ?',

    # -------------------------------------------------------------------------
    # Tab 2: Active Shares
    # -------------------------------------------------------------------------
    'Active Shares ([_1])'             => 'Partages actifs ([_1])',
    'Cute Slug'                        => 'Identifiant court (Slug)',
    'Target'                           => 'Cible',
    'Auth'                             => 'Authentification',
    'TTL Remaining'                    => 'Durée restante',
    'Views / Quota'                    => 'Vues / Quota',
    'Pronounce'                        => 'Écouter la prononciation',
    'Click to copy pwd'                => 'Cliquer pour copier le mot de passe',
    'Public'                           => 'Public',
    'Never'                            => 'Illimité',
    '[_1] slots'                       => '[_1] accès',
    '[_1] ago'                         => 'il y a [_1]',
    'Move this active share to trash?' => 'Déplacer ce partage actif vers la corbeille ?',

    # -------------------------------------------------------------------------
    # Tab 3: Expired Shares
    # -------------------------------------------------------------------------
    'Expired Shares ([_1])'                  => 'Partages expirés ([_1])',
    'Move Selected to Trash'                 => 'Déplacer la sélection vers la corbeille',
    'Move selected expired shares to trash?' => 'Déplacer les partages expirés sélectionnés vers la corbeille ?',
    'Reason / Expired At'                    => 'Raison / Expiration',
    'Quota Exhausted'                        => 'Quota épuisé',
    'Revoked'                                => 'Révoqué',
    'Renew & Edit'                           => 'Renouveler et modifier',
    'To Trash'                               => 'À la corbeille',
    'Move share [_1] to trash?'              => 'Déplacer le partage [_1] vers la corbeille ?',
    'No expired shares'                      => 'Aucun partage expiré',

    # -------------------------------------------------------------------------
    # Tab 4: Trash
    # -------------------------------------------------------------------------
    'Trash'                                                                 => 'Corbeille',
    'Empty Trash'                                                           => 'Vider la corbeille',
    'WARNING: Permanently purge all items in trash? This cannot be undone.' => 'ATTENTION : supprimer définitivement tous les éléments de la corbeille ? Cette action est irréversible.',
    'Original Lifespan'                                                     => 'Durée initiale',
    'Config: [_1][_2]'                                                      => 'Config : [_1][_2]',
    'Permanent'                                                             => 'Illimité',
    'Restore'                                                               => 'Restaurer',
    'Purge'                                                                 => 'Purger',
    'Purge this config permanently?'                                        => 'Supprimer définitivement cette configuration ?',
    'Trash is empty'                                                        => 'La corbeille est vide',

    # -------------------------------------------------------------------------
    # Flash Notifications & Controller Error Messages
    # -------------------------------------------------------------------------
    'Share [_1] moved to Trash.'                                                           => 'Partage [_1] déplacé vers la corbeille.',
    'Share [_1] purged permanently.'                                                       => 'Partage [_1] purgé définitivement.',
    'Moved [_1] selected share(s) to Trash.'                                               => '[_1] partage(s) sélectionné(s) déplacé(s) vers la corbeille.',
    'Moved [_1] expired shares to Trash.'                                                  => '[_1] partage(s) expiré(s) déplacé(s) vers la corbeille.',
    'Purged [_1] items permanently from Trash.'                                            => '[_1] élément(s) purgé(s) définitivement de la corbeille.',
    'Renamed to [_1] successfully.'                                                        => 'Renommé en [_1] avec succès.',
    'Moved [_1] successfully.'                                                             => '[_1] déplacé avec succès.',
    'Copied [_1] successfully.'                                                            => '[_1] copié avec succès.',
    'Directory [_1] deleted permanently.'                                                  => 'Dossier [_1] supprimé définitivement.',
    'File [_1] deleted permanently.'                                                       => 'Fichier [_1] supprimé définitivement.',
    'The slug [_1] is a reserved system keyword.'                                          => 'Le slug [_1] est un mot-clé réservé du système.',
    'Share config [_1] not found anywhere.'                                                => 'Configuration du partage [_1] introuvable.',
    'Invalid JSON payload for [_1].'                                                       => 'Données JSON invalides pour [_1].',
    'Target [_1] missing on disk. Cleaned.'                                                => 'La cible [_1] est absente du disque. Nettoyé.',
    'Modification prohibited: Resource actively occupied by [_1]. Revoke the share first.' => 'Modification interdite : ressource activement occupée par [_1]. Révoquez d’abord le partage.',
    'Move prohibited: Resource actively occupied by [_1]. Revoke share first.'             => 'Déplacement interdit : ressource activement occupée par [_1]. Révoquez d’abord le partage.',
    'Deletion prohibited: Resource actively occupied by [_1]. Revoke the share first.'     => 'Suppression interdite : ressource activement occupée par [_1]. Révoquez d’abord le partage.',
    'Move failed: Target entity [_1] already exists in destination.'                       => 'Échec du déplacement : l’entité cible [_1] existe déjà à destination.',
    'Copy failed: Target entity [_1] already exists in destination.'                       => 'Échec de la copie : l’entité cible [_1] existe déjà à destination.',
    'Upload rejected: [_1]'                                                                => 'Téléversement rejeté : [_1]',
    'Invalid folder name.'                                                                 => 'Nom de dossier invalide.',
    'Security Alert: CSRF token validation failed. Action rejected.'                       => 'Alerte de sécurité : échec de validation du jeton CSRF. Action rejetée.',
    'Security Alert: Directory traversal detected.'                                        => 'Alerte de sécurité : tentative de traversée de répertoire détectée.',
    'Security Alert: Access to hidden or system files is strictly restricted.'             => 'Alerte de sécurité : l’accès aux fichiers cachés ou système est strictement interdit.',
    'Security Alert: Unauthorized deletion path.'                                          => 'Alerte de sécurité : chemin de suppression non autorisé.',
    'Move failed: Invalid source or destination path.'                                     => 'Échec du déplacement : chemin source ou destination invalide.',
    'Move failed: Cannot move a directory into its own subdirectory.'                      => 'Échec du déplacement : impossible de déplacer un dossier dans son propre sous-dossier.',
    'Copy failed: Invalid source or destination path.'                                     => 'Échec de la copie : chemin source ou destination invalide.',

    # -------------------------------------------------------------------------
    # Guest & Delivery Handlers (新增補充)
    # -------------------------------------------------------------------------
    'Internal Server Error'                                             => 'Erreur interne du serveur',
    'Corrupted share metadata configuration.'                           => 'Configuration des métadonnées de partage corrompue.',
    'Forbidden'                                                         => 'Accès refusé',
    'Automated access detected.'                                        => 'Accès automatisé de robots ou crawlers détecté.',
    'Too Many Requests'                                                 => 'Trop de requêtes',
    'Too many verification attempts. Please wait.'                      => 'Trop de tentatives de vérification. Veuillez patienter.',
    'Unauthorized'                                                      => 'Non autorisé',
    'Reserved endpoint'                                                 => 'Point de terminaison réservé au système',
    'Target Missing'                                                    => 'Cible introuvable',
    'The underlying file or directory has been removed from storage.'   => 'Le fichier ou dossier sous-jacent a été supprimé du stockage.',
    'Target [_1] does not exist.'                                       => 'La cible [_1] n’existe pas.',
    'Directory traversal or unauthorized path access detected.'         => 'Traversée de répertoire ou accès non autorisé au chemin détecté.',
    'Access Denied'                                                     => 'Accès refusé',
    'Access to hidden files or system metadata is strictly prohibited.' => 'L’accès aux fichiers cachés ou aux métadonnées système est strictement interdit.',
    'Library Not Found'                                                 => 'Bibliothèque introuvable',
    'Virtual shared library [_1] does not exist in libs/.'              => 'La bibliothèque virtuelle partagée [_1] n’existe pas dans libs/.',

    # -------------------------------------------------------------------------
    # Dialogs & Form Labels
    # -------------------------------------------------------------------------
    'New Share Link'                                           => 'Nouveau lien de partage',
    'Lifespan (0 = Permanent)'                                 => 'Durée de validité (0 = Illimité)',
    'Max Access Slots (0 = Unlimited / No Burn)'               => 'Nombre max d’accès (0 = Illimité / Pas d’autodestruction)',
    'Custom Cute Slug (Optional)'                              => 'Slug personnalisé (Optionnel)',
    'Access Password (Plain text, optional)'                   => 'Mot de passe d’accès (Texte brut, optionnel)',
    'Note (Shown on showcase page)'                            => 'Note (Affichée sur la page de partage)',
    'Cancel'                                                   => 'Annuler',
    'Create'                                                   => 'Créer',
    'Edit / Restore Share'                                     => 'Modifier / Restaurer le partage',
    'Target (Change file or directory to switch version)'      => 'Cible (Changer de fichier ou dossier pour modifier la version)',
    'Type to search paths...'                                  => 'Taper pour chercher un chemin...',
    'New Lifespan (0 = Permanent)'                             => 'Nouvelle durée de validité (0 = Illimité)',
    'Max Access Slots (0 = Unlimited)'                         => 'Nombre max d’accès (0 = Illimité)',
    'Password (Leave empty to keep, type __CLEAR__ to remove)' => 'Mot de passe (Laisser vide pour conserver, __CLEAR__ pour supprimer)',
    'Save & Activate'                                          => 'Enregistrer et activer',
    'Confirm'                                                  => 'Confirmer',
    'Move Resource'                                            => 'Déplacer la ressource',
    'Copy Resource'                                            => 'Copier la ressource',
    'Destination Directory (Empty for root level)'             => 'Dossier de destination (Laisser vide pour la racine)',
    'Type to search folders...'                                => 'Taper pour chercher un dossier...',
    'Confirm Move'                                             => 'Confirmer le déplacement',
    'Confirm Copy'                                             => 'Confirmer la copie',
    'Root directory'                                           => 'Dossier racine',
    'Gen'                                                      => 'Générer',
    'Leave empty to keep intact'                               => 'Laisser vide pour conserver',
    'Note'                                                     => 'Note',
    'e.g. Project assets download'                             => 'ex. Téléchargement des ressources du projet',
    'Leave empty for public access'                            => 'Laisser vide pour un accès public',
    'New Name'                                                 => 'Nouveau nom',

    # -------------------------------------------------------------------------
    # Time Units & Countdown
    # -------------------------------------------------------------------------
    'Seconds' => 'secondes',
    'Minutes' => 'minutes',
    'Hours'   => 'heures',
    'Days'    => 'jours',
    'Weeks'   => 'semaines',
    'Months'  => 'mois',
    'Years'   => 'ans',
    's left'  => 's restante(s)',
    'm left'  => 'm restante(s)',
    'h left'  => 'h restante(s)',
    'd left'  => 'j restant(s)',
    'Expired' => 'Expiré',

    # -------------------------------------------------------------------------
    # Client-Side JavaScript Strings
    # -------------------------------------------------------------------------
    'Copied link: [_1]'                     => 'Lien copié : [_1]',
    'Copy manually:'                        => 'Copier manuellement :',
    'Uploading [_1] file(s)... ([_2]%)'     => 'Téléversement de [_1] fichier(s)... ([_2]%)',
    'Upload failed: '                       => 'Échec du téléversement : ',
    'Network error occurred during upload.' => 'Une erreur réseau est survenue pendant le téléversement.',

    # -------------------------------------------------------------------------
    # Default Public Portal
    # -------------------------------------------------------------------------
    'File Sharing Node'                        => 'Nœud de partage de fichiers',
    'Private sharing portal is active.'        => 'Le portail de partage privé est actif.',
    'Direct access requires a dedicated link.' => 'L’accès direct nécessite un lien dédié.',
);

1;
