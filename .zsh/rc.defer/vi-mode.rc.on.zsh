setopt vi

function jj-escape() {
  zle vi-cmd-mode
  zle forward-char
}
zle -N jj-escape

function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)      print -n -- "\e[2 q" ;; # cursor block
    viins|main) print -n -- "\e[6 q" ;; # cursor beam
  esac
}
zle -N zle-line-init
zle -N zle-keymap-select

function zle-line-finish {
  print -n -- "\e[2 q"
  print -n -- "\e]12;white\a"
}
zle -N zle-line-finish

function zle-vi-yank {
  zle .vi-yank
  print -rn -- "$CUTBUFFER" | pbcopy
  zle vi-cmd-mode
}
zle -N zle-vi-yank

function zle-vi-paste {
  LBUFFER+=$(pbpaste)
}
zle -N zle-vi-paste

bindkey -M viins 'jj' jj-escape
bindkey -M vicmd 'H' beginning-of-line
bindkey -M vicmd 'L' end-of-line
bindkey -M vicmd 'y' zle-vi-yank
bindkey -M vicmd 'p' zle-vi-paste
