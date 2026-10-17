# dotfiles

Personal config for Omarchy machines.

```bash
git clone <this repo> ~/dotfiles
~/dotfiles/install.sh
```

Files are symlinked into place, so editing them in `~/.config` or `~/.local/bin` edits the repo.

## brave

Brave as the default browser, styled to fit Omarchy:

- `brave-flags.conf`: Wayland, GNOME keyring, and Omarchy's bundled extensions (same as Omarchy's `chromium-flags.conf`)
- `ntp-prefs.py`: vertical tabs, a stripped-down toolbar, and a minimal new tab page. Writes to the Brave profile directly, so Brave must be closed
- `bin/brave-frost-update` + `systemd/brave-frost-update.*`: rebuilds the new-tab background from the current Omarchy wallpaper (blurred, light veil) whenever the theme or wallpaper changes
- `bin/brave-testbed`: a separate Brave with remote debugging and a throwaway copy of the customized profile, for testing

Bookmarks, passwords, extensions and history aren't stored here. Use Brave Sync for those.

## herdr

Terminal multiplexer config (`herdr/config.toml`), mirroring Omarchy's tmux setup: `ctrl+space` prefix, tmux sessions/windows/panes as herdr workspaces/tabs/panes.

- `alt+left/right`, `alt+j/l`, `alt+s/f`: previous/next tab
- `alt+up/down`, `alt+i/k`, `alt+e/d`: previous/next workspace
