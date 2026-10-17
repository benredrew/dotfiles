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

- `alt+left/right`, `alt+j/l`, `alt+a/d`: previous/next tab
- `alt+up/down`, `alt+i/k`, `alt+w/s`: previous/next workspace

## audio

A JBL Charge 5 (Bluetooth) and a projector's built-in speaker (GPU HDMI port 3) playing together as one output, **JBL + Projector** (`combined_speakers`). Specific to this machine's hardware.

- `pipewire/50-combined-speakers.conf`: the combined output. Each speaker joins when it appears and drops out when it goes away
- `pipewire/45-projector-delay.conf`: delays the projector 165 ms to line up with the JBL's Bluetooth (SBC) latency. Measured with a mic and noise-burst cross-correlation; retune `"Delay (s)"` if the speakers move
- `pipewire/40-low-latency.conf`: 256-sample buffers (~5 ms)
- `wireplumber/50-projector-hdmi.conf`: routes the GPU's HDMI audio to the projector's port
- `bin/jbl-volume-relay` + `systemd/jbl-volume-relay.service`: the JBL's own +/- buttons move the master volume (with the Omarchy OSD) and the JBL snaps back to its fixed level, so the balance never drifts. Set that level with the JBL slider in the mixer (Super+Alt+A): changes made while the mixer is focused are taken as the new level and remembered
- `hypr/volume-mixer.lua`: `Super+Alt+A` toggles pavucontrol as a floating 900×1000 window (no scrolling)
- `pavucontrol-theme/gtk.css`: loaded only by that keybind; the default device's checkmark glows in the Omarchy accent color, the others fade to grey

Restarting audio drops Bluetooth, so reconnect the speaker after `./install.sh audio`. Discord and other voice apps don't reconnect to a restarted audio server either: restart them too.
