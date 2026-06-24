#!/usr/bin/env bash
set -eoux pipefail

rpm-ostree install -y \
    gnome-shell-extension-dash-to-dock\
    gnome-shell-extension-dash-to-panel \
    gnome-shell-extension-blur-my-shell \
    gnome-shell-extension-caffeine \
    cloche-gnome-defaults