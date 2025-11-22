#!/usr/bin/env bash

# This script synchronizes configuration files from this git repository to the system.

function main() {
    cp -r ./ghostty/config ~/.config/ghostty/
    cp -r ./hyprland/hyprland.conf ~/.config/hyprland
    cp -r ./waybar/** ~/.config/waybar/
    sudo cp -r ./greetd/config.toml /etc/greetd/
}

main
