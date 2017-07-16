#!/usr/bin/env zsh

bindkey '^[[A' history-substring-search-up          # [Up] Nearest command that contains string and is older than the current command in history
bindkey '^[[B' history-substring-search-down        # [Down] Nearest command that contains string and is newer than the current command in history
bindkey '^[[1;9D' emacs-backward-word               # [Option-RightArrow] - move to the begginning of the previous word
bindkey '^[[1;9C' emacs-forward-word                # [Option-LeftArrow] - move to the end of the next word
bindkey '^[[H' beginning-of-line                    # [Fn-RightArrow] - move to the beginning of the line
bindkey '^[[F' end-of-line                          # [Fn-LeftArrow] - move to the end of the line
bindkey '^[[3~' delete-char                         # [Fn-Delete] - delete the character under the cursor
bindkey '^R' history-incremental-search-backward    # [Control-R] - search backward incrementally for a specified string
bindkey 'ESC-^[[3~' backward-kill-word