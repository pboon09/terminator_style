# terminator_style

Starship + ble.sh setup for bash, scoped to Terminator only. GNOME Terminal and other terminals stay at default bash prompt.

- **Live prompt:** Starship `gruvbox-rainbow` preset (powerline segments, git info, time)
- **Past prompts (transient):** collapse to `user@host:path$` — green if last command succeeded, red if it failed
- **Autosuggestions + syntax highlighting:** ble.sh
- **Shell:** bash (native, no zsh needed)
- **ROS 2 compatible:** `~/.bashrc` sources like `setup.bash` work unchanged

---

## Table of Contents

1. [Requirements](#requirements)
2. [What it installs](#what-it-installs)
3. [Install](#install)
4. [Terminator profile settings](#terminator-profile-settings)
5. [Keyboard shortcuts](#keyboard-shortcuts)
6. [Uninstall](#uninstall)
7. [Notes](#notes)
8. [Credits](#credits)

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
- **~/.config/starship.toml** → gruvbox-rainbow preset (only if missing — existing config is preserved)
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

## Keyboard shortcuts

These shortcuts are active inside any Terminator window after install. Autosuggestion / completion behavior comes from ble.sh; standard readline bindings still work.

### Autosuggestions (the grey/highlighted ghost text after the cursor)

| Action | Key |
|---|---|
| Accept full suggestion | `Right Arrow` (at end of line), `End`, `Ctrl+F` |
| Accept next word only | `Alt+F` |
| Reject suggestion | Keep typing, or `Ctrl+G` |

`Tab` does **not** accept autosuggestions — it triggers tab completion of what you've typed. This trips up zsh users coming from `zsh-autosuggestions`.

### Tab completion

| Action | Key |
|---|---|
| Trigger / cycle forward through candidates | `Tab` |
| Cycle backward | `Shift+Tab` |
| Cancel completion menu | `Ctrl+G` or `Esc` |

### History

| Action | Key |
|---|---|
| Previous / next command | `Up` / `Down` |
| Reverse incremental search | `Ctrl+R` (repeat to step further back) |
| Forward incremental search | `Ctrl+S` (requires `stty -ixon` — set by ble.sh) |
| Search history by current prefix | `Page Up` / `Page Down` |
| Cancel search | `Ctrl+G` |

### Line editing (readline / ble.sh)

| Action | Key |
|---|---|
| Beginning / end of line | `Ctrl+A` / `Ctrl+E` |
| Move by word backward / forward | `Alt+B` / `Alt+F` |
| Delete word backward | `Ctrl+W` |
| Delete to start of line | `Ctrl+U` |
| Delete to end of line | `Ctrl+K` |
| Yank last killed text | `Ctrl+Y` |
| Clear screen | `Ctrl+L` |
| Cancel current line | `Ctrl+C` |
| Send EOF (exit shell) | `Ctrl+D` (on empty line) |

### Terminator window management

| Action | Key |
|---|---|
| Split horizontally (top/bottom) | `Ctrl+Shift+O` |
| Split vertically (left/right) | `Ctrl+Shift+E` |
| Close current pane | `Ctrl+Shift+W` |
| New tab | `Ctrl+Shift+T` |
| Close tab | `Ctrl+Shift+Q` |
| Move focus between panes | `Ctrl+Shift+Arrow` |
| Cycle through panes | `Ctrl+Tab` |
| Maximize / restore pane | `Ctrl+Shift+X` |
| Find in scrollback | `Ctrl+Shift+F` |
| Copy / paste | `Ctrl+Shift+C` / `Ctrl+Shift+V` |
| Increase / decrease font size | `Ctrl+Plus` / `Ctrl+Minus` |
| Reset font size | `Ctrl+0` |

### Want Tab to accept autosuggestions like zsh?

Add this line to the `terminator_style` block in `~/.bashrc` after `ble-attach`:

```bash
ble-bind -m auto_complete -f C-i auto_complete/insert
```

Or disable autosuggestions entirely:

```bash
bleopt complete_auto_complete=
```

---

## Uninstall

```bash
cd terminator_style
chmod +x uninstall.sh
./uninstall.sh
```

Removes Starship binary + config, ble.sh, JetBrainsMono Propo fonts, and the `terminator_style` block in `~/.bashrc`. Leaves apt packages and Terminator profile settings alone (reset manually if desired). Open a new terminal afterward — running shells keep their current state until restarted.

---

## Notes

- **Why Terminator-only?** The `~/.bashrc` block checks `$TERMINATOR_UUID`, which Terminator sets automatically. GNOME Terminal (and most others) don't set this variable, so they fall through to default bash.
- **Transient prompt color logic:** `$?` is evaluated at each prompt redraw. Green (ANSI 32) on exit 0, red (ANSI 31) otherwise. Includes `ble: exit 127` for command-not-found, Ctrl-C (130), etc.
- **Disabling transient temporarily:** run `bleopt prompt_ps1_transient=` in the current session.
- **Starship config:** edit `~/.config/starship.toml` freely — no reload needed, takes effect on next prompt render. Re-running `install.sh` will not overwrite your edits.
- **ble.sh runtime config:** put per-user tweaks in `~/.blerc` (loaded automatically by ble.sh) so they survive reinstalls.

---

## Credits

- [Starship](https://starship.rs/)
- [ble.sh](https://github.com/akinomyoga/ble.sh)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [Terminator](https://github.com/gnome-terminator/terminator)