# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### "nvim" as manpager
export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
### "bat" as manpager
#export MANPAGER="sh -c 'col -bx | bat -l man '"
# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
 else
   export EDITOR='nvim'
 fi


autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# history setup
setopt SHARE_HISTORY
HISTFILE=$HOME/.zsh_history
SAVEHIST=1000
HISTSIZE=999
setopt HIST_EXPIRE_DUPS_FIRST

setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
#------------------------------------------------------------------------------#
#                                my custom alias                               #
#------------------------------------------------------------------------------#
alias ed="cd /run/media/dhyey/Dhyey"
alias r="ranger"
alias ..="cd .."
alias ...="cd ..;cd .."
alias s="exec $SHELL"
alias yay="paru"
alias se="sudoedit"
alias n="prime-run"
alias vi="nvim"
alias grep="rg"
alias nano="nvim"
alias v="nvim"
export EDITOR="nvim"
alias ll="exa --icons --group-directories-first -al"
#alias ll="lsd -al"
#alias l="lsd -l"
#alias rm="rm -i"
#alias ls="lsd"
alias ls="exa --icons --group-directories-first"
alias clip="xclip -selection clipboard"
alias nvimrc="cd ~/dotfiles/config/nvim; nvim init.vim; cd"
alias :q="exit"
alias l="exa --icons --group-directories-first -l"
alias code="codium"
alias pac="paru"
alias usb="cd /run/media/dhyey"
alias aurls="diff <(pacman -Q) <(pacman -Qn)"
#alias clear="clear;neofetch"
#alias firefox="firefox-developer-edition"
## check mime type
alias m="file --mime-type"
alias o="xdg-open"
# transmission aliases
alias td="transmission-daemon"
alias tds="transmission-remote --exit"
alias tsm="transmission-remote"
# protonvpn
alias vpnc="protonvpn-cli c"
alias vpnd="protonvpn-cli d"
alias vpns="protonvpn-cli s"
# git
alias g="git"
alias gd="git diff"
alias gc="git clone"
alias gst="git status"
# -------------------------------------------------------------------------------------------- #
# TMUX                                                                                         #
# -------------------------------------------------------------------------------------------- #
alias tmux="tmux -u"
alias tl="tmux -u ls"
alias tn="tmux -u  new -s"
alias ta="tmux -u a -t"
#------------------------------------------------------------------------------#
#                                   trash-cli                                  #
#------------------------------------------------------------------------------#

alias trp="trash-put"
alias trl="trash-list"
alias trp="trash-put"
alias trr="trash-restore"
alias tre="trash-empty"
alias trm="trash-rm"


#------------------------------------------------------------------------------#
#                                  youtube-dl                                  #
#------------------------------------------------------------------------------#
#
#alias yt="youtube-dl -f bestvideo+bestaudio"
#alias ym="youtube-dl -f bestvideo+bestaudio -x" 
alias yt="youtube-dl"
alias ytdl="youtube-dl -f 137+140"
alias ym="youtube-dl -x" 
# vi mode
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
	 [[ $1 = 'block' ]]; then
	echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
	   [[ ${KEYMAP} == viins ]] ||
	   [[ ${KEYMAP} = '' ]] ||
	   [[ $1 = 'beam' ]]; then
	echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
	zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
	echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
# Use vim keys in tab complete menu:
zstyle ':completion:*' menu select
zmodload zsh/complist
# use the vi navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char
 #Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
# Use lf to switch directories and bind it to ctrl-o
lf () {
	LF_TEMPDIR="$(mktemp -d -t lf-tempdir-XXXXXX)"
	LF_TEMPDIR="$LF_TEMPDIR" lf-run -last-dir-path="$LF_TEMPDIR/lastdir" "$@"
	if [ "$(cat "$LF_TEMPDIR/cdtolastdir" 2>/dev/null)" = "1" ]; then
		cd "$(cat "$LF_TEMPDIR/lastdir")"
	fi
	rm -r "$LF_TEMPDIR"
	unset LF_TEMPDIR
}
#lfcd () {
	#tmp="$(mktemp)"
	#lf -last-dir-path="$tmp" "$@"
	#if [ -f "$tmp" ]; then
		#dir="$(cat "$tmp")"
		#rm -f "$tmp"
		#[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"

	#fi

#}
#movedir () {
#items=`find ~ /media/common/Home/Videos /media/common/Home/Pictures /media/common/Home/Unacademy-jee /media/common/Home/Downloads /media/common/Home/Documents ~/my-git-projects /media/common/Home/Music ~/.config ~/my-git-projects/dotfiles/config/lf/.config/ ~/my-git-projects/dotfiles/config/nvim/.config/ ~/my-git-projects/dotfiles/config/rofi/.config/ ~/my-git-projects/dhyey-awesome/src ~/my-git-projects/dotfiles/config/ranger/.config/ ~/my-git-projects/dotfiles/config/kitty/.config/ ~/my-git-projects/dotfiles/ -maxdepth 1 -mindepth 1 -type d`
#selected=`echo "$items" | fzf`
#cd "$selected"
#}
fzfrm(){
items=`find .`
selected=`echo "$items" | fzf`
rm "$selected"
}
vimopen () {
items=`find ~/Documents/  ~/scripts ~/dotfiles`
selected=`echo "$items" | fzf`
directories=`echo "$selected" | awk -F "/"'BEGIN {for (i=1;i<=100;i++) {if ($i == $NF) i=101;}{else print "$i"/}}'`
files=`echo "$selected" | awk -F "/"'{print $NF}' `
nvim "$files"
}
f() {
    # if no arguments passed, just lauch fzf
    if [ $# -eq 0 ]
    then
        fzf
        return 0
    fi

    # Store the program
    program="$1"

    # Remove first argument off the list
    shift

    # Store any option flags
    #options="$@"

    # Store the arguments from fzf
    arguments=$(fzf --multi)

    # If no arguments passed (e.g. if Esc pressed), return to terminal
    if [ -z "${arguments}" ]; then
        return 1
    fi

    # Sanitise the command by putting single quotes around each argument, also
    # first put an extra single quote next to any pre-existing single quotes in
    # the raw argument. Put them all on one line.
    for arg in "${arguments[@]}"; do
        arguments=$(echo "$arg" | sed "s/'/''/g; s/.*/'&'/g; s/\n//g")
    done

    # If the program is on the GUI list, add a '&'
    if [[ "$program" =~ ^(thunar|zathura|evince|mpv|eog|kolourpaint)$ ]]; then
        arguments="$arguments &"
    fi

    # Write the shell's active history to ~/.bash_history.
    history -w

    # Add the command with the sanitised arguments to .bash_history
    echo $program $options $arguments >> ~/.bash_history

    # Reload the ~/.bash_history into the shell's active history
    history -r

    # execute the last command in history
    fc -s -1
    }
manpage () {
items=`man -k . | fzf | awk '{print $1}'`
man "$items"
}
pacuninstall () {
	pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns
}
pacinstall () {
	pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
}
bindkey -s '^[l' "lfcd\n"
bindkey -s '^[r' "ranger\n"
bindkey -s '^[r' "fzfrm\n"
#bindkey -s '^[d' "movedir\n"
bindkey -s '^[f' "vimopen\n"
bindkey -s '^[m' "manpage\n"
bindkey -s '^[i' "pacinstall\n"
bindkey -s '^[u' "pacuninstall\n"
bindkey -s '^f'  "lf | xdotool key f f \n"
bindkey -s '^[h' '^r'
bindkey -s '^[d' '^[c'
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# spaceship settings
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_CHAR_SYMBOL=❯
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_HG_SHOW=false
SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_NODE_SHOW=false
SPACESHIP_RUBY_SHOW=false
SPACESHIP_ELM_SHOW=false
SPACESHIP_ELIXIR_SHOW=false
SPACESHIP_XCODE_SHOW_LOCAL=false
SPACESHIP_SWIFT_SHOW_LOCAL=false
SPACESHIP_GOLANG_SHOW=false
SPACESHIP_PHP_SHOW=false
SPACESHIP_RUST_SHOW=false
SPACESHIP_JULIA_SHOW=false
SPACESHIP_DOCKER_SHOW=false
SPACESHIP_DOCKER_CONTEXT_SHOW=false
SPACESHIP_AWS_SHOW=false
SPACESHIP_CONDA_SHOW=false
SPACESHIP_VENV_SHOW=false
SPACESHIP_PYENV_SHOW=false
SPACESHIP_DOTNET_SHOW=false
SPACESHIP_EMBER_SHOW=false
SPACESHIP_KUBECONTEXT_SHOW=false
SPACESHIP_TERRAFORM_SHOW=false
SPACESHIP_TERRAFORM_SHOW=false
SPACESHIP_VI_MODE_SHOW=false
SPACESHIP_JOBS_SHOW=false
# load
autoload -U promptinit; promptinit
prompt spaceship
source $HOME/.zshenv 
#source /usr/share/fzf/key-bindings.zsh
#source /usr/share/fzf/completion.zsh
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
#neofetch
 #To customize prompt, run `p10k configure` or edit ~/my-git-projects/dotfiles/zsh/.p10k.zsh.
#source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#clear
#fm6000 -dog -c white
# To customize prompt, run `p10k configure` or edit ~/dotfiles/zsh/.p10k.zsh.
#[[ ! -f ~/dotfiles/zsh/.p10k.zsh ]] || source ~/dotfiles/zsh/.p10k.zsh
terminall=`basename "/"$(ps -f -p $(cat /proc/$(echo $$)/stat | cut -d \  -f 4) | tail -1 | sed 's/^.* //')`
