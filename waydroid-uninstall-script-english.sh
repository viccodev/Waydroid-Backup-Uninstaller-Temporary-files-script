#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Check for root privileges ---
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script requires root privileges for correct execution." >&2 # Send error to standard error output
    echo "Please run the script with 'sudo'." >&2
    echo "Example: sudo ./$(basename "$0")" >&2 # Show how to run it with sudo, using the actual script name
    exit 1 # Exit script with error code (1 indicates an error)
fi
# --- End of root check ---


# --- Warning message and confirmation before proceeding ---
echo "----------------------------------------------------"
echo "                Important Warning"
echo "----------------------------------------------------"
echo ""
echo "This script is designed to automate the backup"
echo "of standard user data directories, cleanup, and Waydroid uninstallation." # Adjusted phrasing
echo ""
echo "Tested on Fedora 42. Its functionality on other"
echo "operating systems is not guaranteed without adjustments."
echo ""
echo ">>>  IMPORTANT:  <<<"
echo "Only STANDARD user data folders will be copied"
echo "located directly under the main Waydroid data directory."
echo "For example, those located in:"
echo "  $HOME/.local/share/Waydroid/data/media/0/" # <-- Replace with the exact path
echo ""
echo "Folders that will be copied include (but are not limited to):"
echo "  - Downloads" # <-- Adjust this list with the exact names of the folders you will copy with cp -r
echo "  - Pictures" # <-- For example, your TikTok videos are in one of these
echo "  - Movies"
echo "  - Documents"
echo "  - DCIM"
echo "  - Music"
echo ""
echo "Any file or folder OUTSIDE that main path or with"
echo "different names will NOT be automatically backed up by this script."
echo ""
echo "After the backup (if selected), the script WILL PROCEED" # Added "(if selected)" for clarity with the prompt
echo "to remove Waydroid files and uninstall the application."
echo "This WILL ERASE the current state of your Waydroid installation." # Phrased slightly stronger
echo ""
echo "----------------------------------------------------"
echo "The backup files will be saved in a folder named waydroid-script-backup in your home directory ($HOME)." # Mention the fixed name and path
echo -n "Are you SURE you want to continue with the backup (if selected) and the uninstallation process? (y/n): " # Changed s/n to y/n as is standard in English prompts

# Read user's response and save it in the 'confirmation' variable
read confirmation

# Convert the response to lowercase to work with 'y', 'Y', 'n', or 'N'
confirmation_lower=$(echo "$confirmation" | tr '[:upper:]' '[:lower:]')

# --- Check user's confirmation to proceed with the main process ---
if [ "$confirmation_lower" != "y" ]; then # Check if it's NOT 'y'
    echo "" # Newline for clarity
    echo "Operation cancelled by user."
    exit 0 # Exit with code 0 (success) because the user decided not to continue, no hubo un error del script
fi
# --- End of main confirmation check ---

echo "" # Newline
echo "Proceeding with script execution..."
echo "----------------------------------------------------"
echo ""

# --- Start Script Logic ---

# --- Ask specifically about backup ---
echo "" # Newline for clarity
echo "--- Backup Option ---"
read -r -p "¿Deseas crear una copia de seguridad (backup) de tus datos de Waydroid antes de eliminar? (y/n): " backup_confirm_response # Prompt specific to backup

# Convert the response to lowercase
backup_confirm_response_lower=$(echo "$backup_confirm_response" | tr '[:upper:'] '[:lower:]')

# --- Conditional Backup Section ---
if [[ "$backup_confirm_response_lower" == "y" ]]; then
    echo "Initiating backup..."

    # --- Backup Commands (run only if user says yes) ---
    # Using your existing commands for creating dir and copying, using $HOME
    cd "$HOME" # Ensure we are in the home directory first
    mkdir waydroid-script-backup # Create the backup directory with the fixed name

    # Check if the source directory exists before trying to copy from it
    if [ -d "$HOME/.local/share/waydroid/data/media/0/" ]; then
        echo "Copying user data directories..."
        # !!! VERIFY THE DIRECTORY NAMES TO COPY HERE (Downloads, Documents, etc.) !!!
        # These commands copy from the source path into the backup directory
        cp -r "$HOME/.local/share/waydroid/data/media/0/Downloads" "$HOME/waydroid-script-backup/" # Example copy
        cp -r "$HOME/.local/share/waydroid/data/media/0/Documents" "$HOME/waydroid-script-backup/" # Example copy
        cp -r "$HOME/.local/share/waydroid/data/media/0/Music" "$HOME/waydroid-script-backup/"    # Example copy
        cp -r "$HOME/.local/share/waydroid/data/media/0/Pictures" "$HOME/waydroid-script-backup/"  # Example copy
        cp -r "$HOME/.local/share/waydroid/data/media/0/DCIM" "$HOME/waydroid-script-backup/"      # Example copy
        cp -r "$HOME/.local/share/waydroid/data/media/0/Movies" "$HOME/waydroid-script-backup/"    # Example copy

        echo "Backup complete to: $HOME/waydroid-script-backup"
    else
        echo "Warning: Waydroid user data source directory not found, skipping backup copying: $HOME/.local/share/waydroid/data/media/0/" >&2
    fi
    # --- End of Backup Commands ---

else
    echo "Skipping backup based on user choice."
fi
echo "" # Newline
# --- End of Conditional Backup Section ---


# --- Waydroid Uninstallation Steps ---

echo "Stopping Waydroid session..."
waydroid session stop # Uncomment this line when you are ready to stop Waydroid programmatically

echo "Uninstalling Waydroid package..."
# Use your distribution's package manager command
# Using -y or --noconfirm is common in scripts to avoid prompts, but remove it if you want to see the package manager's questions
sudo dnf remove waydroid -y # Example for Fedora with auto-confirm


echo "Removing remaining Waydroid related files and directories..."
# !!! EXTREMELY IMPORTANT: VERIFY THESE PATHS CAREFULLY BEFORE RUNNING !!!
# These commands use 'sudo' and 'rm -rf' which are very powerful and dangerous if paths are wrong.
# Use echo "$path" to print paths before removing them if you are unsure.

# Removed the array and loop complexity to keep it simpler as requested.
# Added checks for existence (-e) before removing where appropriate.

# Common system-wide path (requires root)
if [ -e "/var/lib/waydroid" ]; then # Check if the path exists
    echo "Removing system path: /var/lib/waydroid"
    sudo rm -rf "/var/lib/waydroid"
else
    echo "System path not found (ignoring): /var/lib/waydroid"
fi

# Common user-specific paths in home
if [ -e "$HOME/.waydroid" ]; then
    echo "Removing user path: $HOME/.waydroid"
    rm -rf "$HOME/.waydroid"
else
    echo "User path not found (ignoring): $HOME/.waydroid"
fi

# This path was listed multiple times, consolidating to one removal attempt
if [ -e "$HOME/.local/share/waydroid" ]; then
    echo "Removing user path: $HOME/.local/share/waydroid"
    rm -rf "$HOME/.local/share/waydroid"
else
     echo "User path not found (ignoring): $HOME/.local/share/waydroid"
fi

if [ -e "$HOME/.cache/waydroid-script" ]; then # Assuming this might be a typo for ~/.cache/waydroid
     echo "Removing user path: $HOME/.cache/waydroid-script (Possible typo? Verify path!)"
     # rm -rf "$HOME/.cache/waydroid-script" # Uncomment if this path is correct and you want to remove it
else
     echo "Cache path not found (ignoring): $HOME/.cache/waydroid-script"
fi

# Removing desktop files using a pattern - direct rm approach
echo "Removing Waydroid desktop files..."
# Using rm with -f to ignore errors if no files match the pattern
rm -f "$HOME/.local/share/applications/waydroid*.desktop" # Assuming the pattern is correct and files are in this location
echo "Attempted to remove Waydroid desktop files."


echo "" # Newline
echo "----------------------------------------------------"
echo "Waydroid uninstallation and cleanup process completed."
echo "You can now manually reinstall Waydroid if desired."
echo "----------------------------------------------------"