#!/usr/bin/env bash
set -eoux pipefail

rpm-ostree install -y \
    plasma-oxygen\
    oxygen-icon-theme\
    cloche-kde-defaults