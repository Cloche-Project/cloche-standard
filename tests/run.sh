#!/usr/bin/env bash
# Test entrypoint for cloche-standard. See tests/README.md for what this
# covers, why it mirrors cloche-pro-workstation's suite, and the list of
# unverified paths to confirm before trusting this in CI.

set -uo pipefail

UTILS_DIR="${CLOCHE_UTILS_DIR:-../cloche-utils}"
# shellcheck source=../../cloche-utils/testing/test-lib.sh
source "$UTILS_DIR/testing/test-lib.sh"

IMAGE="${1:-cloche-standard-test}"
BUILD_METHOD="bluebuild"
RECIPE="./recipes/standard-plasma.yml"

# --- Feature 1: KDE skel files ---
test_skel_kactivitymanagerdrc() { exec_in_image "test -f /etc/skel/.config/kactivitymanagerdrc"; }
test_skel_kglobalshortcutsrc()  { exec_in_image "test -f /etc/skel/.config/kglobalshortcutsrc"; }
test_skel_konsolerc()           { exec_in_image "test -f /etc/skel/.config/konsolerc"; }
test_skel_kscreenlockerrc()     { exec_in_image "test -f /etc/skel/.config/kscreenlockerrc"; }
test_skel_konsole_profile()     { exec_in_image "test -f /etc/skel/.local/share/konsole/Main.profile"; }

# --- Feature 2: dynamic KDE wallpaper (structure only) ---
test_wallpaper_light_dir() { exec_in_image "test -d /usr/share/wallpapers/*/contents/images"; }
test_wallpaper_dark_dir()  { exec_in_image "test -d /usr/share/wallpapers/*/contents/images-dark"; }
test_wallpaper_metadata()  { exec_in_image "grep -rq 'DynamicMode=2' /usr/share/wallpapers/*/"; }

# --- Feature 3: GNOME CustomTransparent shell theme ---
test_gnome_theme_present() { exec_in_image "test -d /usr/share/themes/CustomTransparent"; }
test_gnome_shell_css()     { exec_in_image "test -f /usr/share/themes/CustomTransparent/gnome-shell/gnome-shell.css"; }

# --- Feature 4: rpm-repo package connection ---
test_pkg_common()         { exec_in_image "rpm -q cloche-common"; }
test_pkg_kde_defaults()   { exec_in_image "rpm -q cloche-kde-defaults"; }
test_pkg_gnome_defaults() { exec_in_image "rpm -q cloche-gnome-defaults"; }
test_pkg_wallpapers()     { exec_in_image "rpm -q cloche-wallpapers-1"; }

# --- Feature 5: display manager enabled ---
test_plasmalogin_user()   { exec_in_image "getent passwd plasmalogin"; }
test_plasmalogin_preset() { exec_in_image "grep -rq 'enable plasmalogin.service' /usr/lib/systemd/system-preset/"; }

# --- Feature 6: boot-speed systemd masks ---
# Adjust this list to match whatever units the systemd module actually masks.
test_boot_masks_present() {
    exec_in_image "test -L /etc/systemd/system/NetworkManager-wait-online.service && \
                    readlink /etc/systemd/system/NetworkManager-wait-online.service | grep -q /dev/null"
}

# --- Feature 7: plasma-discover exclusion pair ---
test_discover_excluded()          { ! exec_in_image "rpm -q plasma-discover"; }
test_discover_notifier_excluded() { ! exec_in_image "rpm -q plasma-discover-notifier"; }

main() {
    build_image || { echo "Build failed, aborting tests."; exit 1; }

    echo ""
    echo "=== Feature 1: KDE skel files ==="
    run_check "kactivitymanagerdrc" test_skel_kactivitymanagerdrc
    run_check "kglobalshortcutsrc"  test_skel_kglobalshortcutsrc
    run_check "konsolerc"           test_skel_konsolerc
    run_check "kscreenlockerrc"     test_skel_kscreenlockerrc
    run_check "konsole Main.profile" test_skel_konsole_profile

    echo ""
    echo "=== Feature 2: dynamic wallpaper (structure only, not rendering) ==="
    run_check "images/ dir exists"      test_wallpaper_light_dir
    run_check "images-dark/ dir exists" test_wallpaper_dark_dir
    run_check "DynamicMode=2 set"       test_wallpaper_metadata

    echo ""
    echo "=== Feature 3: GNOME CustomTransparent theme ==="
    run_check "theme dir present"       test_gnome_theme_present
    run_check "gnome-shell.css present" test_gnome_shell_css

    echo ""
    echo "=== Feature 4: rpm-repo package connection ==="
    run_check "cloche-common installed"         test_pkg_common
    run_check "cloche-kde-defaults installed"   test_pkg_kde_defaults
    run_check "cloche-gnome-defaults installed" test_pkg_gnome_defaults
    run_check "cloche-wallpapers-1 installed"   test_pkg_wallpapers

    echo ""
    echo "=== Feature 5: display manager ==="
    run_check "plasmalogin system user exists"     test_plasmalogin_user
    run_check "plasmalogin.service preset enabled" test_plasmalogin_preset

    echo ""
    echo "=== Feature 6: boot-speed masks ==="
    run_check "NetworkManager-wait-online masked" test_boot_masks_present

    echo ""
    echo "=== Feature 7: plasma-discover exclusion ==="
    run_check "plasma-discover excluded"          test_discover_excluded
    run_check "plasma-discover-notifier excluded" test_discover_notifier_excluded

    print_summary
}

main
