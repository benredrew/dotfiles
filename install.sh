#!/bin/bash
# Set up these dotfiles on an Omarchy machine. Safe to rerun.
#   ./install.sh          everything
#   ./install.sh brave    just one module

set -euo pipefail

DOTFILES=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Symlink $1 (in the repo) to $2, backing up a real file that is in the way.
link() {
  local src="$DOTFILES/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -e $dest && ! -L $dest ]]; then
    mv "$dest" "$dest.bak-$(date +%s)"
    echo "backed up $dest"
  fi
  ln -sfn "$src" "$dest"
  echo "linked $dest"
}

install_brave() {
  echo "== brave"
  omarchy-pkg-aur-add brave-bin

  link brave/brave-flags.conf "$HOME/.config/brave-flags.conf"
  link brave/bin/brave-frost-update "$HOME/.local/bin/brave-frost-update"
  link brave/bin/brave-testbed "$HOME/.local/bin/brave-testbed"
  link brave/systemd/brave-frost-update.path "$HOME/.config/systemd/user/brave-frost-update.path"
  link brave/systemd/brave-frost-update.service "$HOME/.config/systemd/user/brave-frost-update.service"

  # Omarchy exports BROWSER in interactive shells, which makes xdg-settings refuse
  env -u BROWSER xdg-settings set default-web-browser brave-browser.desktop
  # Writes the theme color policy into /etc/brave (asks for sudo)
  omarchy-theme-set-browser || echo "theme color policy not applied; run omarchy-theme-set-browser later"

  systemctl --user daemon-reload
  systemctl --user enable --now brave-frost-update.path

  local profile="$HOME/.config/BraveSoftware/Brave-Browser"
  if [[ ! -f $profile/Default/Preferences ]]; then
    echo "Brave has no profile yet: open Brave once, close it, then rerun ./install.sh brave"
    return
  fi
  if pgrep -x brave >/dev/null; then
    echo "Brave is running: close it, then rerun ./install.sh brave to apply new-tab and toolbar settings"
    return
  fi
  cp "$profile/Default/Preferences" "$profile/Default/Preferences.bak.$(date +%s)"
  mkdir -p "$profile/Default/sanitized_background_images"
  brave-frost-update --now
  python3 -I "$DOTFILES/brave/ntp-prefs.py" "$profile" omarchy-frost.png
}

install_audio() {
  echo "== audio"
  omarchy-pkg-add pavucontrol

  # Speakers: JBL Charge 5 (Bluetooth) + projector (GPU HDMI 3) as one output,
  # with the projector delayed to match Bluetooth latency.
  local f
  for f in "$DOTFILES"/audio/pipewire/*.conf; do
    link "audio/pipewire/$(basename "$f")" "$HOME/.config/pipewire/pipewire.conf.d/$(basename "$f")"
  done
  link audio/wireplumber/50-projector-hdmi.conf "$HOME/.config/wireplumber/wireplumber.conf.d/50-projector-hdmi.conf"

  # Mixer: Super+Alt+A, with a pavucontrol-only theme that highlights the default device
  link audio/pavucontrol-theme/gtk.css "$HOME/.local/share/themes/Pavucontrol-Highlight/gtk-4.0/gtk.css"
  link audio/hypr/volume-mixer.lua "$HOME/.config/hypr/volume-mixer.lua"
  local hyprland="$HOME/.config/hypr/hyprland.lua"
  if ! grep -q 'require("hypr.volume-mixer")' "$hyprland"; then
    printf '\n-- Volume mixer keybind + window rule (from ~/dotfiles audio module).\nrequire("hypr.volume-mixer")\n' >>"$hyprland"
    echo "added volume-mixer to $hyprland"
  fi
  hyprctl reload >/dev/null || true

  # Restarting audio drops Bluetooth; reconnect the speaker afterwards if needed
  systemctl --user restart pipewire pipewire-pulse wireplumber
  sleep 3
  pactl set-default-sink combined_speakers
}

install_herdr() {
  echo "== herdr"
  omarchy-pkg-add herdr

  # Only the config: the rest of ~/.config/herdr is sockets, logs and session state
  link herdr/config.toml "$HOME/.config/herdr/config.toml"
}

modules=("$@")
(( ${#modules[@]} )) || modules=(brave herdr audio)
for module in "${modules[@]}"; do
  "install_$module"
done
