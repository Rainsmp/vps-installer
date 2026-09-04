#!/data/data/com.termux/files/usr/bin/bash

source "$(cd "$(dirname "$0")/../config" && pwd)/config.sh"

clear

DISTRO="$(get_selected_distro)"

echo
echo "=============================================="
echo "                   START VPS"
echo "=============================================="
echo

if [[ -z "$DISTRO" ]]; then
    warning "No VPS selected."
    echo
    echo "Use option 3 to create a VPS."
    pause
    exit 0
fi

if ! distro_exists "$DISTRO"; then
    warning "$DISTRO is not installed."
    pause
    exit 0
fi

success "Starting $DISTRO VPS..."
echo

proot-distro login "$DISTRO"
