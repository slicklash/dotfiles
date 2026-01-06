call dein#add('liuchengxu/graphviz.vim', { 'rev': 'dbe1de334097891186e09e5616671091d89011d5' })

augroup filtype_dot
  autocmd!
  autocmd FileType dot noremap <buffer> <F5> <cmd>GraphvizCompile \| Graphviz!<CR>
augroup END
