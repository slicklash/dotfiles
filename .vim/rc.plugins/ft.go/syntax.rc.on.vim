if InitStep() == 0
  call dein#add('charlespascoe/vim-go-syntax', { 'rev': 'bdfd827ea9045679dee38d8c33052937a734e577', 'on_ft' : ['go'] })
  finish
endif

augroup filtype_go
  autocmd!
  autocmd FileType go call s:ft_go()
augroup END

function! s:ft_go() abort
  let b:keyword_lookup_url='https://pkg.go.dev/search?q=%s'
endfunction
