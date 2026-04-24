#!/usr/bin/env bash
set -euo pipefail

BASHRC="$HOME/.bashrc"
STARSHIP_CONFIG="$HOME/.config/starship.toml"
BLESH_DIR="$HOME/.local/share/blesh"
FONT_DIR="$HOME/.local/share/fonts"
MARK_BEGIN="# >>> terminator_style begin >>>"
MARK_END="# <<< terminator_style end <<<"

echo "[1/4] Removing terminator_style block from ~/.bashrc"
if grep -q "$MARK_BEGIN" "$BASHRC" 2>/dev/null; then
  sed -i "/$MARK_BEGIN/,/$MARK_END/d" "$BASHRC"
  echo "Removed"
else
  echo "Block not found, skipping"
fi

echo "[2/4] Removing Starship binary and config"
sudo rm -f /usr/local/bin/starship
rm -f "$STARSHIP_CONFIG"

echo "[3/4] Removing ble.sh"
rm -rf "$BLESH_DIR"
rm -rf "$HOME/.local/share/blesh" "$HOME/.cache/blesh"

echo "[4/4] Removing JetBrainsMono Propo fonts"
rm -f "$FONT_DIR"/JetBrainsMono*Propo*.ttf
fc-cache -fv >/dev/null

cat << 'DONE'

Uninstall complete.

Not removed (manual if wanted):
  - apt packages: terminator, curl, wget, git, make, gawk, build-essential, unzip, fontconfig
  - Terminator profile font/colors (~/.config/terminator/config)

Restart Terminator to see default bash prompt.
DONE