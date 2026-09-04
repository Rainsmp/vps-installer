#!/data/data/com.termux/files/usr/bin/bash

source "$(cd "$(dirname "$0")/../config" && pwd)/config.sh"

clear

DISTRO="$(get_selected_distro)"

echo
echo "=============================================="
echo "                  ENTER VPS"
echo "=============================================="
echo

if [[ -z "$DISTRO" ]]; then
    warning "No VPS selected."
    pause
    exit 0
fi

if ! distro_exists "$DISTRO"; then
    warning "$DISTRO is not installed."
    pause
    exit 0
fi

success "Entering $DISTRO..."
echo

proot-distro login "$DISTRO"
