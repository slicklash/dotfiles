call dein#add('mgedmin/python-imports.vim', { 'rev': 'a0eea0f502827481fcced8aba2f9313ee955a02b', 'on_ft': ['python'] })

augroup filtype_py
  autocmd!
  autocmd FileType python call s:ft_py()
augroup END

function! s:ft_py() abort
  let b:keyword_lookup_url='https://docs.python.org/3/search.html?q=%s&keywords=yes'
  setlocal formatprg=black\ -q\ -S\ -
  setlocal sw=4 sts=4 ts=4 et
  nnoremap <buffer> <silent><leader>i <cmd>ImportName<cr>
endfunction
