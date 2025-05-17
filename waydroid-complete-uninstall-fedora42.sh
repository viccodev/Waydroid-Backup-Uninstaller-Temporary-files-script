set -e
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script needs root for correct execution" >&2 # Enviar el error a la salida de error estándar
    echo "please, run the script with 'sudo'" >&2
    echo "sudo ./$(basename "$0")" >&2 # Muestra cómo ejecutarlo con sudo, usando el nombre real del script
    exit 1 # Salir del script con un código de error (1 indica un error)
fi


# --- Mensaje de advertencia y confirmación antes de proceder ---
echo "----------------------------------------------------"
echo "             Advertencia Importante"
echo "----------------------------------------------------"
echo ""
echo "Este script está diseñado para automatizar el respaldo,"
echo "del directorio base (descargas, documentos), limpieza y reinstalación de Waydroid."
echo ""
echo "Probado en Fedora 42. Su funcionamiento en otros"
echo "sistemas operativos no está garantizado sin ajustes."
echo ""
echo ">>>  IMPORTANTE:  <<<"
echo "Solo se copiarán las carpetas de datos de usuario ESTÁNDAR"
echo "ubicadas directamente bajo el directorio principal de Waydroid data."
echo "Por ejemplo, las que están en:"
echo "  ~/.local/share/Waydroid/data/media/0/" # <-- Reemplaza con la ruta exacta
echo ""
echo "Las carpetas que se copiarán incluyen (pero no se limitan a):"
echo "  - Downloads" # <-- Ajusta esta lista con los nombres exactos de las carpetas que copiarás con cp -r
echo "  - Pictures" # <-- Por ejemplo, tus videos de TikTok están en alguna de estas
echo "  - Movies"
echo "  - Documents"
echo "  - DCIM"
echo ""
echo "Cualquier archivo o carpeta FUERA de esa ruta principal o con"
echo "nombres diferentes NO será respaldado automáticamente por este script."
echo ""
echo "Después de la copia, el script PROCEDERÁ a eliminar archivos"
echo "de Waydroid y a reinstalar la aplicación."
echo "Esto BORRARÁ el estado actual de Waydroid."
echo ""
echo "----------------------------------------------------"
echo "The backup files are in /youruser/waydroidbackup"
echo -n "¿Está SEGURO que desea continuar con la copia y el proceso de reinstalación? (s/n): "

read confirmation # Lee la respuesta del usuario y la guarda en la variable 'confirmation'

# Convertir la respuesta a minúsculas para que funcione con 's' o 'S'
confirmation_lower=$(echo "$confirmation" | tr '[:upper:]' '[:lower:]')

# --- Chequeo de la confirmación del usuario ---
if [ "$confirmation_lower" != "s" ]; then
    echo "" # Salto de línea para claridad
    echo "Operación cancelada por el usuario."
    exit 0 # Salir con código 0 (éxito) porque el usuario decidió no continuar, no hubo un error del script
fi
# --- Fin del chequeo de confirmación ---

echo "" # Salto de línea
echo "Procediendo con la ejecución del script..."
echo "----------------------------------------------------"
echo ""

# --- Starting Script  ---

echo waydroid script to uninstall waydroid and remove temp and cache files. to a quick reinstall.
cd ~
mkdir waydroidbackup
cd ~/.local/share/waydroid/data/media/0/
cp -r Downloads Documents Music Pictures DCIM Movies ~/waydroidbackup/

rm -rf /var/lib/waydroid /home/.waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid
rm -rf ~/.local/share/waydroid
rm -rf ~/.local/share/applications/waydroid*.desktop
