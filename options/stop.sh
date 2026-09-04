#!/data/data/com.termux/files/usr/bin/bash

source "$(cd "$(dirname "$0")/../config" && pwd)/config.sh"

clear

DISTRO="$(get_selected_distro)"

echo
echo "=============================================="
echo "                   STOP VPS"
echo "=============================================="
echo

if [[ -z "$DISTRO" ]]; then
    warning "No VPS selected."
    pause
    exit 0
fi

warning "PRoot does not run a persistent VPS daemon."
echo
echo "The $DISTRO session ends when you type:"
echo
echo -e "  ${GREEN}exit${NC}"
echo
echo "This returns you to Termux."
echo

pause
