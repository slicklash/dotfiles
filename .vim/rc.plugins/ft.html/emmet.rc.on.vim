if InitStep() == 0
  call dein#add('mattn/emmet-vim', { 'rev': '6c511a8d7d2863066f32e25543e2bb99d505172c', 'on_ft': ['html','xml','xsl','xslt','xsd','css', 'sass','scss','less','mustache', 'javascript', 'jsx', 'javascript.jsx'] })
  finish
endif

let g:user_emmet_settings = {
      \  'javascript.jsx' : {
      \      'extends': 'jsx',
      \      'quote_char': "'",
      \  },
      \}

let g:user_emmet_leader_key = '<C-E>'
" let g:user_emmet_expandabbr_key='<Tab>'

" imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
autocmd FileType css,scss nnoremap <silent> <leader>S vi{:sort<CR>
autocmd FileType html,css,javascript.jsx EmmetInstall
