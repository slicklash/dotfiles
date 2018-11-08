if InitStep() == 0
    call dein#add('ntpeters/vim-better-whitespace')
    let g:better_whitespace_filetypes_blacklist=['diff', 'qf', 'gitcommit', 'unite', 'vimfiler', 'help']
    autocmd FileType unite DisableWhitespace
    autocmd FileType vimfiler DisableWhitespace
    finish
endif
