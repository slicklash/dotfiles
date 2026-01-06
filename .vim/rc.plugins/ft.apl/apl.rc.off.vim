call dein#add('https://gitlab.com/n9n/vim-apl.git', { 'filetypes' : ['atf', 'w3'] })

if has('unix')
  autocmd FileType apl setlocal guifont=SImPL\ 12
else
  autocmd FileType apl setlocal guifont=SImPL:h12
endif
