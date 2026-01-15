#===============================================================================
# Environment Variables
#===============================================================================
export MANPAGER="sh -c 'col -bx | nvim -R -c \"set ft=man\" -'"
export EDITOR="nvim"
export VISUAL="nvim"
export BAT_THEME="ansi"

# set option
setopt correct
#===============================================================================
# Aliases
#===============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias cat='bat'
alias vi='nvim'
alias v='nvim'
alias grep='rg'
alias ll='eza -la --icons --header --group-directories-first --git'
alias l='eza -l --icons --header --git --group-directories-first'
alias ls='eza --icons --oneline --group-directories-first'
alias :q='exit'
alias m='file --mime-type'
alias o='open'
# Tmux Aliases
alias tks='tmux kill-server'
alias lg='lazygit'
alias ta='~/.script/sss.sh'
alias powershell='powershell.exe'
alias e='explorer.exe .'
alias sw='~/.script/sw.sh'


# Miscellaneous
alias n='pnpm'
alias mb="~/.script/brew-search.sh"
alias mbr="~/.script/brew-remove.sh"
#===============================================================================
# Plugins / Initialization
#===============================================================================
eval "$(zoxide init zsh)"

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


#===============================================================================
# Plugins: zsh-autosuggestions and zsh-syntax-highlighting
#===============================================================================
# Ensure you have both plugins cloned in ~/.zsh/zsh-autosuggestions and ~/.zsh/zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# add this to your shell profile (~/.zshrc or ~/.bashrc) too
export GPG_TTY=$(tty)
# Optional: make autosuggestions use a subtle color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'


export PATH="$HOME/.local/bin:$PATH"


# .zshrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(fnm env)"
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
autoload -U promptinit; promptinit
prompt pure
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
