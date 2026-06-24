#!/usr/bin/env bash
set -eoux pipefail

rpm-ostree install -y \
    cockpit \
    git \
    distrobox \
    zsh \
    btop \
    tailscale \
    bazaar \
    cloche-common