call dein#add('charlespascoe/vim-go-syntax', { 'rev': '290fcd7df3f1d5746ab5db75240e02bc379cb524', 'on_ft' : ['go'] })

augroup filtype_go
  autocmd!
  autocmd FileType go call s:ft_go()
augroup END

function! s:ft_go() abort
  let b:keyword_lookup_url='https://pkg.go.dev/search?q=%s'
endfunction
