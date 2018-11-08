if InitStep() == 0 && exists('$TMUX')
    call dein#add('christoomey/vim-tmux-navigator')
    finish
endif

let g:tmux_navigator_disable_when_zoomed = 1
