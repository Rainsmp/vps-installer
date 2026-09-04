#!/data/data/com.termux/files/usr/bin/bash

source "$(cd "$(dirname "$0")/../config" && pwd)/config.sh"

select_distro() {

    clear

    echo
    echo "╔══════════════════════════════════════════════╗"
    echo "║                                              ║"
    echo "║          SELECT LINUX DISTRIBUTION            ║"
    echo "║                                              ║"
    echo "╚══════════════════════════════════════════════╝"
    echo

    local list
    list="$(proot-distro list 2>/dev/null || true)"

    if [[ -z "$list" ]]; then
        error "Unable to read proot-distro distributions."
        pause
        return 1
    fi

    local distros=()

    while IFS= read -r line; do

        local name

        name="$(echo "$line" | sed -n 's/^[[:space:]]*\([a-zA-Z0-9_-]\+\).*/\1/p' | head -n 1)"

        case "$name" in
            alpine|archlinux|artix|debian|deepin|fedora|manjaro|openkylin|opensuse|pardus|ubuntu|void)
                distros+=("$name")
                ;;
        esac

    done <<< "$list"

    if [[ ${#distros[@]} -eq 0 ]]; then
        error "No supported distributions were detected."
        echo
        echo "$list"
        pause
        return 1
    fi

    local i=1

    for distro in "${distros[@]}"; do
        echo "[$i] $distro"
        ((i++))
    done

    echo
    echo "[0] Back"
    echo

    read -rp "Select distribution: " choice

    if [[ "$choice" == "0" ]]; then
        return 1
    fi

    if [[ "$choice" =~ ^[0-9]+$ ]] &&
       (( choice >= 1 && choice <= ${#distros[@]} )); then

        local selected="${distros[$((choice-1))]}"

        set_selected_distro "$selected"

        echo
        success "Selected: $selected"
        sleep 1

        return 0
    fi

    error "Invalid selection."
    pause

    return 1
}
