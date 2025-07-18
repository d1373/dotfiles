# 🏠 Dotfiles

My personal configuration files for a complete macOS/Linux desktop environment, managed with GNU Stow.

## ✨ Features

### 🚀 Terminal & Shell
- **Kitty Terminal** - GPU-accelerated terminal emulator
  - Custom themes and color schemes
  - Font rendering optimizations
  - Keyboard shortcuts for productivity
  
- **Zsh Shell** with:
  - `.zshrc` - Main shell configuration
  - `.p10k.zsh` - Powerlevel10k prompt theme
  - `.zshenv` - Environment variables
  - Syntax highlighting and autosuggestions
  - Custom aliases and functions

### 📝 Text Editing
- **Neovim** - Hyperextensible text editor
  - LSP support for multiple languages
  - Custom plugins and keybindings
  - Optimized for coding workflow

### 🗂️ File Management
- **lf** - Terminal file manager
  - Custom keybindings
  - Preview support
  - Integration with other tools

### 🖼️ Media & Documents
- **Vimiv** - Image viewer with vim-like keybindings
  - Fast image browsing
  - Basic editing capabilities
  
- **Zathura** - Minimalist PDF/document viewer
  - Vim-style navigation
  - Custom color schemes
  - SyncTeX support

### 🎨 Application Launcher
- **Rofi** - Application launcher and window switcher
  - Custom themes
  - Multiple modi (window, drun, run, ssh)
  - Integration with system clipboard

### 🎯 Additional Tools
- **Neofetch** - System information display
- **Touchcursor** - Keyboard remapping tool
- Various utility scripts and configurations

## 📋 Prerequisites

Before installing these dotfiles, ensure you have Homebrew and the following packages installed:

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Core dependencies
brew install git stow

# Required packages
brew install neovim kitty zsh rofi zathura zathura-pdf-poppler \
             lf vimiv neofetch python

# Note: Some packages may require additional taps
brew tap zegervdv/zathura
```

### Additional Setup
- Install [Powerlevel10k](https://github.com/romkatv/powerlevel10k) for Zsh
- Install any required fonts (recommended: Nerd Fonts)
  ```bash
  brew tap homebrew/cask-fonts
  brew install --cask font-hack-nerd-font
  ```

## 🛠️ Installation

### 1. Clone the Repository

```bash
cd ~
git clone https://github.com/d1373/dotfiles.git
cd dotfiles
```

### 2. Backup Existing Configurations

Before using stow, backup any existing configuration files:

```bash
# Create backup directory
mkdir -p ~/dotfiles-backup

# Backup existing configs (if they exist)
cp -r ~/.config/nvim ~/dotfiles-backup/ 2>/dev/null
cp -r ~/.config/kitty ~/dotfiles-backup/ 2>/dev/null
cp ~/.zshrc ~/dotfiles-backup/ 2>/dev/null
# ... repeat for other configs
```

### 3. Using GNU Stow

GNU Stow creates symlinks from your dotfiles directory to your home directory. Here's how to use it:

#### Install All Configurations

```bash
# From the dotfiles directory
stow */
```

#### Install Individual Configurations

```bash
# Install specific configs
stow nvim
stow kitty
stow zsh
stow rofi
stow lf
stow vimiv
stow zathura
stow neofetch
```

#### Removing Configurations

```bash
# Remove symlinks for a specific config
stow -D nvim

# Remove all symlinks
stow -D */
```

#### Restowing (Updating Links)

```bash
# Useful when you've added new files to a config
stow -R nvim

# Restow everything
stow -R */
```

### 4. Post-Installation

```bash
# Set Zsh as default shell
chsh -s $(which zsh)

# Install Neovim plugins (launch nvim and run)
:PackerSync  # or :PlugInstall depending on plugin manager

# Generate Powerlevel10k config (on first Zsh launch)
p10k configure
```

## 🗂️ Directory Structure

```
dotfiles/
├── kitty/
│   └── .config/
│       └── kitty/
├── lf/
│   └── .config/
│       └── lf/
├── neofetch/
│   └── .config/
│       └── neofetch/
├── nvim/
│   └── .config/
│       └── nvim/
├── rofi/
│   └── .config/
│       └── rofi/
├── vimiv/
│   └── .config/
│       └── vimiv/
├── zathura/
│   └── .config/
│       └── zathura/
├── zsh/
│   ├── .zshrc
│   ├── .zshenv
│   └── .p10k.zsh
└── touchcursor/
    └── .config/
        └── touchcursor/
```

## 🔧 Customization

Feel free to modify any configuration to suit your needs:

1. **Kitty**: Modify `.config/kitty/kitty.conf` for terminal settings
2. **Neovim**: Update `.config/nvim/init.lua` (or init.vim) for editor settings
3. **Zsh**: Customize `.zshrc` for aliases and shell behavior
4. **Rofi**: Edit `.config/rofi/config.rasi` for launcher appearance

## 🐛 Troubleshooting

### Stow Conflicts
If you get conflicts when using stow:
```bash
# Force stow (will overwrite existing files)
stow --adopt nvim

# Or manually remove conflicting files first
rm -rf ~/.config/nvim
stow nvim
```

### Missing Dependencies
Check that all required packages are installed for each component. Some configs may require additional setup or plugins.

### Permission Issues
Ensure your user owns the dotfiles directory:
```bash
chown -R $USER:$USER ~/dotfiles
```

### macOS Specific Issues
- Some applications like Rofi may not work natively on macOS and might require alternatives
- Ensure XQuartz is installed for X11 applications:
  ```bash
  brew install --cask xquartz
  ```

## 🙏 Credits

- Various themes and plugins from their respective authors
- The amazing open-source community
- [Distrotube](https://gitlab.com/dwt1/dotfile) dotfiles

---

**Note**: These are my personal configurations. They work for me but might need adjustments for your setup. Feel free to fork and customize!
