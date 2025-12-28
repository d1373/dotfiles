#!/usr/bin/env zsh
tmux rename-window -t 1 main
tmux new-window -n powershell
tmux send-keys -t powershell 'powershell.exe' Enter
tmux select-window -t main
tmux send-keys -t main 'clear' Enter
