if InitStep() == 0
  call dein#add('vim-python/python-syntax', { 'rev': '2cc00ba72929ea5f9456a26782db57fb4cc56a65' })
  finish
endif

let g:python_highlight_all = 1

augroup filtype_py
  autocmd!
  autocmd FileType python call s:ft_py()
augroup END

function! s:ft_py() abort
  let b:keyword_lookup_url='https://docs.python.org/3/search.html?q=%s&keywords=yes'
  setlocal formatprg=black\ -q\ -S\ -
  nnoremap <buffer> <silent><leader>i :ImportName<cr>
endfunction
