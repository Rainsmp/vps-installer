#!/data/data/com.termux/files/usr/bin/bash

VERSION="5.0.0"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OPTIONS_DIR="$BASE_DIR/options"
DISTRO_DIR="$BASE_DIR/distro"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

error() {
    echo -e "${RED}[✗]${NC} $1"
}

pause() {
    echo
    read -rp "Press Enter to continue..."
}

selected_distro_file="$BASE_DIR/.selected_distro"

get_selected_distro() {
    if [[ -f "$selected_distro_file" ]]; then
        cat "$selected_distro_file"
    else
        echo ""
    fi
}

set_selected_distro() {
    echo "$1" > "$selected_distro_file"
}

distro_exists() {
    local distro="$1"

    [[ -z "$distro" ]] && return 1

    if [[ -d "$PREFIX/var/lib/proot-distro/installed-rootfs/$distro" ]]; then
        return 0
    fi

    if proot-distro login "$distro" -- true >/dev/null 2>&1; then
        return 0
    fi

    return 1
}

login_distro() {
    local distro="$1"
    proot-distro login "$distro"
}
