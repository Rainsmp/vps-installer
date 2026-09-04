#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASE_DIR/config/config.sh"

while true; do

    clear

    CURRENT="$(get_selected_distro)"

    echo
    echo "╔══════════════════════════════════════════════╗"
    echo "║                                              ║"
    echo "║             TERMUX VPS MANAGER               ║"
    printf "║                    v%-19s║\n" "$VERSION"
    echo "║                                              ║"
    echo "╚══════════════════════════════════════════════╝"
    echo

    if [[ -n "$CURRENT" ]]; then
        echo "Current VPS: $CURRENT"
        echo
    fi

    echo "[1] Delete VPS"
    echo "[2] Reinstall VPS"
    echo "[3] Create VPS"
    echo "[4] Start VPS"
    echo "[5] Restart VPS"
    echo "[6] Stop VPS"
    echo "[7] Enter VPS"
    echo "[8] VPS Status"
    echo "[9] Exit"
    echo

    read -rp "Select an option [1-9]: " choice

    case "$choice" in

        1)
            bash "$OPTIONS_DIR/delete.sh"
            ;;

        2)
            bash "$OPTIONS_DIR/reinstall.sh"
            ;;

        3)
            bash "$OPTIONS_DIR/create.sh"
            ;;

        4)
            bash "$OPTIONS_DIR/start.sh"
            ;;

        5)
            bash "$OPTIONS_DIR/restart.sh"
            ;;

        6)
            bash "$OPTIONS_DIR/stop.sh"
            ;;

        7)
            bash "$OPTIONS_DIR/enter.sh"
            ;;

        8)
            bash "$OPTIONS_DIR/status.sh"
            ;;

        9)
            bash "$OPTIONS_DIR/exit.sh"
            exit 0
            ;;

        *)
            error "Invalid option."
            sleep 1
            ;;

    esac

done
