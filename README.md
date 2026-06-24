<p align="center">
  <picture>
    <img src="cloche-logo/watermark.png" alt="Cloche OS Logo" height="80" />
  </picture>
</p>

<p align="center">
    <strong>Standard RPM-Ostree Workstation</strong>
</p>

<p align="center">
  <strong>Cloche Standard</strong> is a series of immutable, container-native desktop images designed as a rock-solid developer and sysadmin workstation. 
</p>

<p align="center">
  <a href="https://github.com/cloche-project/cloche-standard/actions/workflows/build.yml">
    <img src="https://github.com/cloche-project/cloche-standard/actions/workflows/build.yml/badge.svg" alt="Build Status" />
  </a>
  <a href="https://ghcr.io/cloche-project/cloche-standard-gnome">
    <img src="https://img.shields.io/badge/registry-GHCR-blue?logo=github" alt="GHCR Registry" />
  </a>
  <img src="https://img.shields.io/github/license/cloche-project/cloche-standard" alt="License" />
</p>

> [!NOTE]
> **Cloche Standard inherits directly from the Cloche Headless Base image.** It layering the graphical environments, hardware drivers, and desktop essentials on top of the core secure foundation.

---

## Available Variants

| Image Name | Desktop Environment | Target Use Case |
|------------|---------------------|-----------------|
| `cloche-standard-gnome` | GNOME (Wayland native) | Minimalist, extension-ready developer workstation |
| `cloche-standard-plasma` | KDE Plasma | Highly customizable, feature-rich power-user environment |

---

## Core Desktop Architecture

| Component | Details |
|-----------|---------|
| **Base Layer** | Cloche Headless Base (`ghcr.io/cloche-project/cloche:latest`) |
| **Display Server** | Wayland by default (with XWayland fallback) |
| **Audio Stack** | PipeWire (Low-latency audio engine pre-configured) |
| **App Delivery** | Flatpak (Flathub user-space enabled) + Distrobox |
| **Hardware Support** | Built-in open-source graphics drivers (Mesa/AMDGPU ready) |

---

## Key Desktop Features

* **Layered Separation:** The base system remains completely immutable and clean. All desktop applications are sandboxed via Flatpak, ensuring OS updates never break user space configuration.
* **Desktop Toolkit:** Integrates the core headless utilities (`just`, `distrobox`, `tmux`, `tailscale`) with graphical management tools.
* **Font & UI Optimizations:** Pre-configured with clean geometric typography and system themes geared towards long development sessions.
* **Zero-Drift Workstation:** System packages are declared in this repository's recipes. No more manual `dnf install` steps on fresh machines.

---

## Deployment & Installation

### Remote Rebase

To migrate an existing Fedora Atomic workstation to Cloche Standard, choose your preferred variant and execute:

```bash
# Example: Rebasing to the GNOME variant
rpm-ostree rebase ostree-unverified-registry:ghcr.io/cloche-project/cloche-standard-gnome:latest

# Or for the Plasma variant
rpm-ostree rebase ostree-unverified-registry:ghcr.io/cloche-project/cloche-standard-plasma:latest
```
## Apply the desktop layers by rebooting your system:

```bash
systemctl reboot

Post-Installation Recommended Steps

    Verify Layers: Run rpm-ostree status to ensure the base and local overrides match expectations.

    Setup Flatpaks: Flatpak remotes are configured at system level; user-space apps can be added without root privileges via Software Center or CLI.
```

## Verification & Security

Every desktop image build is signed via Sigstore Cosign against the repository's public verification key.

```bash
# Verify the specific desktop variant layer
cosign verify --key cosign.pub ghcr.io/cloche-project/cloche-standard-gnome:latest
``` 

## License & Acknowledgments

    Licensed under Apache 2.0

    Inherits core security from the cloche-project/cloche base layer

    Powered by the BlueBuild framework and Universal Blue project engines