#!/usr/bin/env zsh

# Window 1: nvim - runs `nvim .`
tmux rename-window -t 1 nvim
tmux send-keys -t nvim 'nvim .' Enter

# Window 2: sync - runs the auto-git script
tmux new-window -n sync
tmux send-keys -t sync './.autogit.sh' Enter

# Focus back to first window (nvim)
tmux select-window -t nvim
