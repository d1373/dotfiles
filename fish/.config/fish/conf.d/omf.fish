# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

set -x PATH $HOME/miniconda3/bin $PATH
#===============================================================================
# Environment variables
#===============================================================================
set -x MANPAGER "sh -c 'col -bx | batcat -l man -p'"
set -x EDITOR "nvim"
set -x VISUAL "nvim"

# Add Go bin directory to PATH
set -x PATH (go env GOPATH)/bin $PATH
# Add local bin
set -x PATH $HOME/.local/bin $PATH

#===============================================================================
# Aliases (functions in fish)
#===============================================================================
alias .. 'cd ..'
alias ... 'cd ..; cd ..'
alias bat 'batcat'
alias se 'sudoedit'
alias vi 'nvim'
alias r 'ranger'
alias grep 'rg'
alias nano 'nvim'
alias v 'nvim'
alias ll 'lsd -al'
alias l 'lsd -l'
alias rm 'rm -i'
alias ls 'lsd'
alias :q 'exit'
alias m 'file --mime-type'
alias o 'xdg-open'
alias t 'cd ~; z'  # assuming "z" is available from zoxide

# Git aliases
alias g 'git'
alias gd 'git diff'
alias gc 'git clone'
alias gst 'git status'

# WSL aliases
alias winget 'powershell.exe winget'
alias ex 'explorer.exe .'

# Initialize zoxide for fish (if using zoxide)
# (zoxide’s fish integration provides a command “z” for quick directory jumping)
eval (zoxide init fish)

# Tmux aliases
alias np '~/.script/sesh.sh'
alias rt '~/.script/rt.sh'
alias tn 'tmux new -s'
alias tl 'tmux ls'
alias syss 'sudo systemctl status'
alias sysstart 'sudo systemctl start'
alias sysstop 'sudo systemctl stop'
alias syse 'sudo systemctl enable'
alias taa 'tmux a'
alias tks 'tmux kill-server'

# Other aliases
alias yy '~/yazi/yazi'
alias ya '~/yazi/ya'
alias n 'pnpm'

#===============================================================================
# Custom functions
#===============================================================================
# Function: Attach to a tmux session using fzf
function ta
    # List tmux sessions and pick one using fzf
    set selected (tmux ls | fzf)
    # Extract the session name (assumes the session name is the first word)
    set session (echo $selected | awk '{print $1}')
    tmux attach -t $session
end

# Function: Change directory to one selected via fzf
function movedir
    # Find directories in common locations
    set items (find ~ ~/dotfiles ~/.config ~/dev -maxdepth 1 -mindepth 1 -type d)
    set selected (echo $items | fzf)
    cd $selected
end

#===============================================================================
# Key bindings for custom functions
#===============================================================================
# Bind Alt+t to run the "ta" function and Alt+d to run "movedir"
bind \et ta
bind \ed movedir

#===============================================================================
# Additional PATH and tool initializations
#===============================================================================
# Conda initialization (if conda is installed and already set up for fish)
# The conda docs recommend running "conda init fish" so this block may be auto‐generated.
# >>> conda initialize >>>
eval (conda shell.fish hook)
# <<< conda initialize <<<


# FNM environment variables
set -gx PATH "/run/user/1000/fnm_multishells/9644_1740831670954/bin" $PATH
set -gx FNM_MULTISHELL_PATH "/run/user/1000/fnm_multishells/9644_1740831670954"
set -gx FNM_VERSION_FILE_STRATEGY "local"
set -gx FNM_DIR "/home/dhyey/.local/share/fnm"
set -gx FNM_LOGLEVEL "info"
set -gx FNM_NODE_DIST_MIRROR "https://nodejs.org/dist"
set -gx FNM_COREPACK_ENABLED "false"
set -gx FNM_RESOLVE_ENGINES "false"
set -gx FNM_ARCH "x64"

# Define the autoload hook function for fnm
function _fnm_autoload_hook --on-variable PWD --description 'Change Node version on directory change'
    # If inside a command substitution, simply return
    if status --is-command-substitution
        return
    end

    # If a .node-version or .nvmrc file exists, switch Node version silently
    if test -f .node-version -o -f .nvmrc
        fnm use --silent-if-unchanged
    end
end

# Run the autoload hook
_fnm_autoload_hook

# PNPM initialization: add PNPM_HOME to PATH if not already present
set -x PNPM_HOME "/home/dhyey/.local/share/pnpm"
if not contains $PNPM_HOME $PATH
    set -x PATH $PNPM_HOME $PATH
end

#===============================================================================
# Optional: Enable vi keybindings in fish
#===============================================================================
# This makes fish use vi-style key bindings in the command line.
fish_vi_key_bindings
# Load Oh My Fish configuration.
source $OMF_PATH/init.fish
