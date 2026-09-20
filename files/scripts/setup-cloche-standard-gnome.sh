#!/bin/bash

# Set boot animation
plymouth-set-default-theme spinner

# remove silverblue's defaults
echo "Removing default wallpapers"
rm -f /usr/share/backgrounds/f40/default/f40-01-day.png
rm -f /usr/share/backgrounds/f40/default/f40-01-night.png
rm -f /usr/share/backgrounds/default.png
rm -f /usr/share/backgrounds/default-dark.png

# set Cloche global symlinks for Wallpapers
echo "Setting symlinks for Cloche wallpapers"
ln -sf /usr/share/wallpapers/Cloche-Default/contents/images/3840x2025.webp /usr/share/backgrounds/default.png
ln -sf /usr/share/wallpapers/Cloche-Default/contents/images/3840x2025-dark.webp /usr/share/backgrounds/default-dark.png

# replace Fedora's GDM and system Logos with Plymouth Watermark
echo "Replacing Upstream GDM and System Logos..."
rm -f /usr/share/pixmaps/fedora-gdm-logo.png
rm -f /usr/share/pixmaps/system-logo-white.png

ln -sf /usr/share/plymouth/themes/spinner/watermark.png /usr/share/pixmaps/fedora-gdm-logo.png
ln -sf /usr/share/plymouth/themes/spinner/watermark.png /usr/share/pixmaps/system-logo-white.png

#
#echo "removing Fedora GDM and System Logos..."
#rm -f /usr/share/pixmaps/fedora-gdm-logo.png
#rm -f /usr/share/pixmaps/system-logo-white.png

#ln -sf /usr/share/plymouth/themes/spinner/watermark.png /usr/share/pixmaps/fedora-gdm-logo.png
#ln -sf /usr/share/plymouth/themes/spinner/watermark.png /usr/share/pixmaps/system-logo-white.png

# replace gnome's about logo on system settings
echo "CPing Cloche to GNOME about on Settings"

mkdir -p /usr/share/icons/hicolor/256x256/apps/
# copies the Plymouth watermark as the official system logo
cp -f /usr/share/plymouth/themes/spinner/watermark.png /usr/share/icons/hicolor/256x256/apps/cloche-logo.png
cp -f /usr/share/plymouth/themes/spinner/watermark.png /usr/share/pixmaps/cloche-logo.png
# refresh the icon cache so gnome finds it instantly
gtk-update-icon-cache /usr/share/icons/hicolor || true

# replace about on Bazzite based images
echo "Replacing logo for Bazzite-based images"

# remove hardcoded logos
rm -f /usr/share/pixmaps/fedora_logo_med.png
rm -f /usr/share/pixmaps/fedora_whitelogo_med.png

# symlinking Cloche logo to hardcoded paths of the previous steps
ln -sf /usr/share/plymouth/themes/spinner/watermark.png /usr/share/pixmaps/fedora_logo_med.png
ln -sf /usr/share/plymouth/themes/spinner/watermark.png /usr/share/pixmaps/fedora_whitelogo_med.png

# change gdm default accent color for bazzite
echo "Changing GDM default accent color"
# remove any Bazzite specific GDM overrides
rm -f /etc/dconf/db/gdm.d/*bazzite*

# Create a clean Cloche override for GDM's login screen
mkdir -p /etc/dconf/db/gdm.d
cat << 'EOF' > /etc/dconf/db/gdm.d/99-cloche-gdm
[org/gnome/desktop/interface]
color-scheme='prefer-dark'
accent-color='blue'
EOF

echo "Removing upstream dconf database"
rm -rf /etc/skel/.config/dconf

# Update Cloche database from script generated dconf
echo "Updating dconf"
dconf update

# Fastfetch patch for distrobox
if [ -f /etc/skel/.bashrc ]; then
    sed -i '/alias fastfetch/d' /etc/skel/.bashrc
fi

if [ -f /etc/skel/.zshrc ]; then
    sed -i '/alias fastfetch/d' /etc/skel/.zshrc
fi