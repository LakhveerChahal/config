#!/usr/bin/env bash

################################
### System Setup Script #######
################################

# Author: Lakhveer Singh
# Date: 2025-11-22
# Description: This script sets up a new Arch Linux 
# system by installing essential packages, configuring system settings.

CWD=$(pwd)
readonly CWD

function source_bashrc() {
    if [ -f ~/.bashrc ]; then
        # shellcheck source=/dev/null
        source ~/.bashrc
    fi
}

function install_packages() {
    sudo pacman -Syu --noconfirm

    # Essential packages
    local packages=(
        "hyprland",
        "gtk4",
        "ghostty",
        "waybar",
        "keyd",
        "brightnessctl",
        "pavucontrol",
        "openssh",
        "neovim",
        "wl-clipboard"
        "greetd",
        "nvm",
        "zoxide",
        "lazygit",
        "less",
        "pipewire",
        "pipewire-pulse",
        "wireplumber",
        "zip",
        "unzip",
        "tmux",
        "dolphin",
        "hyprpaper"
    )
    for package in "${packages[@]}"; do
        sudo pacman -S --noconfirm "$package"
    done
    install_paru
    install_tmuxinator
    install_mirage
}

function update_configs() {
    configure_hyprland
    configure_greetd
    configure_nvm
    configure_ghostty
    configure_zoxide
    configure_waybar
    configure_bash_aliases
    configure_audio
}

function clone_repos() {
    clone_sdkman
    clone_nvim
}

function install_paru() {
    if ! command -v paru &> /dev/null; then
        echo "paru not found, installing..."
        git clone https://aur.archlinux.org/paru.git ~/paru
        cd ~/paru || exit
        makepkg -si --noconfirm
        cd "$CWD" || exit
        rm -rf ~/paru
    else
        echo "paru is already installed."
    fi
}

function install_tmuxinator() {
    paru -S --noconfirm tmuxinator

    cp ../.tmux.conf ~/.tmux.conf
}

function install_mirage() {
    paru -S --noconfirm mirage
}

function clone_nvim() {
    mkdir -p ~/.config
    
    rm -rf ~/.config/nvim
    # clone nvim config
    cd ~/.config && git clone https://github.com/LakhveerChahal/nvim

    cd ~ && mkdir -p nvim-space
    cd ~ && mkdir -p nvim-plugins && cd nvim-plugins && mkdir -p nvim-jdtls

    rm -rf ~/nvim-plugins/java-debug

    cd ~/nvim-plugins && curl -sL -o java-debug.tar.gz https://github.com/microsoft/java-debug/archive/refs/tags/0.53.1.tar.gz \
        && tar -xzf java-debug.tar.gz \
        && mv java-debug-0.53.1 java-debug \
        && cd java-debug && ./mvnw clean install -DskipTests

    cd ~/nvim-plugins && curl "https://download.eclipse.org/jdtls/milestones/1.43.0/jdt-language-server-1.43.0-202412191447.tar.gz" -o jdtls.tar.gz
    cd ~/nvim-plugins/nvim-jdtls/ && tar -xzf ../jdtls.tar.gz 

    if [ ! -f ~/nvim-plugins/lombok.jar ]; then
        echo "Downloading Lombok..."
        # Download Lombok jar if it doesn't exist
        cd ~/nvim-plugins && curl https://projectlombok.org/downloads/lombok.jar -o lombok.jar
    else
        echo "Lombok jar already exists."
    fi
}

# Install sdkman and Java, Maven
function clone_sdkman() {
    if [ -d "$HOME/.sdkman" ]; then
        echo "sdkman is already installed."
    else
        echo "Installing sdkman..."
        curl -s "https://get.sdkman.io" | bash
        source "$HOME/.sdkman/bin/sdkman-init.sh"
        # Install Java
        sdk install java 21.0.8-amzn
        # Install Maven
        sdk install maven 3.9.5
    fi
}

function configure_hyprland() {
    mkdir -p ~/.config/hypr
    cp ./hyprland/hyprland.conf ~/.config/hypr/hyprland.conf
}

function configure_greetd() {
    sudo cp ./greetd/config.toml /etc/greetd/
    sudo systemctl enable greetd.service
}

function configure_nvm() {
    # update .bashrc for nvm
    if ! grep -q 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' ~/.bashrc; then
        echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' >> ~/.bashrc
        echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.bashrc
    fi
    source_bashrc

    nvm install 24.0.0
}

function configure_ghostty() {
    cp ./ghostty/config ~/.ghostty/config
}

function configure_zoxide() {
    # update .bashrc for zoxide
    if ! grep -q 'eval "$(zoxide init bash)"' ~/.bashrc; then
        echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
    fi
    source_bashrc
}

function configure_waybar() {
    mkdir -p ~/.config/waybar
    cp -r ./waybar/* ~/.config/waybar/
}

function configure_bash_aliases() {
    cp ../.bash_aliases ~/.bash_aliases.sh
    if ! grep -q 'source ~/.bash_aliases.sh' ~/.bashrc; then
        echo 'source ~/.bash_aliases.sh' >> ~/.bashrc
    fi
    source_bashrc
}

function configure_audio() {
    # Enable and start PipeWire services
    sudo systemctl --user enable pipewire pipewire-pulse wireplumber
    sudo systemctl --user start pipewire pipewire-pulse wireplumber
}

function main() {
    install_packages
    update_configs
    clone_repos
    echo "System setup completed successfully!"
}

main
