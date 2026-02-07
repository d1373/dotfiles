#===============================================================================
# Zinit
#===============================================================================
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk


#===============================================================================
# Environment Variables
#===============================================================================
export MANPAGER="sh -c 'col -bx | nvim -R -c \"set ft=man\" -'"
export EDITOR="nvim"
export VISUAL="nvim"
export BAT_THEME="ansi"
export BROWSER="helium-browser"
export GPG_TTY=$(tty)
export PATH="$HOME/.local/bin:$PATH"
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORMTHEME_QT6=qt6ct
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(fnm env)"
autoload -U promptinit; promptinit
prompt pure
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$HOME/.config/emacs/bin:$PATH"
eval "$(jenv init -)"
eval "$(zoxide init zsh)"
# set option
setopt correct
autoload -Uz compinit
compinit
export LF_ICONS="di=: fi=: ln=: or=: ex=: *.vimrc=: *.viminfo=: *.gitignore=: *.c=: *.cc=: *.clj=: *.coffee=: *.cpp=: *.css=: *.d=: *.dart=: *.erl=: *.exs=: *.fs=: *.go=: *.h=: *.hh=: *.hpp=: *.hs=: *.html=: *.java=: *.jl=: *.js=: *.json=: *.lua=: *.md=: *.php=: *.pl=: *.pro=: *.py=: *.rb=: *.rs=: *.scala=: *.ts=: *.vim=: *.cmd=: *.ps1=: *.sh=: *.bash=: *.zsh=: *.fish=: *.tar=: *.tgz=: *.arc=: *.arj=: *.taz=: *.lha=: *.lz4=: *.lzh=: *.lzma=: *.tlz=: *.txz=: *.tzo=: *.t7z=: *.zip=: *.z=: *.dz=: *.gz=: *.lrz=: *.lz=: *.lzo=: *.xz=: *.zst=: *.tzst=: *.bz2=: *.bz=: *.tbz=: *.tbz2=: *.tz=: *.deb=: *.rpm=: *.jar=: *.war=: *.ear=: *.sar=: *.rar=: *.alz=: *.ace=: *.zoo=: *.cpio=: *.7z=: *.rz=: *.cab=: *.wim=: *.swm=: *.dwm=: *.esd=: *.jpg=: *.jpeg=: *.mjpg=: *.mjpeg=: *.gif=: *.bmp=: *.pbm=: *.pgm=: *.ppm=: *.tga=: *.xbm=: *.xpm=: *.tif=: *.tiff=: *.png=: *.svg=: *.svgz=: *.mng=: *.pcx=: *.mov=: *.mpg=: *.mpeg=: *.m2v=: *.mkv=: *.webm=: *.ogm=: *.mp4=: *.m4v=: *.mp4v=: *.vob=: *.qt=: *.nuv=: *.wmv=: *.asf=: *.rm=: *.rmvb=: *.flc=: *.avi=: *.fli=: *.flv=: *.gl=: *.dl=: *.xcf=: *.xwd=: *.yuv=: *.cgm=: *.emf=: *.ogv=: *.ogx=: *.aac=: *.au=: *.flac=: *.m4a=: *.mid=: *.midi=: *.mka=: *.mp3=: *.mpc=: *.ogg=: *.ra=: *.wav=: *.oga=: *.opus=: *.spx=: *.xspf=: *.pdf=: *.nix=: " 
### End of Environment Variables

#===============================================================================
# Key Bindings and Cursor Shape (Vi Mode)
#===============================================================================
bindkey -v
export KEYTIMEOUT=1

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd || $1 == 'block' ]]; then
    echo -ne '\e[1 q'
  else
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

function zle-line-init {
  zle -K viins
  echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q'; }

zstyle ':completion:*' menu select
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line
### End of Key Bindings and Cursor Shape (Vi Mode)

#===============================================================================
# Plugins
#===============================================================================

zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit snippet OMZP::git
zinit snippet OMZP::sudo          # Press ESC twice to add sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::extract       # Universal extract command
zinit snippet OMZP::copyfile      # Copy file contents to clipboard
zinit snippet OMZP::copypath      # Copy current path to clipboard
### End of Plugins
#===============================================================================
# settings for plugins
#===============================================================================
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case insensitive
zstyle ':completion:*' menu select                       # Menu selection
zstyle ':completion:*' rehash true                       # Auto rehash commands
zstyle ':completion::complete:*' gain-privileges 1       # Privilege completion
# FZF tab completion styling
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons $realpath 2>/dev/null || ls --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --icons $realpath 2>/dev/null || ls --color=always $realpath'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
### End of settings for plugins
#===============================================================================
# Aliases
#===============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias cat='bat'
alias vi='nvim'
alias v='nvim'
alias nano='nvim'
alias grep='rg'
alias ll='eza -la --icons --header --group-directories-first --git'
alias l='eza -l --icons --header --git --group-directories-first'
alias ls='eza --icons --oneline --group-directories-first'
alias :q='exit'
alias m='file --mime-type'
alias o='xdg-open'
alias tks='tmux kill-server'
alias lg='lazygit'
alias ta='~/.script/sss.sh'
alias e='pcmanfm-qt .'
alias sw='~/.script/sw.sh'
alias tuc="~/.local/script/Tu-clausthal.sh"
alias y="yazi"
alias n='pnpm'
alias mb="~/.script/brew-search.sh"
alias mbr="~/.script/brew-remove.sh"
alias ss='yay -Ss'
alias ins='yay -S'
alias yrn="yay -Rns"
# End of Aliases

source /home/dhyey/.config/broot/launcher/bash/br
