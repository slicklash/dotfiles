if InitStep() == 0
    call dein#add('epeli/slimux')
    finish
endif

noremap <Leader>m :SlimuxREPLSendLine<CR>
vnoremap <Leader>m :SlimuxREPLSendSelection<CR>
noremap <Leader>o :SlimuxREPLSendBuffer<CR>
