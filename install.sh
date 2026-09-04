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
pkg upgrade -y

echo
echo "[INFO] Installing required packages..."
pkg install -y proot-distro curl wget git nano openssh

echo
echo "[INFO] Downloading VPS installer..."

if [ -d "$INSTALL_DIR/.git" ]; then
    echo "[INFO] Updating existing installer..."
    cd "$INSTALL_DIR"
    git pull --ff-only
else
    echo "[INFO] Cloning installer..."
    rm -rf "$INSTALL_DIR"
    git clone "$REPO" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

echo
echo "[INFO] Setting permissions..."

chmod +x install.sh
chmod +x menu.sh

if [ -d options ]; then
    chmod +x options/*.sh
fi

if [ -d distro ]; then
    chmod +x distro/*.sh
fi

if [ -d config ]; then
    chmod +x config/*.sh
fi

echo
echo "[SUCCESS] Installer is ready!"
echo

exec "$INSTALL_DIR/menu.sh"
