#!/data/data/com.termux/files/usr/bin/bash

source "$(cd "$(dirname "$0")/../config" && pwd)/config.sh"
source "$DISTRO_DIR/selector.sh"
source "$DISTRO_DIR/configure.sh"

clear

echo
echo "=============================================="
echo "                  CREATE VPS"
echo "=============================================="
echo

if ! select_distro; then
    exit 0
fi

DISTRO="$(get_selected_distro)"

echo
echo "Selected distribution: $DISTRO"
echo

if distro_exists "$DISTRO"; then
    warning "$DISTRO VPS already exists."
    pause
    exit 0
fi

info "Installing $DISTRO..."
echo

if ! proot-distro install "$DISTRO"; then
    error "Failed to install $DISTRO."
    pause
    exit 1
fi

success "$DISTRO VPS created."

echo
configure_distro "$DISTRO"

success "$DISTRO VPS is ready."

pause
