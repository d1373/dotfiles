# Dotfiles
Personal configuration files managed with GNU Stow.

## What is configured here
- **awesome/**: AwesomeWM configuration
- **ghostty/**: Ghostty terminal configuration
- **git/**: Git configuration
- **greenclip/**: Greenclip clipboard manager configuration
- **rofi/**: Rofi launcher and theme configuration
- **sesh/**: Sesh session manager configuration
- **sxiv/**: Sxiv image viewer configuration
- **zathura/**: Zathura PDF/document viewer configuration
- **zsh/**: Zsh shell configuration

## Using GNU Stow
From the repository root:

```bash
# Install all configurations
stow */

# Or install one at a time
stow awesome
stow ghostty
stow git
stow greenclip
stow rofi
stow sesh
stow sxiv
stow zathura
stow zsh
```

## Notes
- Some configs assume Linux/X11 (AwesomeWM, Rofi, Greenclip, Sxiv, Zathura).
- Adjust packages and dependencies for your system as needed.
