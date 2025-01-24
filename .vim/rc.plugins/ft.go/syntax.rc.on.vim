if InitStep() == 0
  call dein#add('charlespascoe/vim-go-syntax', { 'rev': '722a2e09f64e3f49c1d0fc632a11f5792d6e0503', 'on_ft' : ['go'] })
  finish
endif

augroup filtype_go
  autocmd!
  autocmd FileType go call s:ft_go()
augroup END

function! s:ft_go() abort
  let b:keyword_lookup_url='https://pkg.go.dev/search?q=%s'
endfunction
