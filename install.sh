#!/usr/bin/env bash
set -euo pipefail

BASHRC="$HOME/.bashrc"
STARSHIP_CONFIG="$HOME/.config/starship.toml"
BLESH_DIR="$HOME/.local/share/blesh"
FONT_DIR="$HOME/.local/share/fonts"
MARK_BEGIN="# >>> terminator_style begin >>>"
MARK_END="# <<< terminator_style end <<<"

echo "[1/5] Installing dependencies"
sudo apt update
sudo apt install -y terminator curl wget git make gawk build-essential unzip fontconfig

echo "[2/5] Installing Starship"
if ! command -v starship >/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi
starship --version

echo "[3/5] Installing ble.sh"
if [ ! -f "$BLESH_DIR/ble.sh" ]; then
  TMP=$(mktemp -d)
  git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git "$TMP/ble.sh"
  make -C "$TMP/ble.sh" install PREFIX="$HOME/.local"
  rm -rf "$TMP"
fi
test -f "$BLESH_DIR/ble.sh" && echo "ble.sh OK"

echo "[4/5] Installing JetBrainsMono Nerd Font (Propo variants)"
mkdir -p "$FONT_DIR"
if ! fc-list | grep -qi "JetBrainsMono.*Propo"; then
  TMP=$(mktemp -d)
  wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -O "$TMP/jbm.zip"
  unzip -qo "$TMP/jbm.zip" -d "$TMP/jbm"
  cp "$TMP/jbm"/*Propo*.ttf "$FONT_DIR"/ 2>/dev/null || true
  fc-cache -fv >/dev/null
  rm -rf "$TMP"
fi
fc-list | grep -ci "JetBrainsMono.*Propo" | xargs -I{} echo "JetBrainsMono Propo variants installed: {}"

echo "[5/5] Configuring Starship + ble.sh in ~/.bashrc (Terminator only)"
mkdir -p "$(dirname "$STARSHIP_CONFIG")"
starship preset gruvbox-rainbow -o "$STARSHIP_CONFIG"

if ! grep -q "$MARK_BEGIN" "$BASHRC" 2>/dev/null; then
  cat >> "$BASHRC" << EOF

$MARK_BEGIN
if [ -n "\$TERMINATOR_UUID" ]; then
  [[ \$- == *i* ]] && source -- "\$HOME/.local/share/blesh/ble.sh" --noattach
  eval "\$(starship init bash)"
  [[ \${BLE_VERSION-} ]] && ble-attach
  bleopt prompt_ps1_transient=always
  bleopt prompt_ps1_final='\\[\\e[\$((! \$? ? 32 : 31))m\\]\\u@\\h:\\w\\\$\\[\\e[0m\\] '
fi
$MARK_END
EOF
  echo "Added block to $BASHRC"
else
  echo "Block already present in $BASHRC, skipping"
fi

cat << 'DONE'

Install complete.

Next steps:
  1. Open Terminator (not GNOME Terminal).
  2. Right-click -> Preferences -> Profiles -> default -> General
     - Uncheck "Use the system fixed width font"
     - Pick: JetBrainsMono Nerd Font Propo, size 12
  3. Profiles -> Colors tab (optional gruvbox-dark example):
     - Foreground: #ebdbb2
     - Background: #282828
     - Cursor:     #aaaaaa
  4. Profiles -> Scrolling -> check "Infinite Scrollback" (optional)
  5. Close and reopen Terminator.

GNOME Terminal and other terminals remain untouched (default bash prompt).
DONE