#!/usr/bin/env zsh

# Emacs mode
bindkey -e

bindkey '^[[1;9D' emacs-backward-word               # [Option-RightArrow] - move to the begginning of the previous word
bindkey '^[[1;9C' emacs-forward-word                # [Option-LeftArrow] - move to the end of the next word
bindkey '^[[H' beginning-of-line                    # [Fn-RightArrow] - move to the beginning of the line
bindkey '^[[F' end-of-line                          # [Fn-LeftArrow] - move to the end of the line
bindkey '^[[3~' delete-char                         # [Fn-Delete] - delete the character under the cursor
bindkey "^R" history-search-multi-word              # [Control-R] - search backward incrementally for a specified string
bindkey '^[[Z' reverse-menu-complete                # [Shift-TAB] - backward TAB in completions
bindkey '^H' backward-delete-word                   # [Control-H] - delete the last word

