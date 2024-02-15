if InitStep() == 0
  call dein#add('charlespascoe/vim-go-syntax', { 'rev': '4bd077efb24fb728109daa484ba63da2e1f3fc47', 'on_ft' : ['go'] })
  finish
endif

augroup filtype_go
  autocmd!
  autocmd FileType go call s:ft_go()
augroup END

function! s:ft_go() abort
  let b:keyword_lookup_url='https://pkg.go.dev/search?q=%s'
endfunction
