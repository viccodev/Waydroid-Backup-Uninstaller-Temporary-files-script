#!/bin/bash


# Workflow:
# Back up files stored in Waydroid's common directories. (Downloads, Pictures, etc.)
# Stop waydroid and uninstall it.
# Remove temporary files, configuration, and .desktop files that sometimes remain after uninstalling. (Ej: gnome waydroid icons remaining)
# Done re install waydroid if you want.


set -e
USER_HOME=$(eval echo ~"${SUDO_USER:-$USER}")
# Check for root privileges 
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script requires root privileges for correct execution." >&2 
    echo "Please run the script with 'sudo'." >&2
    echo "Example: sudo ./$(basename "$0")" >&2 
    exit 1 
fi

echo "WARNING: This script was originally made for Fedora 42"
echo "----------------------------------------------------"
echo "                Important Warning"
echo "----------------------------------------------------"
echo ""
echo "This script is designed to automate the backup"
echo "of standard user data directories, cleanup, and Waydroid uninstallation." 
echo ""
echo "Tested on Fedora 42. Its functionality on other"
echo "operating systems, is not guaranteed without adjustments."
echo ""
echo ">>>  IMPORTANT:  <<<"
echo "Only STANDARD user data folders will be copied"
echo "located directly under the main Waydroid data directory."
echo "For example, those located in:"
echo "  $USER_HOME/.local/share/Waydroid/data/media/0/" 
echo ""
echo "Folders that will be copied include (but are not limited to):"
echo "  - Downloads" 
echo "  - Pictures" 
echo "  - Movies"
echo "  - Documents"
echo "  - DCIM" # Important things, tiktok and other apps download here
echo "  - Music"
echo ""
echo "Any file or folder OUTSIDE that main path or with"
echo "different names will NOT be automatically backed up by this script."
echo ""
echo "After the backup (if selected), the script WILL PROCEED" 
echo "to remove Waydroid files and uninstall the application."
echo "This WILL ERASE the current state of your Waydroid installation."
echo ""
echo "----------------------------------------------------"
echo "The backup files will be saved in a folder named waydroid-script-backup in your$USER_HOME directory ($USER_HOME)."
echo -n "Are you SURE you want to continue with the backup (if selected) and the uninstallation process? (y/n): " # Changed s/n to y/n as is standard in English prompts

# Backup waydroid files
read -p "Do you want to backup your Waydroid files? (yes/no): " confirmation
confirmation=${confirmation,,}


if [[ "$confirmation" == "yes" || "$confirmation" == "y" ]]; then
    cd $USER_HOME/
    mkdir -p $USER_HOME/waydroid-script-backup
    cd $USER_HOME/.local/share/waydroid/data/media/0/
    cp -r Downloads Documents Pictures Movies DCIM Music $USER_HOME/waydroid-script-backup/
    echo "copy saved on $USER_HOME/waydroid-script-backup"
    cd $USER_HOME/
elif [[ "$confirmation" == "no" || "$confirmation" == "n" ]]; then
    echo "Waydroid backup cancelled by user. uninstalling waydroid and temp files"

else 
    echo "Please, use "yes" or "no" "
    exit 1

fi


# Stop waydroid and uninstall it.

waydroid session stop 
dnf remove waydroid -y

# Remove temporary files and .desktop files.
# Paths:
# var/lib/waydroid
# $USER_HOME/.waydroid
# $USER_HOME/.local/share/waydroid
# $USER_HOME/.cache/waydroid-script
# $USER_HOME/.local/share/applications/waydroid*.desktop

cd $USER_HOME
rm -rf /var/lib/waydroid
rm -rf $USER_HOME/.waydroid
rm -rf $USER_HOME/.local/share/waydroid
rm -rf $USER_HOME/.cache/waydroid-script
rm -rf $USER_HOME/.local/share/applications/waydroid*


