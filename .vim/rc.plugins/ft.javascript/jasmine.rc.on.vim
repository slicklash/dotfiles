if InitStep() == 0
    " augroup filetype_jasmine
    "     autocmd!
    "     autocmd BufRead,BufEnter *.spec.js setlocal filetype=javascript.jasmine
    " augroup END
endif
