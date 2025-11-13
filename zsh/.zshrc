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

# zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# zsh-syntax-highlighting (must be sourced at the end of the file)
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# add this to your shell profile (~/.zshrc or ~/.bashrc) too
export GPG_TTY=$(tty)
# Optional: make autosuggestions use a subtle color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/dhyey/.lmstudio/bin"
# End of LM Studio CLI section
export PATH="$HOME/.script:$PATH"

export PATH="$HOME/.local/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

fpath+=("$(brew --prefix)/share/zsh/site-functions")
# .zshrc
autoload -U promptinit; promptinit
prompt pure
# pnpm
export PNPM_HOME="/Users/dhyey/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
