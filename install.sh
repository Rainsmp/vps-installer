#!/usr/bin/env bash
set -Eeuo pipefail

# ============================================================
#              PTERODACTYL WINGS INSTALLER
#                    VPS INSTALLER v1.0
# ============================================================

VERSION="1.0.0"
LOG_FILE="/var/log/pterodactyl-installer.log"

# -------------------- COLORS --------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# -------------------- FUNCTIONS --------------------

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
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

banner() {
    clear
    echo
    echo "╔══════════════════════════════════════════════╗"
    echo "║                                              ║"
    echo "║        PTERODACTYL WINGS INSTALLER          ║"
    echo "║                  v${VERSION}                   ║"
    echo "║                                              ║"
    echo "╚══════════════════════════════════════════════╝"
    echo
}

die() {
    error "$1"
    exit 1
}

cleanup() {
    echo
    warning "Installation interrupted."
}

trap cleanup INT TERM

# -------------------- LOGGING --------------------

if [[ $EUID -eq 0 ]]; then
    touch "$LOG_FILE" 2>/dev/null || true
fi

exec > >(tee -a "$LOG_FILE") 2>&1

# -------------------- ROOT CHECK --------------------

check_root() {
    log "Checking root privileges..."

    if [[ $EUID -ne 0 ]]; then
        die "This installer must be run as root."
    fi

    success "Running as root"
}

# -------------------- OS CHECK --------------------

check_os() {
    log "Checking operating system..."

    if [[ ! -f /etc/os-release ]]; then
        die "Cannot detect operating system."
    fi

    source /etc/os-release

    echo "Operating System : ${PRETTY_NAME:-Unknown}"
    echo "Architecture     : $(uname -m)"
    echo "Kernel           : $(uname -r)"
    echo

    if [[ "$ID" != "debian" ]]; then
        warning "This installer is designed for Debian."
        read -rp "Continue anyway? [y/N]: " answer

        if [[ ! "$answer" =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    if [[ "$ID" == "debian" && "${VERSION_ID:-}" != "13" ]]; then
        warning "This installer was prepared for Debian 13."
        warning "Detected Debian ${VERSION_ID:-unknown}."
    fi

    success "Operating system check completed"
}

# -------------------- ARCHITECTURE --------------------

check_architecture() {
    log "Checking CPU architecture..."

    ARCH="$(uname -m)"

    case "$ARCH" in
        x86_64)
            WINGS_ARCH="amd64"
            success "Architecture: x86_64 / amd64"
            ;;
        aarch64|arm64)
            WINGS_ARCH="arm64"
            success "Architecture: ARM64"
            ;;
        *)
            die "Unsupported architecture: $ARCH"
            ;;
    esac
}

# -------------------- VIRTUALIZATION --------------------

check_virtualization() {
    log "Checking virtualization..."

    if command -v systemd-detect-virt >/dev/null 2>&1; then
        VIRT="$(systemd-detect-virt || true)"
        echo "Virtualization: ${VIRT:-unknown}"

        case "$VIRT" in
            openvz|lxc)
                warning "Detected $VIRT virtualization."
                warning "Docker/Wings may not work correctly."
                ;;
            *)
                success "Virtualization check completed"
                ;;
        esac
    else
        warning "systemd-detect-virt is unavailable."
    fi
}

# -------------------- NETWORK --------------------

check_network() {
    log "Checking network connectivity..."

    if ! command -v curl >/dev/null 2>&1; then
        apt-get update -y
        apt-get install -y curl ca-certificates
    fi

    PUBLIC_IP="$(curl -4 -fsS --max-time 10 https://api.ipify.org || true)"

    if [[ -n "$PUBLIC_IP" ]]; then
        success "Public IPv4: $PUBLIC_IP"
    else
        warning "Could not determine public IPv4."
    fi
}

# -------------------- UPDATE SYSTEM --------------------

update_system() {
    log "Updating package lists..."

    export DEBIAN_FRONTEND=noninteractive

    apt-get update -y

    success "Package lists updated"
}

# -------------------- DEPENDENCIES --------------------

install_dependencies() {
    log "Installing required dependencies..."

    export DEBIAN_FRONTEND=noninteractive

    apt-get install -y \
        curl \
        ca-certificates \
        gnupg \
        lsb-release \
        apt-transport-https \
        software-properties-common \
        git \
        tar \
        unzip \
        jq

    success "Dependencies installed"
}

# -------------------- DOCKER --------------------

install_docker() {
    log "Checking Docker..."

    if command -v docker >/dev/null 2>&1; then
        success "Docker is already installed"
    else
        log "Installing Docker CE..."

        curl -fsSL https://get.docker.com/ | CHANNEL=stable bash

        success "Docker installed"
    fi

    if command -v systemctl >/dev/null 2>&1; then
        systemctl enable --now docker

        success "Docker service enabled and started"
    else
        warning "systemctl is unavailable."
        warning "Docker cannot be configured as a normal system service."
    fi

    if ! docker info >/dev/null 2>&1; then
        warning "Docker is installed but the daemon is not responding."
        warning "Check your VPS virtualization/kernel configuration."
    else
        success "Docker is working"
    fi
}

# -------------------- WINGS DIRECTORY --------------------

prepare_wings() {
    log "Preparing Pterodactyl directories..."

    mkdir -p /etc/pterodactyl
    mkdir -p /var/lib/pterodactyl
    mkdir -p /var/log/pterodactyl
    mkdir -p /srv/daemon-data

    success "Directories created"
}

# -------------------- WINGS --------------------

install_wings() {
    log "Downloading Pterodactyl Wings..."

    WINGS_URL="https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_${WINGS_ARCH}"

    curl -fL \
        -o /usr/local/bin/wings \
        "$WINGS_URL"

    chmod u+x /usr/local/bin/wings

    if [[ ! -x /usr/local/bin/wings ]]; then
        die "Wings installation failed."
    fi

    success "Wings binary installed"
}

# -------------------- SYSTEMD --------------------

create_wings_service() {
    log "Creating Wings systemd service..."

    if ! command -v systemctl >/dev/null 2>&1; then
        warning "systemctl is unavailable."
        warning "Skipping systemd configuration."
        return
    fi

    cat > /etc/systemd/system/wings.service <<'SERVICE'
[Unit]
Description=Pterodactyl Wings Daemon
After=docker.service
Requires=docker.service
PartOf=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
LimitNOFILE=4096
PIDFile=/var/run/wings/daemon.pid
ExecStart=/usr/local/bin/wings
Restart=on-failure
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
SERVICE

    systemctl daemon-reload

    success "Wings service created"
}

# -------------------- CONFIG CHECK --------------------

check_configuration() {
    log "Checking Wings configuration..."

    if [[ -f /etc/pterodactyl/config.yml ]]; then
        success "config.yml already exists"
    else
        warning "Wings config.yml has not been created yet."
        echo
        echo "You must create a Node in your Pterodactyl Panel."
        echo "Then copy its generated Wings configuration to:"
        echo
        echo "    /etc/pterodactyl/config.yml"
        echo
    fi
}

# -------------------- FIREWALL --------------------

configure_firewall() {
    log "Checking firewall..."

    if command -v ufw >/dev/null 2>&1; then
        echo
        echo "UFW is already installed."
        echo "The installer will NOT automatically change your firewall."
        echo "Configure the ports required by your Panel/node."
    else
        log "UFW is not installed."
        echo "Firewall configuration will be left to the VPS administrator."
    fi

    success "Firewall check completed"
}

# -------------------- STATUS --------------------

show_status() {
    echo
    echo "=============================================="
    echo "             INSTALLATION STATUS"
    echo "=============================================="
    echo

    if command -v docker >/dev/null 2>&1; then
        echo "Docker : INSTALLED"
    else
        echo "Docker : NOT INSTALLED"
    fi

    if [[ -x /usr/local/bin/wings ]]; then
        echo "Wings  : INSTALLED"
    else
        echo "Wings  : NOT INSTALLED"
    fi

    if [[ -f /etc/pterodactyl/config.yml ]]; then
        echo "Config : FOUND"
    else
        echo "Config : NOT FOUND"
    fi

    echo
}

# -------------------- FINAL --------------------

finish() {
    echo
    echo "╔══════════════════════════════════════════════╗"
    echo "║                                              ║"
    echo "║          INSTALLATION COMPLETE               ║"
    echo "║                                              ║"
    echo "╚══════════════════════════════════════════════╝"
    echo

    success "Docker has been installed."
    success "Wings has been installed."
    success "Systemd service has been created."

    echo
    echo "Next step:"
    echo
    echo "1. Create your Node in the Pterodactyl Panel."
    echo "2. Open the Node's Configuration tab."
    echo "3. Copy the generated configuration."
    echo "4. Save it as:"
    echo
    echo "   /etc/pterodactyl/config.yml"
    echo
    echo "5. Test Wings with:"
    echo
    echo "   wings --debug"
    echo
    echo "6. Once it works, start it with:"
    echo
    echo "   systemctl enable --now wings"
    echo
    echo "Installer log:"
    echo
    echo "   $LOG_FILE"
    echo
}

# ============================================================
#                         MAIN
# ============================================================

banner

check_root
check_os
check_architecture
check_virtualization
check_network
update_system
install_dependencies
install_docker
prepare_wings
install_wings
create_wings_service
check_configuration
configure_firewall
show_status
finish
