#!/bin/bash

STATE_FILE="$HOME/.cache/cloche-welcome-shown"

# Prevent spamming the user on every new shell
if [ ! -f "$STATE_FILE" ]; then
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
    fi

    # Fallback to 'Cloche' just in case os-release is mangled
    OS_NAME="${PRETTY_NAME:-Cloche}"

    echo -e "Welcome to \e[1;34m${OS_NAME}\e[0m."
    echo ""
    echo "This terminal is running on the host system. You may want to try"
    echo "out Distrobox for a directly mutable environment that allows"
    echo "package installation with DNF."
    echo ""
    echo -e "Type \e[1;32mdistrobox create\e[0m to start."
    echo ""

    mkdir -p "$(dirname "$STATE_FILE")"
    touch "$STATE_FILE"
fi
