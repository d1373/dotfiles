# Hyprland Config — Migration from AwesomeWM

This file describes the **exact** AwesomeWM setup to recreate in Hyprland. Read every section
before writing any file. Do not add features, effects, animations, or anything not described here.
Keep it minimal — the goal is a stable config that never needs to be touched.

---

## Hardware

- **CPU**: Intel i7-13700HX (13th gen, laptop)
- **GPU**: NVIDIA GeForce RTX 4060 Laptop GPU — hybrid graphics (Intel iGPU + NVIDIA dGPU)
- **Driver**: NVIDIA 590.48.01 (proprietary, open kernel module)
- **RAM**: 32 GB
- **OS**: Arch Linux, kernel 6.18.13-arch1-1
- **Display**: 1920×1200

---

## Critical: NVIDIA Hybrid Laptop Setup

This is the most important section. Get this wrong and nothing works.

### Kernel parameters (add to bootloader)
```
nvidia_drm.modeset=1
nvidia_drm.fbdev=1
```

### Environment variables (set in `hyprland.conf` via `env =`)
```ini
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = GBM_BACKEND,nvidia-drm
env = __NV_PRIME_RENDER_OFFLOAD,1
env = WLR_NO_HARDWARE_CURSORS,1
env = ELECTRON_OZONE_PLATFORM_HINT,auto
env = MOZ_ENABLE_WAYLAND,1
env = QT_QPA_PLATFORM,wayland
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
env = SDL_VIDEODRIVER,wayland
env = CLUTTER_BACKEND,wayland
env = XDG_SESSION_TYPE,wayland
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_DESKTOP,Hyprland
```

### NVIDIA kernel modules
Ensure these are in `/etc/mkinitcpio.conf` MODULES array:
```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```
Run `mkinitcpio -P` after changing.

---

## Packages to Install

Install all of these before starting configuration. Everything here replaces or is equivalent to
what was used in the AwesomeWM setup.

### Core Hyprland stack
```
hyprland
xdg-desktop-portal-hyprland
xdg-desktop-portal-gtk
xdg-utils
```

### Waybar (status bar — replaces AwesomeWM wibar)
```
waybar
```

### Wallpaper
```
hyprpaper
```
The wallpaper file is at `~/.config/wall.png` (same path as AwesomeWM used).

### Launcher (replaces rofi — uses same rofi scripts, wayland fork)
```
rofi-wayland       # AUR: provides rofi binary with wayland backend
```
All existing rofi scripts (~/.script/rofi-fzf.sh, ~/.script/powermenu.sh,
~/.script/web-search.sh, ~/.script/rofi-clip.sh) work unchanged after updating rofi-clip.sh.

### Clipboard (replaces greenclip)
```
wl-clipboard       # provides wl-copy, wl-paste
cliphist           # history daemon, replaces greenclip daemon
```
The script ~/.script/rofi-clip.sh needs to be updated to use cliphist:
```sh
cliphist list | rofi -dmenu | cliphist decode | wl-copy
```
Clear clipboard: `cliphist wipe` (replaces `greenclip clear`)

### Screenshot (replaces scrot)
```
grim
slurp
grimblast          # AUR — wrapper that makes grim+slurp work like scrot
```
Update ~/.script/scrot.sh to use: `grimblast copy area`
Update ~/.script/scrot-full.sh to use: `grimblast save screen`

### Color picker (replaces xcolor)
```
hyprpicker         # AUR
```
Update the keybind script: `hyprpicker | wl-copy`

### Image viewer for wallpaper picker (replaces sxiv)
```
swayimg            # or imv
```
Update keybind: `swayimg -t ~/Pictures/wallpaper`

### Idle and screen lock
```
swayidle
swaylock
```

### Display configuration (replaces xrandr)
```
wlr-randr          # one-off commands
```

### NVIDIA VA-API (for hardware video decoding)
```
libva-nvidia-driver    # AUR
egl-wayland
```

### Notification daemon
```
dunst
libnotify          # for notify-send
```

### Polkit agent
```
lxqt-policykit-agent   # works fine on Wayland
```

### Qt/GTK Wayland support
```
qt5-wayland
qt6-wayland
```

### Already works on Wayland (no replacement needed)
- `alacritty` — native Wayland
- `brave` — native Wayland
- `nm-applet` — works with `--indicator` flag
- `blueman` / `blueman-applet` — works on Wayland
- `emacs` (daemon mode) — works
- `yazi` — TUI, terminal-based
- `pcmanfm-qt` — works with qt6-wayland installed
- `wiremix` — TUI
- `nmtui-go` — TUI
- `wpctl` — pipewire/wireplumber CLI, unchanged
- `powerprofilesctl` — unchanged
- `localsend` (flatpak) — unchanged

---

## Colors and Theme

These are exact values from theme.lua. Use them everywhere: Waybar CSS, Hyprland borders.

| Name            | Value     | Usage                                         |
|-----------------|-----------|-----------------------------------------------|
| bg_normal       | #101011   | Window background, general background         |
| bar_bg          | #121212   | Bar background                                |
| bar_accent      | #6e94b2   | Icons, active border, focused tag, volume bar |
| bar_fg          | #ffffff   | All text on bar                               |
| border_focus    | #6e94b2   | Focused window border                         |
| border_normal   | #000000   | Unfocused window border                       |
| red             | #e05f5f   | Power icon, urgent                            |
| green           | #7fa563   | WiFi connected indicator                      |
| fg_normal       | #ebebeb   | General text                                  |

**Font**: `NotoSans Nerd Font` size 14 (used for both text and Nerd Font icons in the bar).
The bar uses Nerd Font glyphs — ensure this font is installed.

---

## Hyprland Core Config (hyprland.conf)

### Monitor
```ini
monitor = ,1920x1200@60,auto,1
```
Run `hyprctl monitors` after first boot to get the real connector name (e.g., eDP-1) and replace
the leading comma with it.

### General layout settings
```ini
general {
    gaps_in = 3
    gaps_out = 3
    border_size = 4
    col.active_border = rgba(6e94b2ff)
    col.inactive_border = rgba(000000ff)
    layout = master
}
```

### Master layout (equivalent to AwesomeWM tile layout)
```ini
master {
    new_status = slave
    mfact = 0.55
}
```
`new_status = slave` matches AwesomeWM behavior where new windows open in the stack, not master.

### Input
```ini
input {
    kb_layout = us
    follow_mouse = 1
    numlock_by_default = true
    mouse_refocus = false
}
```
`follow_mouse = 1` = sloppy focus (matches AwesomeWM signals.lua mouse::enter behavior).

### Cursor warp on focus
```ini
cursor {
    no_warps = false
}
```
Hyprland warps cursor to window center on focus change — matches signals.lua behavior.

### Misc
```ini
misc {
    disable_hyprland_logo = true
    disable_splash_rendering = true
    focus_on_activate = true
}
```

### Animations — DISABLE ALL
```ini
animations {
    enabled = false
}
```

### Decoration — minimal, no blur, no shadows, no opacity changes

Picom config was: no shadows, no fading, no blur, no inactive dimming, all opacity at 1.0,
`inactive-opacity-override = false` (apps control their own opacity — e.g. alacritty's own
background opacity setting is respected). Recreate this exactly:

```ini
decoration {
    # Rounded corners: absolutely minimum — just enough to soften edges, not decorative.
    # Keep at 4. Do not increase.
    rounding = 4

    # No opacity overrides — apps (e.g. alacritty) control their own opacity
    active_opacity = 1.0
    inactive_opacity = 1.0
    fullscreen_opacity = 1.0

    shadow {
        enabled = false
    }
    blur {
        enabled = false
    }
}
```

**Do not add `dim_inactive`, `dim_strength`, or any per-window opacity rules.** Alacritty manages
its own background opacity internally and picom's `inactive-opacity-override = false` preserved
that. `inactive_opacity = 1.0` in Hyprland does the same.

---

## Workspaces

AwesomeWM had 9 named workspaces with these Nerd Font icons and default layouts:

| # | Icon | Default Layout | Intended App      |
|---|------|----------------|-------------------|
| 1 |     | master-stack   | Terminal          |
| 2 |     | master-stack   | Terminal/Dev      |
| 3 |     | master-stack   | Terminal/Dev      |
| 4 |     | master-stack   | Terminal/Dev      |
| 5 |     | master-stack   | Terminal/Dev      |
| 6 | 󰭹   | monocle/max    | Chat/Messaging    |
| 7 |     | master-stack   | Files             |
| 8 |     | master-stack   | Files             |
| 9 | 󰓇   | master-stack   | Music/Media       |

Workspace 6 uses monocle (equivalent to AwesomeWM's max layout). Set it via workspace rule:
```ini
workspace = 6, layoutopt:orientation:monocle
```

These icons are displayed in the Waybar workspace widget.

---

## Keybindings

**Modkey** = SUPER (Super/Windows key)
**Altkey** = ALT

### Workspace navigation
```ini
bind = SUPER, left,  workspace, e-1
bind = SUPER, right, workspace, e+1
bind = SUPER, escape, workspace, previous

bind = SUPER, 1, workspace, 1
bind = SUPER, 2, workspace, 2
bind = SUPER, 3, workspace, 3
bind = SUPER, 4, workspace, 4
bind = SUPER, 5, workspace, 5
bind = SUPER, 6, workspace, 6
bind = SUPER, 7, workspace, 7
bind = SUPER, 8, workspace, 8
bind = SUPER, 9, workspace, 9

bind = SUPER SHIFT, 1, movetoworkspace, 1
bind = SUPER SHIFT, 2, movetoworkspace, 2
bind = SUPER SHIFT, 3, movetoworkspace, 3
bind = SUPER SHIFT, 4, movetoworkspace, 4
bind = SUPER SHIFT, 5, movetoworkspace, 5
bind = SUPER SHIFT, 6, movetoworkspace, 6
bind = SUPER SHIFT, 7, movetoworkspace, 7
bind = SUPER SHIFT, 8, movetoworkspace, 8
bind = SUPER SHIFT, 9, movetoworkspace, 9
```

### Window focus (vim-style)
```ini
bind = SUPER, h, movefocus, l
bind = SUPER, l, movefocus, r
bind = SUPER, j, movefocus, d
bind = SUPER, k, movefocus, u
bind = ALT, Tab,       cyclenext
bind = ALT SHIFT, Tab, cyclenext, prev
bind = SUPER, Tab,     focuscurrentorlast
```

### Window swapping
```ini
bind = SUPER SHIFT, h, swapwindow, l
bind = SUPER SHIFT, l, swapwindow, r
bind = SUPER SHIFT, j, swapwindow, d
bind = SUPER SHIFT, k, swapwindow, u
```

### Layout resizing (master width / client height)
```ini
bind = SUPER ALT, l, layoutmsg, mfact +0.03
bind = SUPER ALT, h, layoutmsg, mfact -0.03
bind = SUPER ALT SHIFT, h, layoutmsg, addmaster
bind = SUPER ALT SHIFT, l, layoutmsg, removemaster
bind = SUPER ALT, j, splitratio, -0.03
bind = SUPER ALT, k, splitratio, +0.03
```

### Layout cycling
```ini
bind = SUPER SHIFT, space, layoutmsg, cyclenext
```

### Window actions
```ini
bind = SUPER SHIFT, f,      fullscreen, 0
bind = ALT, q,              killactive
bind = SUPER, f,            togglefloating
bind = SUPER CTRL, return,  layoutmsg, swapwithmaster
bind = SUPER, t,            pin
bind = SUPER, m,            fullscreen, 1
```

### Program launchers
```ini
bind = SUPER, return,       exec, alacritty
bind = SUPER SHIFT, return, exec, brave
bind = ALT, space,          exec, rofi -show drun
bind = SUPER, space,        exec, /home/dhyey/.script/rofi-fzf.sh
bind = SUPER, w,            exec, /home/dhyey/.script/web-search.sh
bind = SUPER, e,            exec, alacritty -e yazi
bind = SUPER SHIFT, e,      exec, pcmanfm-qt
bind = SUPER SHIFT, b,      exec, helium-browser --profile-directory='Profile 1'
bind = ALT SHIFT, space,    exec, /home/dhyey/.script/powermenu.sh
```

### Clipboard
```ini
bind = SUPER, v,       exec, /home/dhyey/.script/rofi-clip.sh
bind = SUPER SHIFT, v, exec, cliphist wipe
```

### Screenshot
```ini
bind = SUPER, s,       exec, /home/dhyey/.script/scrot.sh
bind = SUPER SHIFT, p, exec, /home/dhyey/.script/scrot-full.sh
```

### Color picker (replaces xcolor)
```ini
bind = SUPER SHIFT, c, exec, hyprpicker | wl-copy
```

### Volume
```ini
bind  = SUPER, F1, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bind  = SUPER, F2, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind  = SUPER, F3, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bindel = , XF86AudioMute,        exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bindel = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindel = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind  = ALT SHIFT, v, exec, alacritty -e wiremix -v output
```

### Emoji, WiFi, Wallpaper, Misc
```ini
bind = SUPER, comma,       exec, rofi -show emoji -modi emoji
bind = SUPER SHIFT, w,     exec, alacritty -e nmtui-go
bind = SUPER SHIFT, s,     exec, swayimg -t ~/Pictures/wallpaper
bind = ALT CTRL, r,        exec, hyprctl reload
```

### Move/resize with mouse
```ini
bindm = SUPER, mouse:272, movewindow
bindm = SUPER, mouse:273, resizewindow
```

---

## Autostart (exec-once in hyprland.conf)

```ini
exec-once = hyprpaper
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store
exec-once = nm-applet --indicator
exec-once = blueman-applet
exec-once = lxqt-policykit-agent
exec-once = emacs --daemon
exec-once = brave --no-startup-window
exec-once = helium-browser --no-startup-window --password-store=basic
exec-once = sh -c 'pkill localsend; flatpak run org.localsend.localsend_app --hidden'
exec-once = dunst
exec-once = swayidle -w timeout 300 'swaylock -f' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock -f'
```

Do NOT start: picom, volumeicon, numlockx, xfce4-power-manager, xrandr, greenclip.
These are all replaced or handled natively.

### Hyprpaper config (~/.config/hypr/hyprpaper.conf)
```ini
preload = ~/.config/wall.png
wallpaper = ,~/.config/wall.png
```

---

## Window Rules

Recreates rules.lua and signals.lua behavior.

```ini
# Zathura: force tiled
windowrulev2 = tile, class:^(org.pwmt.zathura)$

# Floating windows
windowrulev2 = float, class:^(Arandr)$
windowrulev2 = float, class:^(Blueman-manager)$
windowrulev2 = float, class:^(Gpick)$
windowrulev2 = float, class:^(Kruler)$
windowrulev2 = float, class:^(veracrypt)$
windowrulev2 = float, title:^(Event Tester)$
windowrulev2 = float, class:^(copyq)$

# nmtui-go: float, centered, pinned on top (from signals.lua)
windowrulev2 = float,        title:^(nmtui-go)$
windowrulev2 = center,       title:^(nmtui-go)$
windowrulev2 = pin,          title:^(nmtui-go)$
windowrulev2 = size 800 500, title:^(nmtui-go)$

# Dialogs
windowrulev2 = float, xdg_popup:1
```

Hyprland has no titlebars by default — no rules needed for Ghostty or Zathura titlebar removal.

---

## Waybar — Status Bar

**Exact bar spec from AwesomeWM wibar.lua:**
- Position: top, height: 26px, background: #121212
- Font: NotoSans Nerd Font 14

**Layout:**
```
LEFT: [workspaces]  [focused window title]
CENTER: (empty)
RIGHT: [tray] | [battery] [power] [wifi] [vol-icon] [vol-%] | [clock]
```

### ~/.config/waybar/config.jsonc

```jsonc
{
    "layer": "top",
    "position": "top",
    "height": 26,
    "spacing": 0,
    "modules-left": ["hyprland/workspaces", "hyprland/window"],
    "modules-center": [],
    "modules-right": [
        "tray",
        "custom/sep",
        "battery",
        "custom/power",
        "network",
        "pulseaudio#icon",
        "pulseaudio#text",
        "custom/sep2",
        "clock"
    ],

    "hyprland/workspaces": {
        "format": "{icon}",
        "format-icons": {
            "1": "",
            "2": "",
            "3": "",
            "4": "",
            "5": "",
            "6": "󰭹",
            "7": "",
            "8": "",
            "9": "󰓇"
        },
        "on-click": "activate",
        "sort-by-number": true,
        "persistent-workspaces": {
            "1": [], "2": [], "3": [], "4": [], "5": [],
            "6": [], "7": [], "8": [], "9": []
        }
    },

    "hyprland/window": {
        "format": "{title}",
        "max-length": 80,
        "separate-outputs": true
    },

    "tray": {
        "spacing": 8,
        "icon-size": 18
    },

    "custom/sep": {
        "format": " | ",
        "tooltip": false
    },

    "custom/sep2": {
        "format": " | ",
        "tooltip": false
    },

    "battery": {
        "format": "󰁹",
        "format-charging": "󰂄",
        "format-plugged": "󰚥",
        "tooltip-format": "{capacity}% — {timeTo}",
        "on-click": "sh -c 'mode=$(powerprofilesctl get 2>/dev/null); case $mode in performance) next=balanced;; balanced) next=power-saver;; power-saver) next=performance;; *) next=balanced;; esac; powerprofilesctl set $next'"
    },

    "custom/power": {
        "format": "󰐥",
        "tooltip": false,
        "on-click": "/home/dhyey/.script/powermenu.sh"
    },

    "network": {
        "format-wifi": "󰖩",
        "format-disconnected": "󰖪",
        "format-ethernet": "󰈀",
        "tooltip-format-wifi": "{essid} ({signalStrength}%)",
        "tooltip-format-disconnected": "Disconnected",
        "on-click": "alacritty -e nmtui-go"
    },

    "pulseaudio#icon": {
        "format": "󰕾",
        "tooltip": false,
        "on-click": "alacritty -e wiremix -v output",
        "on-scroll-up": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+",
        "on-scroll-down": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    },

    "pulseaudio#text": {
        "format": "{volume}%",
        "tooltip": false,
        "on-scroll-up": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+",
        "on-scroll-down": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    },

    "clock": {
        "format": "{:%a %d - %H:%M}",
        "tooltip": false
    }
}
```

Note on volume bar: The AwesomeWM bar had a custom Cairo-drawn 70px line with a dot at the volume
position. This cannot be replicated in Waybar without a custom module. Use the icon + percentage
text instead. This is the only deliberate visual deviation from the original bar.

### ~/.config/waybar/style.css

```css
* {
    font-family: "NotoSans Nerd Font";
    font-size: 14px;
    border: none;
    border-radius: 0;
    padding: 0;
    margin: 0;
    min-height: 0;
}

window#waybar {
    background-color: #121212;
    color: #ffffff;
}

#workspaces {
    background: transparent;
    padding: 0 4px;
}

#workspaces button {
    background: transparent;
    color: #ffffff;
    padding: 0 8px;
    min-width: 0;
    border-bottom: 2px solid transparent;
}

#workspaces button.active,
#workspaces button.focused {
    color: #6e94b2;
    border-bottom: 2px solid #6e94b2;
}

#workspaces button.urgent {
    color: #e05f5f;
}

#window {
    color: #ffffff;
    padding: 0 12px;
}

#tray,
#battery,
#network,
#custom-power,
#custom-sep,
#custom-sep2,
#pulseaudio.icon,
#pulseaudio.text,
#clock {
    color: #ffffff;
    padding: 0 5px;
}

#battery,
#pulseaudio.icon {
    color: #6e94b2;
}

#network.wifi {
    color: #7fa563;
}

#network.disconnected {
    color: #ffffff;
}

#custom-power {
    color: #e05f5f;
}

#custom-sep,
#custom-sep2 {
    color: #ffffff;
    padding: 0 2px;
}

#tray {
    padding: 0 4px;
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background-color: #e05f5f;
}
```

---

## Behaviors to Preserve

These come from signals.lua and appearance.lua.

- **Sloppy focus**: `follow_mouse = 1` in input section handles this.
- **Cursor warps to focused window center**: `no_warps = false` in cursor section handles this.
- **New windows open as slave (stack, not master)**: `new_status = slave` in master layout.
- **Focused border changes color**: `col.active_border` / `col.inactive_border` in general section.
- **Gap size**: 3px gaps (gaps_in and gaps_out both = 3).

---

## Scripts That Need Updating

### ~/.script/scrot.sh
```sh
#!/bin/sh
grimblast copy area
```

### ~/.script/scrot-full.sh
```sh
#!/bin/sh
grimblast save screen ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png
```

### ~/.script/rofi-clip.sh
```sh
#!/bin/sh
cliphist list | rofi -dmenu | cliphist decode | wl-copy
```

Other scripts (powermenu.sh, web-search.sh, rofi-fzf.sh) use rofi and work unchanged with
rofi-wayland. Verify each one calls `rofi` directly — if so, no changes needed.

---

## File Structure to Create

```
~/.config/hypr/
├── hyprland.conf
└── hyprpaper.conf

~/.config/waybar/
├── config.jsonc
└── style.css
```

Keep everything in as few files as possible. No includes, no split configs.

---

## What to NOT Recreate

- **Layout indicator widget**: AwesomeWM-specific. Omit entirely.
- **Awesome launcher icon**: Skip.
- **Prompt box in bar** (Super+r run prompt): Use rofi. Alt+Space already handles launching.
- **Lua eval** (Super+x): No equivalent. Skip.
- **Titlebar buttons**: Hyprland has no titlebars by default.
- **Animations**: None. Do not add any.
- **Blur**: None.
- **Shadows**: None.
- **Rounding**: Absolutely minimum — `rounding = 4`. Just enough to soften edges, same philosophy as the 3px gaps. Do not increase.

---

## Verification Checklist

After building the config, verify each item:

- [ ] Hyprland starts without errors (check ~/.local/share/hyprland/hyprland.log)
- [ ] No screen tearing (NVIDIA modesetting active)
- [ ] All 9 workspaces visible in bar with correct icons
- [ ] Super+1 through Super+9 switches workspaces
- [ ] Super+Return opens alacritty
- [ ] Alt+Space opens rofi
- [ ] Super+Space opens rofi-fzf
- [ ] Super+s captures a region screenshot
- [ ] Super+v opens clipboard history
- [ ] Volume keys and scroll on volume widget work
- [ ] WiFi icon turns green when connected, white when disconnected
- [ ] Battery icon click cycles power profiles (power-saver -> balanced -> performance)
- [ ] Power icon click opens powermenu
- [ ] WiFi icon click opens nmtui-go (floating, centered)
- [ ] Alt+q closes active window
- [ ] Super+Shift+c captures color to clipboard
- [ ] Focus follows mouse
- [ ] Emacs daemon started (emacsclient -e t returns t)
- [ ] System tray shows nm-applet and blueman icons
- [ ] Wallpaper loads from ~/.config/wall.png
- [ ] Clipboard history persists (wl-paste watchers running)
