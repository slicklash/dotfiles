vim9script

dein#add('charlespascoe/vim-go-syntax', {'rev': '290fcd7df3f1d5746ab5db75240e02bc379cb524', 'on_ft': ['go']})

def FtGo()
  b:keyword_lookup_url = 'https://pkg.go.dev/search?q=%s'
enddef

augroup filtype_go
  autocmd!
  autocmd FileType go FtGo()
augroup END
