#!/data/data/com.termux/files/usr/bin/bash

source "$(cd "$(dirname "$0")/../config" && pwd)/config.sh"
source "$DISTRO_DIR/configure.sh"

clear

DISTRO="$(get_selected_distro)"

echo
echo "=============================================="
echo "                REINSTALL VPS"
echo "=============================================="
echo

if [[ -z "$DISTRO" ]]; then
    warning "No distribution selected."
    echo
    echo "Use option 3 to create a VPS first."
    pause
    exit 0
fi

if ! distro_exists "$DISTRO"; then
    warning "$DISTRO is not currently installed."
    echo
    echo "Installing it now..."
else
    warning "This will delete and recreate $DISTRO."
    echo

    read -rp "Type REINSTALL to confirm: " confirm

    if [[ "$confirm" != "REINSTALL" ]]; then
        warning "Reinstallation cancelled."
        pause
        exit 0
    fi

    info "Removing old $DISTRO..."

    if ! proot-distro remove "$DISTRO"; then
        error "Could not remove $DISTRO."
        pause
        exit 1
    fi
fi

echo
info "Installing fresh $DISTRO..."

if ! proot-distro install "$DISTRO"; then
    error "Installation failed."
    pause
    exit 1
fi

success "$DISTRO installed."

echo
configure_distro "$DISTRO"

success "$DISTRO VPS reinstalled successfully."

pause
