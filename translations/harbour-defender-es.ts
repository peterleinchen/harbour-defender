<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE TS>
<TS version="2.1" language="es_ES">
<context>
    <name>CookiesMenuItem</name>
    <message>
        <source>Cookies</source>
        <translation>Cookies</translation>
    </message>
    <message>
        <source>Domains</source>
        <translation>Dominio</translation>
    </message>
    <message>
        <source>Cookie Manager</source>
        <translation>Gestor cookies</translation>
    </message>
</context>
<context>
    <name>CookiesPage</name>
    <message>
        <source>Search cookies</source>
        <translation>Buscar cookies</translation>
    </message>
    <message>
        <source>Unlock cookies</source>
        <translation>Desbloquear cookies</translation>
    </message>
    <message>
        <source>Lock cookies</source>
        <translation>Bloquear cookies</translation>
    </message>
    <message>
        <source>Unlocking</source>
        <translation>Desbloqueando</translation>
    </message>
    <message>
        <source>Locking</source>
        <translation>Bloqueando</translation>
    </message>
    <message>
        <source>Delete all blacklisted</source>
        <translation>Borrar todos de la lista negra</translation>
    </message>
    <message>
        <source>Deleting</source>
        <translation>Borrando</translation>
    </message>
    <message>
        <source>Delete all not whitelisted</source>
        <translation>Borrar todos excepto de la lista blanca</translation>
    </message>
    <message>
        <source>Remove</source>
        <translation>Quitar</translation>
    </message>
    <message>
        <source>Remove from Whitelist</source>
        <translation>Quitar de la lista blanca</translation>
    </message>
    <message>
        <source>Add to Whitelist</source>
        <translation>Añadir a la lista blanca</translation>
    </message>
    <message>
        <source>Remove from Blacklist</source>
        <translation>Quitar de la lista negra</translation>
    </message>
    <message>
        <source>Add to Blacklist</source>
        <translation>Añadir a la lista negra</translation>
    </message>
    <message>
        <source>Browser still open?</source>
        <translation type="unfinished"></translation>
    </message>
</context>
<context>
    <name>DocsPage</name>
    <message>
        <source>Warning</source>
        <translation>Advertencia</translation>
    </message>
    <message>
        <source>The installation and use of this application is solely in the responsibility of the user. The developers/authors are not responsible for the content of ad blocking sources available from the application, therefore you need to be careful when enabling them.</source>
        <translation>La instalación y uso de esta aplicación sólo es responsabilidad del usuario. Los desarrolladores/autores no son responsables del contenido de las fuentes de bloqueo de anuncios disponibles en la aplicación, por tanto, debes tener cuidado cuando los habilites.</translation>
    </message>
    <message>
        <source>Adblock Lists</source>
        <translation>Listas de bloqueo de anuncios</translation>
    </message>
    <message>
        <source>How to add custom lists?</source>
        <translation>¿Cómo añadir listas personalizadas?</translation>
    </message>
    <message>
        <source>Version</source>
        <translation>Versión</translation>
    </message>
    <message>
        <source>You can add custom lists by editing the file /etc/defender.conf as root (either using the command line or an appropriate editor). See other sections in the config file for inspiration. In the square brackets [] should be a unique id.</source>
        <translation>Puedes añadir listas personalizadas editando el archivo /etc/defender.conf como root (ya sea usando la línea de comandos o un editor apropiado). Consulta otras secciones en el archivo de configuración para la inspiración. Entre corchetes [] debería haber un único id.</translation>
    </message>
    <message>
        <source>Why can&apos;t I add new sources from the app?</source>
        <translation>¿Por qué no puedo añadir nuevas fuentes desde la aplicación?</translation>
    </message>
    <message>
        <source>It would be a security threat to allow adding new sources as a normal user (with the current SailfishOS security situation), as any app would be able to add new sources and potentially compromise your device. Even with the default sources, you still make the leap of faith to trust a remote source. If you want to have a source added/removed to/from the defaults, contact the app developer and see if it can be available in the next version.</source>
        <translation>Sería una amenaza a la seguridad permitir a un usuario normal añadir nuevas fuentes (con la situación actual de seguridad de SailfishOS), ya que cualquier aplicación podría añadir nuevas fuentes y poner en peligro tu dispositivo. Aún con las fuentes por defecto, estarías confiando en una fuente remota. Si quieres añadir/eliminar una fuente a/de las que hay por defecto, contacta con el desarrollador de la aplicación para ver si se puede incluir en la siguiente versión.</translation>
    </message>
    <message>
        <source>How to add custom entries?</source>
        <translation>¿Cómo añadir entradas personalizadas?</translation>
    </message>
    <message>
        <source>You can add your custom hosts entries by editing the file /etc/hosts.editable and treating it as a generic hosts file. Don&apos;t forget to choose &apos;Update Now&apos; in the app to see an immediate effect.</source>
        <translation>Puedes añadir tus entradas personalizadas al hosts editando el fichero /etc/hosts.editable y tratándolo como un fichero hosts genérico. No olvides seleccionar &apos;Actualizar ahora&apos; en la aplicación para ver el efecto inmediato.</translation>
    </message>
    <message>
        <source>Why can&apos;t I add new entries from the app?</source>
        <translation>¿Por qué no puedo añadir nuevas entradas desde la aplicación?</translation>
    </message>
    <message>
        <source>Again, it would be a security threat (see the answer above), therefore one needs to be root to add/modify hosts file entries.</source>
        <translation>De nuevo, sería una amenaza a la seguridad (ver respuesta de más arriba), por tanto, necesitas ser root para añadir/modificar entradas en el fichero hosts.</translation>
    </message>
    <message>
        <source>Cookies</source>
        <translation>Cookies</translation>
    </message>
    <message>
        <source>The cookie manager works by editing the -/.local/share/org.sailfishos/browser/.mozilla/ (for SFOS up to 3.4: -/.mozilla/mozembed/) cookies.sqlite database. In order to access/work with cookies the browser needs to be closed before opening the cookies section, else you might see an empty window. All changes need the browser to be closed/restarted in order to take effect.</source>
        <translation>El gestor de cookies funciona editando la base de datos sqlite ubicada en ~/.local/share/org.sailfishos/browser/.mozilla/ (hasta la versión 3.4 de SFOS: ~/.mozilla/mozembed/) . Para poder acceder/trabajar con las cookies, es necesario cerrar el navegador antes de abrir la sección de cookies; de lo contrario, podrías ver una ventana vacía. Para que todos los cambios surtan efecto es necesario cerrar/reiniciar el navegador.</translation>
    </message>
    <message>
        <source>Cookie Locking</source>
        <translation>Bloqueo de cookies</translation>
    </message>
    <message>
        <source>Cookie locking works by making the cookie database read only, therefore its contents stay same between restarting the browser. The effect of this is cookies not being persistent over browser restarts.</source>
        <translation>El bloqueo de cookies funciona haciendo que la base de datos de cookies sea sólo de lectura, por tanto su contenido es el mismo al reiniciar el navegador. El efecto de esto es que las cookies no son persistentes en los reinicios del navegador.</translation>
    </message>
    <message>
        <source>Update</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>You can define an update interval of never/daily/weekly/monthly. As well you may configure to have your blacklisted (or not-whitelisted) cookies to be deleted on each update interval. So, no need to worry about bad cookies anymore or do this manually. 
This automatic action will start at the same time when you last started an update.</source>
        <translation type="unfinished"></translation>
    </message>
</context>
<context>
    <name>SettingsPage</name>
    <message>
        <source>Settings</source>
        <translation>Ajustes</translation>
    </message>
    <message>
        <source>Clear Cookie Blacklist</source>
        <translation>Limpiar lista negra de cookies</translation>
    </message>
    <message>
        <source>Clearing</source>
        <translation>Limpiando</translation>
    </message>
    <message>
        <source>Clear Cookie Whitelist</source>
        <translation>Limpiar lista blanca de cookies</translation>
    </message>
    <message>
        <source>WLAN only</source>
        <translation>Sólo WLAN</translation>
    </message>
    <message>
        <source>Downloads adblock lists only if connected to WLAN (tested only on Jolla phones)</source>
        <translation>Descarga listas de bloqueo de anuncios sólo si está conectado con WLAN (sólo se ha probado en teléfonos Jolla)</translation>
    </message>
    <message>
        <source>Cookie lists</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Interval time</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Daily</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Weekly</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Monthly</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Delete cookies on update</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>None</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>All blacklisted</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>All not whitelisted</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Close browser on cookies deletion</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>WLAN/GPRS usage</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Update</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>To enable the deletion of cookies, the browser must not be open. If this setting is not enabled and the browser is open, cookies will not be deleted on update interval.</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Never</source>
        <translation type="unfinished"></translation>
    </message>
</context>
<context>
    <name>SourceDetailPage</name>
    <message>
        <source>Open hosts file URL</source>
        <translation>Abrir URL del fichero hosts</translation>
    </message>
    <message>
        <source>More information</source>
        <translation>Más información</translation>
    </message>
    <message>
        <source>Source</source>
        <translation>Fuente</translation>
    </message>
    <message>
        <source>License</source>
        <translation>Licencia</translation>
    </message>
</context>
<context>
    <name>SourcesMenuItem</name>
    <message>
        <source>Blocked</source>
        <translation>Bloqueo</translation>
    </message>
    <message>
        <source>Lists</source>
        <translation>Listas</translation>
    </message>
    <message>
        <source>Adblock Lists</source>
        <translation>Listas bloqueo</translation>
    </message>
</context>
<context>
    <name>SourcesPage</name>
    <message>
        <source>Disable all</source>
        <translation>Desactivar todo</translation>
    </message>
    <message>
        <source>Preparing disable</source>
        <translation>Preparando desactivación</translation>
    </message>
    <message>
        <source>Cancel/clear update loop</source>
        <translation>Cancelar/limpiar bucle de actualización</translation>
    </message>
    <message>
        <source>Preparing cancel/clear</source>
        <translation>Preparando cancelación/limpieza</translation>
    </message>
    <message>
        <source>Show error log (just in case ;)</source>
        <translation>Mostrar registro de errores (por si acaso ;)</translation>
    </message>
    <message>
        <source>Pulling up error.log (only if exists)</source>
        <translation>Cargando error.log (sólo si existe)</translation>
    </message>
    <message>
        <source>Restart Android/App Support</source>
        <translation>Reinciar Android/AppSupport</translation>
    </message>
    <message>
        <source>Preparing Android restart</source>
        <translation>Preparando reinicio de Android</translation>
    </message>
    <message>
        <source>Update now</source>
        <translation>Actualizar ahora</translation>
    </message>
    <message>
        <source>Preparing update</source>
        <translation>Preparando actualización</translation>
    </message>
    <message>
        <source>Sources</source>
        <translation>Fuentes</translation>
    </message>
    <message>
        <source>Updating...</source>
        <translation>Actualizando...</translation>
    </message>
    <message>
        <source>Update in progress. This may take a while, but you can safely close the application and the update will finish in the background.</source>
        <translation>Actualización en curso. Esto puede tardar un rato, pero puedes cerrar la aplicación con seguridad y la actualización se completará en segundo plano.</translation>
    </message>
</context>
<context>
    <name>WelcomePage</name>
    <message>
        <source>Adblock Lists</source>
        <translation>Listas bloqueo</translation>
    </message>
    <message>
        <source>Cookies</source>
        <translation>Cookies</translation>
    </message>
    <message>
        <source>Documentation</source>
        <translation>Documentación</translation>
    </message>
    <message>
        <source>Settings</source>
        <translation>Ajustes</translation>
    </message>
</context>
<context>
    <name>harbour-defender</name>
    <message>
        <source>Defender</source>
        <translation>Defensor</translation>
    </message>
</context>
</TS>
