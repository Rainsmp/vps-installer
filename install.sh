#!/data/data/com.termux/files/usr/bin/bash

set -e

REPO="https://github.com/Rainsmp/vps-installer.git"
INSTALL_DIR="$HOME/vps-installer"

clear

echo "╔══════════════════════════════════════════════╗"
echo "║                                              ║"
echo "║          TERMUX VPS INSTALLER                ║"
echo "║                    v5.0.0                    ║"
echo "║                                              ║"
echo "╚══════════════════════════════════════════════╝"
echo

echo "[INFO] Updating Termux..."
pkg update -y

echo
echo "[INFO] Installing required packages..."
pkg install -y proot-distro curl wget git nano openssh

echo
echo "[INFO] Downloading VPS installer..."

if [ -d "$INSTALL_DIR/.git" ]; then
    cd "$INSTALL_DIR"
    git pull --ff-only
else
    git clone "$REPO" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

echo
echo "[INFO] Setting permissions..."

chmod +x "$INSTALL_DIR/menu.sh"
chmod +x "$INSTALL_DIR"/options/*.sh
chmod +x "$INSTALL_DIR"/distro/*.sh
chmod +x "$INSTALL_DIR"/config/*.sh

echo
echo "[SUCCESS] Installer is ready!"
echo

exec "$INSTALL_DIR/menu.sh"
