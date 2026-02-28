#!/bin/bash

# Configuration - Get current script directory to make it dynamic
SOURCE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
TARGET_DIR="/usr/share/plasma/shells/org.kde.plasma.desktop/contents/lockscreen"
BACKUP_DIR="${TARGET_DIR}.bak"

echo "-------------------------------------------------------"
echo "Silent KLockscreen - Installer"
echo "-------------------------------------------------------"

# 1. Create a backup of the original files if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
    echo "[*] Initial run detected. Creating backup of original files..."
    sudo cp -r "$TARGET_DIR" "$BACKUP_DIR"
    echo "[+] Backup created at: $BACKUP_DIR"
else
    echo "[!] Backup already exists. Skipping backup to protect original files."
fi

# 2. Remove current system lockscreen files
echo "[*] Removing current system lockscreen files..."
sudo rm -rf "$TARGET_DIR"

# 3. Apply the new ported theme
echo "[*] Applying the new ported theme from $SOURCE_DIR..."
sudo cp -r "$SOURCE_DIR" "$TARGET_DIR"

# 4. Cleanup system directory (Removing installer scripts from /usr/share)
echo "[*] Cleaning up installer scripts from system directory..."
sudo rm -f "$TARGET_DIR/install.sh"
sudo rm -f "$TARGET_DIR/uninstall.sh"
sudo rm -f "$TARGET_DIR/README.md"
sudo rm -f "$TARGET_DIR/.gitignore"
sudo rm -rf "$TARGET_DIR/.git"
sudo rm -rf "$TARGET_DIR/.vscode"

# 5. Correcting file permissions
echo "[*] Setting correct system permissions (755)..."
sudo chmod -R 755 "$TARGET_DIR"

echo "-------------------------------------------------------"
echo "Done! Theme applied successfully."
echo "IMPORTANT: Test before you lock! (See README for testing command)"
echo "Or Press Meta+L to test your new lockscreen."
echo "-------------------------------------------------------"