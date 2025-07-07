#!/usr/bin/env zsh

# Window 1: f-code - runs `nvim .`
tmux rename-window -t 1 f-code

# Window 2: f-term - split horizontally into two panes
tmux new-window -n f-term
tmux split-window -h -t f-term

# Window 3: b-code - runs `nvim .`
tmux new-window -n b-code
tmux send-keys -t b-code 'cd src/backend' Enter
tmux send-keys -t b-code 'clear' Enter
tmux send-keys -t b-code 'nvim .' Enter
# Window 4: b-term - split horizontally into two panes
tmux new-window -n b-term
tmux split-window -h -t b-term
# Window 5: git_doc - runs 'lazygit' 
tmux new-window -n git_doc
tmux send-keys -t git_doc 'lazygit' Enter

# Focus back to first window (code)
tmux select-window -t f-code
tmux send-keys -t f-code 'cd src/frontend' Enter
tmux send-keys -t f-code 'clear' Enter
tmux send-keys -t f-code 'nvim .' Enter
