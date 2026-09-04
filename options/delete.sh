#!/data/data/com.termux/files/usr/bin/bash

source "$(cd "$(dirname "$0")/../config" && pwd)/config.sh"

clear

DISTRO="$(get_selected_distro)"

echo
echo "=============================================="
echo "                  DELETE VPS"
echo "=============================================="
echo

if [[ -z "$DISTRO" ]]; then
    warning "No distribution selected."
    pause
    exit 0
fi

if ! distro_exists "$DISTRO"; then
    warning "$DISTRO VPS does not exist."
    pause
    exit 0
fi

warning "This will permanently delete:"
echo
echo "  $DISTRO"
echo
warning "All files inside this container will be removed."
echo

read -rp "Type DELETE to confirm: " confirm

if [[ "$confirm" != "DELETE" ]]; then
    warning "Deletion cancelled."
    pause
    exit 0
fi

info "Removing $DISTRO..."

if proot-distro remove "$DISTRO"; then
    success "$DISTRO VPS deleted successfully."
    rm -f "$selected_distro_file"
else
    error "Failed to delete $DISTRO."
fi

pause
