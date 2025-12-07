#!/usr/bin/env bash

# This script synchronizes configuration files from system to this git repository.

function main() {
    cp -r ~/.config/ghostty/config ./ghostty/
    cp -r ~/.config/hypr/hyprland.conf ./hyprland/
    cp -r ~/.config/waybar/** ./waybar/
    sudo cp -r /etc/greetd/config.toml ./greetd/
    cp ~/.tmux.conf ../.tmux.conf
    cp -r ~/.config/tmuxinator ../tmuxinator
}

main
