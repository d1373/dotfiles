#!/usr/bin/env zsh

# Window 1: code - runs `nvim .`
tmux rename-window -t 1 code

# Window 2: term - split horizontally into two panes
tmux new-window -n term
tmux split-window -h -t term

# Window 3: git - runs `lazygit`
tmux new-window -n git
tmux send-keys -t git 'lazygit' Enter

# Focus back to first window (code)
tmux select-window -t code
tmux send-keys -t code 'clear' Enter
tmux send-keys -t code 'nvim .' Enter
