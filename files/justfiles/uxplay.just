# Enable UxPlay (AirPlay mirroring receiver) as a user service.
# Upstream explicitly recommends against running it as a root/system
# service, so this wires it up under the logged-in user's session instead.
[group('cloche')]
enable-uxplay:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p ~/.config/systemd/user
    cat > ~/.config/systemd/user/uxplay.service <<'EOF'
    [Unit]
    Description=AirPlay Unix mirroring server

    [Service]
    Type=simple
    ExecStart=uxplay -p
    Restart=on-failure

    [Install]
    WantedBy=default.target
    EOF
    systemctl --user daemon-reload
    systemctl --user enable --now uxplay.service
    echo "Opening AirPlay ports on the local network (sudo required)..."
    sudo firewall-cmd --zone=public --add-port=7000-7001/tcp --add-port=7100/tcp --add-port=6000-6001/udp --add-port=7011/udp --permanent
    sudo firewall-cmd --reload
    echo "UxPlay enabled. Your device should now show up as an AirPlay receiver on the local network."
    echo "Check status with: systemctl --user status uxplay.service"

# Disable and remove the UxPlay user service
[group('cloche')]
disable-uxplay:
    systemctl --user disable --now uxplay.service 2>/dev/null || true
    rm -f ~/.config/systemd/user/uxplay.service
    systemctl --user daemon-reload
    echo "Closing AirPlay ports (sudo required)..."
    sudo firewall-cmd --zone=public --remove-port=7000-7001/tcp --remove-port=7100/tcp --remove-port=6000-6001/udp --remove-port=7011/udp --permanent 2>/dev/null || true
    sudo firewall-cmd --reload
    echo "UxPlay service disabled and removed."
