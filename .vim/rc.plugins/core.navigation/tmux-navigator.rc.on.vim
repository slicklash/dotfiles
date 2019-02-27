if InitStep() == 0 && exists('$TMUX')
  call dein#add('christoomey/vim-tmux-navigator')
  finish
endif

let g:tmux_navigator_disable_when_zoomed = 1

augroup tmux_exec
  autocmd!
  autocmd FileType * call s:tmux_exec()
augroup END

function! s:tmux_exec() abort
  if &filetype =~ 'python'
    map <Leader>e :execute 'silent !tmux send-keys -t left ./'.expand('%:t').' Enter'<Bar>redraw!<C-M>
    map <Leader>E :execute 'silent !tmux send-keys -t left pypy3\ ./'.expand('%:t').' Enter'<Bar>redraw!<C-M>
  elseif &filetype =~ 'javascript'
    map <Leader>e :execute 'silent !tmux send-keys -t left node\ '.expand('%:p').' Enter'<Bar>redraw!<C-M>
    map <Leader>E :execute 'silent !tmux send-keys -t left node\ --inspect-brk\ '.expand('%:p').' Enter'<Bar>redraw!<C-M>
  elseif &filetype =~ 'typescript'
    map <Leader>e :execute 'silent !tmux send-keys -t left ts-node\ '.expand('%:p').' Enter'<Bar>redraw!<C-M>
    map <Leader>E :execute 'silent !tmux send-keys -t left ts-node\ --inspect-brk\ '.expand('%:p').' Enter'<Bar>redraw!<C-M>
  endif
endfunction

