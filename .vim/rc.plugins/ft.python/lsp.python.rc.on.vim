if InitStep() == 0
  finish
endif

augroup filetype_py
  autocmd!
  autocmd FileType python call s:ft_py()
augroup END

function! s:ft_py() abort
  nnoremap <buffer> <silent><leader>i :ImportName<cr>
endfunction
