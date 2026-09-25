package Fogshare::I18N::es;
#
# Fogshare - Spanish Lexicon (es)
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

use Mojo::Base 'Fogshare::I18N';

our %Lexicon = (

    # -------------------------------------------------------------------------
    # General & Base
    # -------------------------------------------------------------------------
    'Error'                                                    => 'Error',
    'Page Not Found'                                           => 'Página no encontrada',
    'Not Found'                                                => 'No encontrado',
    'The requested resource or sharing portal does not exist.' => 'El recurso solicitado o el portal de compartición no existe.',
    'The requested resource was not found on this server.'     => 'El recurso solicitado no se encontró en este servidor.',
    'Go Back'                                                  => 'Volver',
    'Return Home'                                              => 'Volver al inicio',
    'Toggle theme'                                             => 'Cambiar tema',
    'Scan to View on Mobile'                                   => 'Abrir en el móvil',
    'QR Code'                                                  => 'Código QR',

    # -------------------------------------------------------------------------
    # Directory Showcase (directory.html.ep)
    # -------------------------------------------------------------------------
    'Directory Index' => 'Índice del directorio',
    'File Name'       => 'Nombre del archivo',
    'Size'            => 'Tamaño',
    'Action'          => 'Acción',
    '.. (Parent)'     => '.. (Directorio superior)',
    'Download'        => 'Descargar',
    'Empty directory' => 'Directorio vacío',

    # -------------------------------------------------------------------------
    # Expired Notice (expired.html.ep)
    # -------------------------------------------------------------------------
    '410 Gone'                                                      => '410 Expirado',
    'This share link has expired or has been revoked by the owner.' => 'Este enlace de compartición ha caducado o ha sido revocado por el propietario.',

    # -------------------------------------------------------------------------
    # Gate & Access Control (gate.html.ep)
    # -------------------------------------------------------------------------
    'Protected Access'                                             => 'Acceso protegido',
    'Protected Resource'                                           => 'Recurso protegido',
    'Please enter the passcode to access this share.'              => 'Introduce el código de acceso para abrir este recurso.',
    'Passcode'                                                     => 'Código de acceso',
    'Unlock'                                                       => 'Desbloquear',
    'Session remains valid for 24 hours'                           => 'La sesión permanece válida durante 24 horas',
    'Invalid passcode'                                             => 'Código de acceso no válido',
    'Too many failed attempts. Temporarily locked for 15 minutes.' => 'Demasiados intentos fallidos. Bloqueado temporalmente durante 15 minutos.',

    # -------------------------------------------------------------------------
    # Gatekeeper / Burn-After-Reading Quota (gatekeeper.html.ep)
    # -------------------------------------------------------------------------
    'Ephemeral Access'                                              => 'Acceso efímero',
    'Ephemeral Drop'                                                => 'Entrega efímera',
    'Limited drop: [_1] access slots remaining.'                    => 'Acceso limitado: queda(n) [_1] acceso(s).',
    'Remaining Slots: [_1]'                                         => 'Accesos restantes: [_1]',
    'Click below to claim an access slot and bind to this session.' => 'Haz clic abajo para consumir un acceso y vincularlo a esta sesión.',
    'Reveal Content'                                                => 'Ver contenido',

    # -------------------------------------------------------------------------
    # Authentication (login.html.ep)
    # -------------------------------------------------------------------------
    'Admin Login'                                       => 'Inicio de sesión de administrador',
    'Authenticate with your administrator credentials.' => 'Inicia sesión con tus credenciales de administrador.',
    'Username'                                          => 'Usuario',
    'Password'                                          => 'Contraseña',
    'Sign In'                                           => 'Entrar',
    'Invalid username or password'                      => 'Usuario o contraseña no válidos',
    'Logged out successfully.'                          => 'Sesión cerrada correctamente.',

    # -------------------------------------------------------------------------
    # Showcase Page (showcase.html.ep)
    # -------------------------------------------------------------------------
    'Preview not available for this file type' => 'Vista previa no disponible para este tipo de archivo',
    'Direct Download'                          => 'Descarga directa',

    # -------------------------------------------------------------------------
    # User Manager (users.html.ep & Controller/Users.pm)
    # -------------------------------------------------------------------------
    'Account Manager'                                                             => 'Gestión de cuentas',
    'Admin Settings'                                                              => 'Configuración de administrador',
    'Manage administrator credentials for this node.'                             => 'Administra las credenciales de este nodo.',
    'Edit'                                                                        => 'Editar',
    'Delete'                                                                      => 'Eliminar',
    'You'                                                                         => 'Actual',
    'Delete user [_1]?'                                                           => '¿Eliminar al usuario [_1]?',
    'New Password'                                                                => 'Nueva contraseña',
    'Save / Update'                                                               => 'Guardar / Actualizar',
    'Update [_1]'                                                                 => 'Actualizar [_1]',
    '← Console'                                                                   => '← Consola',
    'Logout'                                                                      => 'Cerrar sesión',
    'Validation failed: Username must be >= 3 chars and password >= 6 chars.'     => 'Error de validación: el usuario debe tener al menos 3 caracteres y la contraseña al menos 6.',
    'Account [_1] updated successfully.'                                          => 'Cuenta [_1] guardada correctamente.',
    'Action prohibited: You cannot delete your currently logged-in account.'      => 'Acción prohibida: no puedes eliminar la cuenta con la que has iniciado sesión.',
    'Action prohibited: Cannot remove the last remaining administrative account.' => 'Acción prohibida: no se puede eliminar la última cuenta de administrador restante.',
    'Account [_1] removed.'                                                       => 'Cuenta [_1] eliminada.',

    # -------------------------------------------------------------------------
    # Admin Dashboard & Navigation
    # -------------------------------------------------------------------------
    'Dashboard'                      => 'Panel de control',
    'Manager'                        => 'Usuarios',
    'Page [_1] of [_2] ([_3] total)' => 'Página [_1] de [_2] ([_3] en total)',
    '← Prev'                         => '← Anterior',
    'Next →'                         => 'Siguiente →',
    'Share link is active:'          => 'El enlace de compartición está activo:',
    'Passcode:'                      => 'Código de acceso:',
    'Copy Info'                      => 'Copiar info',
    'Open ↗'                         => 'Abrir ↗',
    'Files ([_1])'                   => 'Archivos ([_1])',
    'Active ([_1])'                  => 'Activos ([_1])',
    'Expired ([_1])'                 => 'Caducados ([_1])',
    'Trash ([_1])'                   => 'Papelera ([_1])',

    # -------------------------------------------------------------------------
    # Tab 1: Files
    # -------------------------------------------------------------------------
    'Drag & Drop files or folders here' => 'Arrastra y suelta archivos o carpetas aquí',
    'browse files'                      => 'examinar archivos',
    'browse folder'                     => 'examinar carpetas',
    'Auto-extract if .zip archive'      => 'Extraer automáticamente si es un archivo .zip',
    'Preparing...'                      => 'Preparando...',
    'New Subfolder Name'                => 'Nombre de la nueva subcarpeta',
    'New Root Folder Name'              => 'Nombre de la carpeta raíz',
    'Create Folder'                     => 'Crear carpeta',
    'alphanumeric'                      => 'alfanumérico o guiones',
    'repository'                        => 'almacén',
    'Name'                              => 'Nombre',
    'Modified'                          => 'Modificado',
    'Actions'                           => 'Acciones',
    '[_1] active'                       => '[_1] activo(s)',
    'Share'                             => 'Compartir',
    'Move'                              => 'Mover',
    'Copy'                              => 'Copiar',
    'Rename'                            => 'Renombrar',
    'Delete this item permanently?'     => '¿Eliminar este elemento permanentemente?',

    # -------------------------------------------------------------------------
    # Tab 2: Active Shares
    # -------------------------------------------------------------------------
    'Active Shares ([_1])'             => 'Comparticiones activas ([_1])',
    'Cute Slug'                        => 'Identificador corto (Slug)',
    'Target'                           => 'Destino',
    'Auth'                             => 'Autenticación',
    'TTL Remaining'                    => 'Tiempo restante',
    'Views / Quota'                    => 'Visitas / Límite',
    'Pronounce'                        => 'Escuchar pronunciación',
    'Click to copy pwd'                => 'Clic para copiar contraseña',
    'Public'                           => 'Público',
    'Never'                            => 'Ilimitado',
    '[_1] slots'                       => '[_1] accesos',
    '[_1] ago'                         => 'hace [_1]',
    'Move this active share to trash?' => '¿Mover este recurso compartido a la papelera?',

    # -------------------------------------------------------------------------
    # Tab 3: Expired Shares
    # -------------------------------------------------------------------------
    'Expired Shares ([_1])'                  => 'Comparticiones caducadas ([_1])',
    'Move Selected to Trash'                 => 'Mover seleccionados a la papelera',
    'Move selected expired shares to trash?' => '¿Mover los elementos seleccionados a la papelera?',
    'Reason / Expired At'                    => 'Motivo / Caducidad',
    'Quota Exhausted'                        => 'Límite agotado',
    'Revoked'                                => 'Revocado',
    'Renew & Edit'                           => 'Renovar y editar',
    'To Trash'                               => 'A la papelera',
    'Move share [_1] to trash?'              => '¿Mover recurso compartido [_1] a la papelera?',
    'No expired shares'                      => 'No hay recursos caducados',

    # -------------------------------------------------------------------------
    # Tab 4: Trash
    # -------------------------------------------------------------------------
    'Trash'                                                                 => 'Papelera',
    'Empty Trash'                                                           => 'Vaciar papelera',
    'WARNING: Permanently purge all items in trash? This cannot be undone.' => 'ADVERTENCIA: ¿Eliminar definitivamente todos los elementos de la papelera? Esta acción no se puede deshacer.',
    'Original Lifespan'                                                     => 'Validez inicial',
    'Config: [_1][_2]'                                                      => 'Config.: [_1][_2]',
    'Permanent'                                                             => 'Ilimitado',
    'Restore'                                                               => 'Restaurar',
    'Purge'                                                                 => 'Purgar',
    'Purge this config permanently?'                                        => '¿Eliminar permanentemente esta configuración?',
    'Trash is empty'                                                        => 'La papelera está vacía',

    # -------------------------------------------------------------------------
    # Flash Notifications & Controller Error Messages
    # -------------------------------------------------------------------------
    'Share [_1] moved to Trash.'                                                           => 'Compartición [_1] movida a la papelera.',
    'Share [_1] purged permanently.'                                                       => 'Compartición [_1] eliminada permanentemente.',
    'Moved [_1] selected share(s) to Trash.'                                               => 'Se han movido [_1] compartición(es) seleccionada(s) a la papelera.',
    'Moved [_1] expired shares to Trash.'                                                  => 'Se han movido [_1] compartición(es) caducada(s) a la papelera.',
    'Purged [_1] items permanently from Trash.'                                            => 'Se han purgado permanentemente [_1] elemento(s) de la papelera.',
    'Renamed to [_1] successfully.'                                                        => 'Renombrado a [_1] con éxito.',
    'Moved [_1] successfully.'                                                             => '[_1] movido con éxito.',
    'Copied [_1] successfully.'                                                            => '[_1] copiado con éxito.',
    'Directory [_1] deleted permanently.'                                                  => 'Directorio [_1] eliminado permanentemente.',
    'File [_1] deleted permanently.'                                                       => 'Archivo [_1] eliminado permanentemente.',
    'The slug [_1] is a reserved system keyword.'                                          => 'El slug [_1] es una palabra clave reservada del sistema.',
    'Share config [_1] not found anywhere.'                                                => 'Configuración de compartición [_1] no encontrada.',
    'Invalid JSON payload for [_1].'                                                       => 'Carga JSON no válida para [_1].',
    'Target [_1] missing on disk. Cleaned.'                                                => 'El destino [_1] no existe en el disco. Limpiado.',
    'Modification prohibited: Resource actively occupied by [_1]. Revoke the share first.' => 'Modificación prohibida: recurso ocupado activamente por [_1]. Revoca la compartición primero.',
    'Move prohibited: Resource actively occupied by [_1]. Revoke share first.'             => 'Movimiento prohibido: recurso ocupado activamente por [_1]. Revoca la compartición primero.',
    'Deletion prohibited: Resource actively occupied by [_1]. Revoke the share first.'     => 'Eliminación prohibida: recurso ocupado activamente por [_1]. Revoca la compartición primero.',
    'Move failed: Target entity [_1] already exists in destination.'                       => 'Error al mover: la entidad de destino [_1] ya existe.',
    'Copy failed: Target entity [_1] already exists in destination.'                       => 'Error al copiar: la entidad de destino [_1] ya existe.',
    'Upload rejected: [_1]'                                                                => 'Subida rechazada: [_1]',
    'Invalid folder name.'                                                                 => 'Nombre de carpeta no válido.',
    'Security Alert: CSRF token validation failed. Action rejected.'                       => 'Alerta de seguridad: error en la validación del token CSRF. Acción rechazada.',
    'Security Alert: Directory traversal detected.'                                        => 'Alerta de seguridad: intento de navegación por directorios detectado.',
    'Security Alert: Access to hidden or system files is strictly restricted.'             => 'Alerta de seguridad: el acceso a archivos ocultos o del sistema está estrictamente restringido.',
    'Security Alert: Unauthorized deletion path.'                                          => 'Alerta de seguridad: ruta de eliminación no autorizada.',
    'Move failed: Invalid source or destination path.'                                     => 'Error al mover: ruta de origen o destino no válida.',
    'Move failed: Cannot move a directory into its own subdirectory.'                      => 'Error al mover: no se puede mover un directorio a su propio subdirectorio.',
    'Copy failed: Invalid source or destination path.'                                     => 'Error al copiar: ruta de origen o destino no válida.',

    # -------------------------------------------------------------------------
    # Guest & Delivery Handlers (新增補充)
    # -------------------------------------------------------------------------
    'Internal Server Error'                                             => 'Error interno del servidor',
    'Corrupted share metadata configuration.'                           => 'Configuración de metadatos de compartición corrupta.',
    'Forbidden'                                                         => 'Prohibido',
    'Automated access detected.'                                        => 'Acceso automatizado de bots o rastreadores detectado.',
    'Too Many Requests'                                                 => 'Demasiadas solicitudes',
    'Too many verification attempts. Please wait.'                      => 'Demasiados intentos de verificación. Por favor, espera.',
    'Unauthorized'                                                      => 'No autorizado',
    'Reserved endpoint'                                                 => 'Punto de enlace reservado del sistema',
    'Target Missing'                                                    => 'Destino no encontrado',
    'The underlying file or directory has been removed from storage.'   => 'El archivo o directorio subyacente ha sido eliminado del almacenamiento.',
    'Target [_1] does not exist.'                                       => 'El destino [_1] no existe.',
    'Directory traversal or unauthorized path access detected.'         => 'Salto de directorio o acceso no autorizado a la ruta detectado.',
    'Access Denied'                                                     => 'Acceso denegado',
    'Access to hidden files or system metadata is strictly prohibited.' => 'El acceso a archivos ocultos o metadatos del sistema está estrictamente prohibido.',
    'Library Not Found'                                                 => 'Biblioteca no encontrada',
    'Virtual shared library [_1] does not exist in libs/.'              => 'La biblioteca virtual compartida [_1] no existe en libs/.',

    # -------------------------------------------------------------------------
    # Dialogs & Form Labels
    # -------------------------------------------------------------------------
    'New Share Link'                                           => 'Nuevo enlace compartido',
    'Lifespan (0 = Permanent)'                                 => 'Tiempo de validez (0 = Ilimitado)',
    'Max Access Slots (0 = Unlimited / No Burn)'               => 'Límite de accesos (0 = Ilimitado / Sin autodestrucción)',
    'Custom Cute Slug (Optional)'                              => 'Identificador personalizado (Opcional)',
    'Access Password (Plain text, optional)'                   => 'Contraseña de acceso (Texto sin cifrar, opcional)',
    'Note (Shown on showcase page)'                            => 'Nota (Visible en la página de descarga)',
    'Cancel'                                                   => 'Cancelar',
    'Create'                                                   => 'Crear',
    'Edit / Restore Share'                                     => 'Editar / Restaurar compartición',
    'Target (Change file or directory to switch version)'      => 'Destino (Cambia de archivo o carpeta para cambiar de versión)',
    'Type to search paths...'                                  => 'Escribe para buscar rutas...',
    'New Lifespan (0 = Permanent)'                             => 'Nuevo tiempo de validez (0 = Ilimitado)',
    'Max Access Slots (0 = Unlimited)'                         => 'Límite de accesos (0 = Ilimitado)',
    'Password (Leave empty to keep, type __CLEAR__ to remove)' => 'Contraseña (Dejar vacío para conservar, __CLEAR__ para quitar)',
    'Save & Activate'                                          => 'Guardar y activar',
    'Confirm'                                                  => 'Confirmar',
    'Move Resource'                                            => 'Mover recurso',
    'Copy Resource'                                            => 'Copiar recurso',
    'Destination Directory (Empty for root level)'             => 'Directorio de destino (Vacío para el nivel raíz)',
    'Type to search folders...'                                => 'Escribe para buscar carpetas...',
    'Confirm Move'                                             => 'Confirmar movimiento',
    'Confirm Copy'                                             => 'Confirmar copia',
    'Root directory'                                           => 'Directorio raíz',
    'Gen'                                                      => 'Gen',
    'Leave empty to keep intact'                               => 'Dejar vacío para conservar',
    'Note'                                                     => 'Nota',
    'e.g. Project assets download'                             => 'ej. Descarga de recursos del proyecto',
    'Leave empty for public access'                            => 'Dejar vacío para acceso público',
    'New Name'                                                 => 'Nuevo nombre',

    # -------------------------------------------------------------------------
    # Time Units & Countdown
    # -------------------------------------------------------------------------
    'Seconds' => 'segundos',
    'Minutes' => 'minutos',
    'Hours'   => 'horas',
    'Days'    => 'días',
    'Weeks'   => 'semanas',
    'Months'  => 'meses',
    'Years'   => 'años',
    's left'  => 's restantes',
    'm left'  => 'm restantes',
    'h left'  => 'h restantes',
    'd left'  => 'd restantes',
    'Expired' => 'Caducado',

    # -------------------------------------------------------------------------
    # Client-Side JavaScript Strings
    # -------------------------------------------------------------------------
    'Copied link: [_1]'                     => 'Enlace copiado: [_1]',
    'Copy manually:'                        => 'Copiar manualmente:',
    'Uploading [_1] file(s)... ([_2]%)'     => 'Subiendo [_1] archivo(s)... ([_2]%)',
    'Upload failed: '                       => 'Error al subir: ',
    'Network error occurred during upload.' => 'Se produjo un error de red durante la subida.',

    # -------------------------------------------------------------------------
    # Default Public Portal
    # -------------------------------------------------------------------------
    'File Sharing Node'                        => 'Nodo de compartición de archivos',
    'Private sharing portal is active.'        => 'El portal de compartición privado está activo.',
    'Direct access requires a dedicated link.' => 'El acceso directo requiere un enlace dedicado.',
);

1;
