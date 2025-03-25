# Only run this in interactive shells
if status is-interactive

  # I'm trying to grow a neckbeard
  # fish_vi_key_bindings
  # Set the cursor shapes for the different vi modes.
  set fish_cursor_default     block      blink
  set fish_cursor_insert      line       blink
  set fish_cursor_replace_one underscore blink
  set fish_cursor_visual      block
  set fish_greeting ""
  function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
  end
end
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/dhyey/miniconda3/bin/conda
    eval /home/dhyey/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/dhyey/miniconda3/etc/fish/conf.d/conda.fish"
        . "/home/dhyey/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/dhyey/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<


# PNPM initialization: add PNPM_HOME to PATH if not already present
set -x PNPM_HOME "/home/dhyey/.local/share/pnpm"
if not contains $PNPM_HOME $PATH
    set -x PATH $PNPM_HOME $PATH
end

fish_add_path /home/dhyey/.cargo/bin
