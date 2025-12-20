#!/usr/bin/env bash

# This script synchronizes configuration files from this git repository to the system.

function main() {
    cp -r ./ghostty/config ~/.config/ghostty/
    cp -r ./hypr ~/.config/hypr
    cp -r ./waybar/** ~/.config/waybar/
    sudo cp -r ./greetd/config.toml /etc/greetd/
    cp ../.tmux.conf ~/.tmux.conf
    cp -r ../tmuxinator ~/.config/
    cp -r ./wofi ~/.config/wofi
    cp -r ./kdewallet/kwalletrc ~/.config/kwalletrc
}

main
