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
    cloche-common \
    ghostty \
    newt \
    spice-vdagent \
    qemu-guest-agent \
    uxplay

# UxPlay (enable-uxplay just recipe) uses the legacy fixed AirPlay ports
# (-p flag) so they can be opened here at build time.
firewall-offline-cmd --zone=public \
    --add-port=7000-7001/tcp \
    --add-port=7100/tcp \
    --add-port=6000-6001/udp \
    --add-port=7011/udp

curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir /usr/bin