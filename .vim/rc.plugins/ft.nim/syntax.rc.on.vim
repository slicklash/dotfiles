if InitStep() == 0
  call dein#add('zah/nim.vim')
  finish
endif

augroup filtype_nim
  autocmd!
  autocmd FileType nim call s:ft_nim()
augroup END

function! s:ft_nim() abort
  let b:keyword_lookup_url='https://nim-lang.org/docs/theindex.html\#%s'
  setlocal formatprg=nimpretty
endfunction
