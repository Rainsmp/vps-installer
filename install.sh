#!/data/data/com.termux/files/usr/bin/bash

set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

clear

echo
echo "╔══════════════════════════════════════════════╗"
echo "║                                              ║"
echo "║          TERMUX VPS INSTALLER                ║"
echo "║                    v5.0.0                    ║"
echo "║                                              ║"
echo "╚══════════════════════════════════════════════╝"
echo

if [[ -z "${PREFIX:-}" ]]; then
    echo "[✗] This script must be run inside Termux."
    exit 1
fi

echo "[INFO] Updating Termux..."
pkg update -y

echo
echo "[INFO] Installing required packages..."
pkg install -y proot-distro curl wget git nano openssh

echo
echo "[INFO] Setting permissions..."

chmod +x "$BASE_DIR/menu.sh"
chmod +x "$BASE_DIR/config/config.sh"
chmod +x "$BASE_DIR/distro/"*.sh
chmod +x "$BASE_DIR/options/"*.sh

echo
echo "[✓] VPS Manager installation complete."
echo

exec bash "$BASE_DIR/menu.sh"
