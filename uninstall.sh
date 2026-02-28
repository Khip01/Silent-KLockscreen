#!/bin/bash

# Configuration
TARGET_DIR="/usr/share/plasma/shells/org.kde.plasma.desktop/contents/lockscreen"
BACKUP_DIR="${TARGET_DIR}.bak"

echo "-------------------------------------------------------"
echo "KDE Plasma 6 Lockscreen - Recovery Tool"
echo "-------------------------------------------------------"

# Check if the backup exists
if [ -d "$BACKUP_DIR" ]; then
    echo "[*] Backup found. Starting restoration..."

    # 1. Remove the modified theme
    echo "[*] Deleting modified theme from system..."
    sudo rm -rf "$TARGET_DIR"

    # 2. Restore from .bak
    echo "[*] Restoring original files from backup..."
    sudo cp -r "$BACKUP_DIR" "$TARGET_DIR"

    echo "[+] Original lockscreen has been restored successfully."
    
    echo "-------------------------------------------------------"
    echo "Recovery Complete."
    echo "Note: The backup folder ($BACKUP_DIR) is still preserved."
    echo "-------------------------------------------------------"
else
    echo "[!] Error: Backup folder ($BACKUP_DIR) not found."
    echo "Check if you have run the install.sh script first."
    exit 1
fi