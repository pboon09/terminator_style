# terminator_style

Starship + ble.sh setup for bash, scoped to Terminator only. GNOME Terminal and other terminals stay at default bash prompt.

- **Live prompt:** Starship `gruvbox-rainbow` preset (powerline segments, git info, time)
- **Past prompts (transient):** collapse to `user@host:path$` — green if last command succeeded, red if it failed
- **Shell:** bash (native, no zsh needed)
- **ROS 2 compatible:** `~/.bashrc` sources like `setup.bash` work unchanged

---

## Table of Contents

1. [Requirements](#requirements)
2. [What it installs](#what-it-installs)
3. [Install](#install)
4. [Terminator profile settings](#terminator-profile-settings)
5. [Uninstall](#uninstall)
6. [Notes](#notes)
7. [Credits](#credits)

---

## Requirements

- Ubuntu 22.04 LTS
- Default shell is bash (`echo $SHELL` → `/bin/bash`)
- sudo access (for apt packages and installing Starship to `/usr/local/bin`)

---

## What it installs

- **apt:** terminator, curl, wget, git, make, gawk, build-essential, unzip, fontconfig
- **Starship** → `/usr/local/bin/starship`
- **ble.sh** → `~/.local/share/blesh/`
- **JetBrainsMono Nerd Font (Propo variants)** → `~/.local/share/fonts/`
- **~/.config/starship.toml** → gruvbox-rainbow preset
- **~/.bashrc** → appends a Terminator-gated block (`$TERMINATOR_UUID` check) that sources ble.sh, initializes Starship, and configures transient prompt

---

## Install

```bash
git clone https://github.com/pboon09/terminator_style.git
cd terminator_style
chmod +x install.sh
./install.sh
```

Then follow the instructions printed at the end to set the Terminator profile font (see next section).

---

## Terminator profile settings

The installer does not modify `~/.config/terminator/config` (to avoid clobbering existing profiles). Set these manually:

**Preferences → Profiles → `default`:**

- **General tab**
  - Uncheck "Use the system fixed width font"
  - Font: `JetBrainsMono Nerd Font Propo`, size 12
- **Colors tab** (example gruvbox-dark — optional)
  - Foreground: `#ebdbb2`
  - Background: `#282828`
  - Cursor: `#aaaaaa`
- **Scrolling tab** (optional)
  - Check "Infinite Scrollback"

Reference `~/.config/terminator/config` equivalent:

```ini
[profiles]
  [[default]]
    background_color = "#282828"
    cursor_color = "#aaaaaa"
    font = JetBrainsMono Nerd Font Propo 12
    foreground_color = "#ebdbb2"
    scrollback_infinite = True
    use_system_font = False
```

Close and reopen Terminator.

---

## Uninstall

```bash
cd terminator_style
chmod +x uninstall.sh
./uninstall.sh
```

Removes Starship binary + config, ble.sh, JetBrainsMono Propo fonts, and the `terminator_style` block in `~/.bashrc`. Leaves apt packages and Terminator profile settings alone (reset manually if desired).

---

## Notes

- **Why Terminator-only?** The `~/.bashrc` block checks `$TERMINATOR_UUID`, which Terminator sets automatically. GNOME Terminal (and most others) don't set this variable, so they fall through to default bash.
- **Transient prompt color logic:** `$?` is evaluated at each prompt redraw. Green (ANSI 32) on exit 0, red (ANSI 31) otherwise. Includes `ble: exit 127` for command-not-found, Ctrl-C (130), etc.
- **Disabling transient temporarily:** run `bleopt prompt_ps1_transient=` in the current session.
- **Starship config:** edit `~/.config/starship.toml` freely — no reload needed, takes effect on next prompt render.

---

## Credits

- [Starship](https://starship.rs/)
- [ble.sh](https://github.com/akinomyoga/ble.sh)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [Terminator](https://github.com/gnome-terminator/terminator)