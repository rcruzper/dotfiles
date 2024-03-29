#!/usr/bin/env zsh

# vicmd mode
bindkey -v

if [ "$TERM_PROGRAM" = tmux ]; then
    bindkey '^[[1;3D' emacs-backward-word               # [Option-RightArrow] - move to the begginning of the previous word
    bindkey '^[[1;3C' emacs-forward-word                # [Option-LeftArrow] - move to the end of the next word
else
    bindkey '^[[1;9D' emacs-backward-word               # [Option-RightArrow] - move to the begginning of the previous word
    bindkey '^[[1;9C' emacs-forward-word                # [Option-LeftArrow] - move to the end of the next word
fi
bindkey '^[[H' beginning-of-line                    # [Fn-RightArrow] - move to the beginning of the line
bindkey '^[[F' end-of-line                          # [Fn-LeftArrow] - move to the end of the line
bindkey '^[[3~' delete-char                         # [Fn-Delete] - delete the character under the cursor
bindkey '^[[Z' reverse-menu-complete                # [Shift-TAB] - backward TAB in completions
bindkey '^H' backward-delete-word                   # [Control-H] - delete the last word
