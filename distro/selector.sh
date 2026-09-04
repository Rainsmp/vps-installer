#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$BASE_DIR/config/config.sh"

# Colors
RESET='\033[0m'
BOLD='\033[1m'

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'

clear

echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}║${RESET}             ${BLUE}${BOLD}TERMUX VPS MANAGER${RESET}               ${CYAN}${BOLD}║${RESET}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}"
echo
echo -e "              ${MAGENTA}${BOLD}SELECT LINUX VPS${RESET}"
echo

DISTROS=(
    "debian"
    "ubuntu"
    "alpine"
    "archlinux"
    "fedora"
    "opensuse"
    "void"
    "manjaro"
    "artix"
    "deepin"
    "openkylin"
    "pardus"
)

NAMES=(
    "Debian"
    "Ubuntu"
    "Alpine Linux"
    "Arch Linux"
    "Fedora"
    "openSUSE"
    "Void Linux"
    "Manjaro"
    "Artix Linux"
    "Deepin"
    "OpenKylin"
    "Pardus"
)

for i in "${!DISTROS[@]}"; do
    printf "${CYAN}[%2d]${RESET} ${WHITE}%s${RESET}\n" "$((i + 1))" "${NAMES[$i]}"
done

echo
echo -e "${RED}[0]${RESET} ${WHITE}Back${RESET}"
echo

echo -ne "${YELLOW}${BOLD}Select distribution: ${RESET}"
read -r choice

if [ "$choice" = "0" ]; then
    exit 0
fi

if ! [[ "$choice" =~ ^[0-9]+$ ]] || \
   [ "$choice" -lt 1 ] || \
   [ "$choice" -gt "${#DISTROS[@]}" ]; then

    echo
    echo -e "${RED}${BOLD}[✗] Invalid selection.${RESET}"
    sleep 2
    exec "$0"
fi

SELECTED="${DISTROS[$((choice - 1))]}"
SELECTED_NAME="${NAMES[$((choice - 1))]}"

set_selected_distro "$SELECTED"

echo
echo -e "${GREEN}${BOLD}[✓] Selected:${RESET} ${WHITE}${SELECTED_NAME}${RESET}"
echo

if distro_exists "$SELECTED"; then
    echo -e "${GREEN}[✓]${RESET} ${WHITE}${SELECTED_NAME} is already installed.${RESET}"
else
    echo -e "${YELLOW}[INFO]${RESET} Installing ${CYAN}${SELECTED_NAME}${RESET}..."
    echo

    if proot-distro install "$SELECTED"; then
        echo
        echo -e "${GREEN}${BOLD}[✓] VPS installation completed!${RESET}"
    else
        echo
        echo -e "${RED}${BOLD}[✗] VPS installation failed.${RESET}"
        pause
        exit 1
    fi
fi

echo
echo -e "${GREEN}${BOLD}[✓] VPS Ready:${RESET} ${CYAN}${SELECTED_NAME}${RESET}"
pause
