if InitStep() == 0
    finish
endif

augroup filtype_py
    autocmd!
    autocmd FileType python setlocal formatprg=black\ -q\ -S\ -
augroup END
