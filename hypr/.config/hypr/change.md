# Changes needed before switching to Hyprland

## 1. Scripts — create Wayland versions in ~/.script/

Do NOT modify the originals. Create new files with `_wl` suffix.

---

### ~/.script/scrot_wl.sh
Replaces: `scrot.sh` (uses maim — X11 only)
```sh
#!/bin/sh
grimblast copy area
```

---

### ~/.script/scrot-full_wl.sh
Replaces: `scrot-full.sh` (uses maim — X11 only)
```sh
#!/bin/sh
grimblast save screen ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png
```

---

### ~/.script/rofi-clip_wl.sh
Replaces: `rofi-clip.sh` (uses greenclip + xclip — X11 only)
```sh
#!/bin/sh
cliphist list | rofi -dmenu | cliphist decode | wl-copy
```

---

### ~/.script/setwallpaper_wl.sh
Replaces: `setwallpaper.sh` (uses feh + betterlockscreen — X11 only)

Uses hyprpaper IPC to set wallpaper live. Copies the image to `~/.config/wall.png`
so swaylock can always find it at a fixed path.

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $(basename "$0") /path/to/image"
  exit 1
fi

img="$1"
img="${img/#\~/$HOME}"

if [[ ! -f "$img" ]]; then
  echo "Error: file not found: $img"
  exit 1
fi

# Canonical path used by hyprpaper.conf and swaylock
cp "$img" "$HOME/.config/wall.png"

# Tell hyprpaper to load and display the new wallpaper
hyprctl hyprpaper preload "$HOME/.config/wall.png"
hyprctl hyprpaper wallpaper "eDP-1,$HOME/.config/wall.png"
# Unload anything no longer displayed (frees old image memory)
hyprctl hyprpaper unload all

echo "Wallpaper set: $img"
```

---

After creating the files, make them executable:
```sh
chmod +x ~/.script/scrot_wl.sh ~/.script/scrot-full_wl.sh ~/.script/rofi-clip_wl.sh ~/.script/setwallpaper_wl.sh
```

---

## 2. System setup (one-time, before first boot into Hyprland)

### Bootloader kernel parameters
Add these to your bootloader config (e.g. `/boot/loader/entries/*.conf` or GRUB):
```
nvidia_drm.modeset=1
nvidia_drm.fbdev=1
```

### mkinitcpio NVIDIA modules
In `/etc/mkinitcpio.conf`, ensure the MODULES line includes:
```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```
Then rebuild:
```sh
sudo mkinitcpio -P
```

---

## 4. Stow / symlink

If using stow from ~/dotfiles:
```sh
cd ~/dotfiles
stow hypr
```
This symlinks `~/.config/hypr/` to the dotfiles package.

---

## Notes on scripts that need NO changes

- `powermenu.sh` — uses rofi, works unchanged with rofi-wayland
- `web-search.sh` — uses rofi, works unchanged
- `rofi-fzf.sh`  — uses rofi, works unchanged
- All wpctl commands — pipewire/wireplumber, unchanged
