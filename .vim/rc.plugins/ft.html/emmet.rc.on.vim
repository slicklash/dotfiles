if InitStep() == 0
    call dein#add('mattn/emmet-vim', { 'on_ft': ['html','xml','xsl','xslt','xsd','css', 'sass','scss','less','mustache', 'javascript', 'jsx'] })
    finish
endif

let g:user_emmet_settings = {
\  'javascript.jsx' : {
\      'extends': 'jsx',
\      'quote_char': "'",
\  },
\}

let g:user_emmet_leader_key = '<C-E>'

autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
autocmd FileType css,scss nnoremap <silent> <leader>S vi{:sort<CR>
