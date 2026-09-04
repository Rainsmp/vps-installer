#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$BASE_DIR/config/config.sh"

# Colors
RESET=$'\033[0m'
BOLD=$'\033[1m'

RED=$'\033[31m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
BLUE=$'\033[34m'
MAGENTA=$'\033[35m'
CYAN=$'\033[36m'
WHITE=$'\033[37m'

while true; do

    clear

    echo
    printf "%s%s╔══════════════════════════════════════════════╗%s\n" "$CYAN" "$BOLD" "$RESET"
    printf "%s%s║%s             %s%sTERMUX VPS MANAGER%s               %s%s║%s\n" \
        "$CYAN" "$BOLD" "$RESET" \
        "$BLUE" "$BOLD" " " \
        "$CYAN" "$BOLD" "$RESET"
    printf "%s%s╚══════════════════════════════════════════════╝%s\n" "$CYAN" "$BOLD" "$RESET"

    echo

    CURRENT="$(get_selected_distro 2>/dev/null || true)"

    if [ -n "$CURRENT" ]; then
        printf "              %s%sCURRENT VPS: %s%s%s\n" \
            "$GREEN" "$BOLD" "$CURRENT" "$RESET" ""
    else
        printf "              %s%sNO VPS SELECTED%s\n" \
            "$YELLOW" "$BOLD" "$RESET"
    fi

    echo

    printf "%s[1]%s %sDelete VPS%s\n" "$CYAN" "$RESET" "$WHITE" "$RESET"
    printf "%s[2]%s %sReinstall VPS%s\n" "$CYAN" "$RESET" "$WHITE" "$RESET"
    printf "%s[3]%s %sCreate VPS%s\n" "$CYAN" "$RESET" "$WHITE" "$RESET"
    printf "%s[4]%s %sStart VPS%s\n" "$CYAN" "$RESET" "$WHITE" "$RESET"
    printf "%s[5]%s %sRestart VPS%s\n" "$CYAN" "$RESET" "$WHITE" "$RESET"
    printf "%s[6]%s %sStop VPS%s\n" "$CYAN" "$RESET" "$WHITE" "$RESET"
    printf "%s[7]%s %sEnter VPS%s\n" "$CYAN" "$RESET" "$WHITE" "$RESET"
    printf "%s[8]%s %sVPS Status%s\n" "$CYAN" "$RESET" "$WHITE" "$RESET"
    printf "%s[9]%s %sExit%s\n" "$RED" "$RESET" "$WHITE" "$RESET"

    echo

    printf "%s%sSelect option: %s" "$YELLOW" "$BOLD" "$RESET"
    read -r choice

    case "$choice" in
        1)
            "$BASE_DIR/options/delete.sh"
            ;;
        2)
            "$BASE_DIR/options/reinstall.sh"
            ;;
        3)
            "$BASE_DIR/options/create.sh"
            ;;
        4)
            "$BASE_DIR/options/start.sh"
            ;;
        5)
            "$BASE_DIR/options/restart.sh"
            ;;
        6)
            "$BASE_DIR/options/stop.sh"
            ;;
        7)
            "$BASE_DIR/options/enter.sh"
            ;;
        8)
            "$BASE_DIR/options/status.sh"
            ;;
        9)
            "$BASE_DIR/options/exit.sh"
            exit 0
            ;;
        *)
            echo
            printf "%s%s[✗] Invalid option.%s\n" "$RED" "$BOLD" "$RESET"
            sleep 2
            ;;
    esac

done
