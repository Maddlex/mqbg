#!/bin/bash

set -e

echo "Installing dependencies..."

if command -v apt >/dev/null; then
  sudo apt update
  sudo apt install -y libinput-tools libinput-dev quickshell
elif command -v dnf >/dev/null; then
  sudo dnf copr enable errornointernet/quickshell
  sudo dnf install -y libinput libinput-devel quickshell
elif command -v pacman >/dev/null; then
  sudo pacman -S --noconfirm --needed libinput libinput-tools quickshell
else
  echo "Sorry, but looks like we can't install libinput dependency on your distro :("
  echo "You can try to build it manually or use another tool to fetch your cursor coordinates and rewrite this whole package, I dunno..."
  exit 1
fi

sudo tee /usr/bin/mqbg >/dev/null <<'EOF'

#!/bin/bash

if [ ! -x "$HOME/mqbg/getMouseLocation.sh" ]; then
  chmod +x "$HOME/mqbg/getMouseLocation.sh"
fi

if [ $# -eq 0 ]; then
  command -v qs >/dev/null || {
    echo "qs(quickshell) not found... You just installed it, didn't you..?"
    exit 1
  }
  pkill qs
  qs -p "$HOME/mqbg/mqbg.qml" > /dev/null 2>&1 & disown
fi

case "$1" in
  --set)
    if [ $# -ne 3 ]; then
      echo "Usage: mqbg --set <bg> <fg>"
      exit 1
    fi
    BG="$2"
    FG="$3"
    cp "$2" "$HOME/mqbg/BGForSprite.png" || exit 1
    cp "$3" "$HOME/mqbg/Sprite.png" || exit 1
    ;;
  --move)
    if [ $# -ne 5 ]; then
      echo "Usage: mqbg --move <BG horizontal> <BG vertical> <FG horizontal> <FG vertical>"
      exit 1
    fi
    BGh="$2"
    BGv="$3"
    FGh="$4"
    FGv="$5"
    echo "BGh=$BGh BGv=$BGv FGh=$FGh FGv=$FGv" > "$HOME/mqbg/config.txt"
    ;;
  --help)
    echo "mqbg - starts mqbg with current configuration"
    echo "mqbg --set <bg> <fg> - sets background and forground images"
    echo "mqbg --move <BG horizontal> <BG vertical> <FG horizontal> <FG vertical> - sets speed and offset of background and foregroung moving"
esac

EOF

sudo chmod +x /usr/bin/mqbg

if [ -n "$SUDO_USER" ]; then
    TARGET_USER="$SUDO_USER"
else
    TARGET_USER="$USER"
fi

sudo usermod -aG input "$TARGET_USER"
exec sg input "$SHELL"

echo "mqbg is now installed! Reboot your PC for changes to take effect and define wallpaper background and foreground by typing mqbg --set /path/to/background /path/to/foreground"
echo "(remember that foreground should have transparent background)"
