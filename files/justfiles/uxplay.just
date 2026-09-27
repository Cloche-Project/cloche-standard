# Enable UxPlay (AirPlay mirroring receiver) as a user service.
# Upstream explicitly recommends against running it as a root/system
# service, so this wires it up under the logged-in user's session instead.
[group('cloche')]
enable-uxplay:
    mkdir -p ~/.config/systemd/user
    cat > ~/.config/systemd/user/uxplay.service <<'EOF'
    [Unit]
    Description=AirPlay Unix mirroring server

    [Service]
    Type=simple
    ExecStart=uxplay
    Restart=on-failure

    [Install]
    WantedBy=default.target
    EOF
    systemctl --user daemon-reload
    systemctl --user enable --now uxplay.service
    echo "UxPlay enabled. Your device should now show up as an AirPlay receiver on the local network."
    echo "Check status with: systemctl --user status uxplay.service"

# Disable and remove the UxPlay user service
[group('cloche')]
disable-uxplay:
    systemctl --user disable --now uxplay.service 2>/dev/null || true
    rm -f ~/.config/systemd/user/uxplay.service
    systemctl --user daemon-reload
    echo "UxPlay service disabled and removed."
