#!/data/data/com.termux/files/usr/bin/bash

source "$(cd "$(dirname "$0")/../config" && pwd)/config.sh"

configure_distro() {

    local distro="$1"

    [[ -z "$distro" ]] && return 1

    info "Configuring $distro..."

    case "$distro" in

        debian|ubuntu)
            proot-distro login "$distro" -- bash -c '
                export DEBIAN_FRONTEND=noninteractive

                apt-get update

                apt-get upgrade -y

                apt-get install -y \
                    sudo \
                    curl \
                    wget \
                    git \
                    nano \
                    vim \
                    unzip \
                    zip \
                    tar \
                    gzip \
                    bzip2 \
                    xz-utils \
                    jq \
                    tree \
                    htop \
                    tmux \
                    python3 \
                    python3-pip \
                    python3-venv \
                    ca-certificates \
                    gnupg \
                    build-essential \
                    pkg-config \
                    openssl \
                    procps \
                    iproute2 \
                    net-tools
            '
            ;;

        alpine)
            proot-distro login "$distro" -- sh -c '
                apk update
                apk upgrade
                apk add \
                    sudo \
                    curl \
                    wget \
                    git \
                    nano \
                    vim \
                    unzip \
                    zip \
                    tar \
                    gzip \
                    jq \
                    tree \
                    htop \
                    tmux \
                    python3 \
                    py3-pip \
                    ca-certificates \
                    openssl \
                    build-base \
                    iproute2 \
                    net-tools
            '
            ;;

        archlinux)
            proot-distro login "$distro" -- bash -c '
                pacman -Syu --noconfirm
                pacman -S --noconfirm \
                    sudo \
                    curl \
                    wget \
                    git \
                    nano \
                    vim \
                    unzip \
                    zip \
                    tar \
                    gzip \
                    jq \
                    tree \
                    htop \
                    tmux \
                    python \
                    python-pip \
                    ca-certificates \
                    openssl \
                    base-devel \
                    iproute2 \
                    net-tools
            '
            ;;

        fedora)
            proot-distro login "$distro" -- bash -c '
                dnf upgrade -y
                dnf install -y \
                    sudo \
                    curl \
                    wget \
                    git \
                    nano \
                    vim \
                    unzip \
                    zip \
                    tar \
                    gzip \
                    jq \
                    tree \
                    htop \
                    tmux \
                    python3 \
                    python3-pip \
                    ca-certificates \
                    openssl \
                    gcc \
                    gcc-c++ \
                    make \
                    iproute \
                    net-tools
            '
            ;;

        *)
            warning "$distro has been installed."
            warning "Automatic package configuration is not customized for this distribution."
            ;;

    esac

    success "$distro configuration complete."
}
