#!/usr/bin/env bash
set -e

USERNAME="$(whoami)"
AUTOSTART_DIR="/home/$USERNAME/.config/autostart"
ASSETS_DIR="/home/$USERNAME/kiosk-setup/assets"
WALLPAPER_DIR="/home/$USERNAME/Pictures"
WALLPAPER_FILE="$WALLPAPER_DIR/kiosk-background.png"

mkdir -p "$AUTOSTART_DIR"

if [ -f "$ASSETS_DIR/kiosk-background.png" ]; then
	cp "$ASSETS_DIR/kiosk-background.png" "$WALLPAPER_FILE"
fi

sudo apt update
sudo apt install -y git
sudo apt install -y chromium-browser || sudo apt install -y chromium

sudo adduser "$USERNAME" nopasswdlogin || true

sudo mkdir -p /etc/lightdm/lightdm.conf.d
sudo tee /etc/lightdm/lightdm.conf.d/12-autologin.conf > /dev/null <<EOF
[Seat:*]
autologin-user=$USERNAME
autologin-user-timeout=0
EOF

tee "$AUTOSTART_DIR/kiosk.desktop" > /dev/null <<'EOF'
[Desktop Entry]
Type=Application
Name=Chromium Kiosk
Exec=chromium-browser --kiosk --incognito --noerrdialogs --disable-infobars --check-for-update-interval=31536000 https://www.themetalcompany.co.nz
X-GNOME-Autostart-enabled=true
Terminal=false
EOF

if ! command -v chromium-browser >/dev/null 2>&1 && command -v chromium >/dev/null 2>&1; then
	sed -i 's/^Exec=chromium-browser /Exec=chromium /' "$AUTOSTART_DIR/kiosk.desktop"
fi

tee "$AUTOSTART_DIR/display-awake.desktop" > /dev/null <<'EOF'
[Desktop Entrty]
Type=Application
Name=Keep Display Awake
Exec=sh -c "xset s off && xset -dpms && xset s noblank"
X-GNOME-Autostart-enabled=true
Terminal=false
EOF

xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-enabled -s false
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/blank-on-ac -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-ac-off -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-ac-sleep -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-sleep-mode-on-ac -s 0

xfconf-query -c xfce4-panel -p /panels/panel-1/autohide-behavior -s 2

if [ -f "$WALLPAPER_FILE" ]; then
	xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -n -t string -s "$WALLPAPER_FILE" || \
	xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -t string -s "$WALLPAPER_FILE"
	
	xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/image-style -n -t int -s 5 || \
	xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/image-style -t int -s 5
fi

echo "Setup complete. Please reboot now."
