#!/data/data/com.termux/files/usr/bin/bash

source "$(cd "$(dirname "$0")/../config" && pwd)/config.sh"

clear

DISTRO="$(get_selected_distro)"

echo
echo "=============================================="
echo "                  VPS STATUS"
echo "=============================================="
echo

if [[ -z "$DISTRO" ]]; then
    warning "No VPS selected."
    echo
    echo "Use option 3 to create one."
    pause
    exit 0
fi

if distro_exists "$DISTRO"; then
    success "VPS : INSTALLED"
else
    warning "VPS : NOT INSTALLED"
    pause
    exit 0
fi

echo
echo "Distribution : $DISTRO"
echo "Container    : proot-distro"
echo "Architecture : $(uname -m)"
echo

echo "----------------------------------------------"
echo " SYSTEM INFORMATION"
echo "----------------------------------------------"
echo

proot-distro login "$DISTRO" -- sh -c '
    echo "OS           : $(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d= -f2- | tr -d "\"")"
    echo "Kernel       : $(uname -r)"
    echo "Architecture : $(uname -m)"
    echo
    echo "Disk:"
    df -h / 2>/dev/null | tail -n 1
    echo
    echo "Memory:"
    free -h 2>/dev/null || true
'

pause
