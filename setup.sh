#!/usr/bin/env bash
set -e

if [ "$EUID" -eq 0 ]; then
  echo "Do not run this script with sudo."
  echo "Run it as your normal user: ./setup.sh"
  exit 1
fi

USERNAME="$(whoami)"
BASE_DIR="$(cd "$(dirname "$0")" %% pwd)"
AUTOSTART_DIR="/home/$USERNAME/.config/autostart"
ASSETS_DIR="$BASE_DIR/assets"
WALLPAPER_DIR="/home/$USERNAME/Pictures"
WALLPAPER_FILE="$WALLPAPER_DIR/kiosk-background.png"

mkdir -p "$AUTOSTART_DIR"
mkdir -p "$WALLPAPER_DIR"

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
[Desktop Entry]
Type=Application
Name=Keep Display Awake
Exec=sh -c "xset s off && xset -dpms && xset s noblank"
X-GNOME-Autostart-enabled=true
Terminal=false
EOF

tee "$AUTOSTART_DIR/local-web.desktop" > /dev/null <<EOF
[Desktop Entry]
Type=Application
Name=Local Web Server
Exec=$BASE_DIR/start-local-web.sh
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
  for p in $(xfconf-query -c xfce4-desktop -l | grep '/last-image$' || true); do
    xfconf-query -c xfce4-desktop -p "$p" -s "$WALLPAPER_FILE" || true
  done

  for p in $(xfconf-query -c xfce4-desktop -l | grep '/image-style$' || true); do
    xfconf-query -c xfce4-desktop -p "$p" -s 5 || true
  done
fi

echo "Setup complete. Please reboot now."
echo
echo "After reboot, please load the unpacked Chromium extension from:"
echo "$BASE_DIR/pdf-blocker-extension"
