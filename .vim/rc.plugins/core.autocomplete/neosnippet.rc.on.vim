if InitStep() == 0
  call dein#add('Shougo/neosnippet', { 'rev': 'efb2a615df2e6df9364087686dacca223fcfa16a' })
  finish
endif

let g:neosnippet#data_directory='~/.vim/cache/snippets'
let g:neosnippet#snippets_directory='~/.vim/snippets,~/.vim/snippets/java,~/.vim/snippets/javascript,~/.vim/snippets/python,~/.vim/snippets/vim,~/.vim/snippets/nim.~/.vim/snippets/robo1'
let g:neosnippet#disable_runtime_snippets = { '_' : 1 }

function! s:check_back_space()
  let col = col('.') - 1
  if col == 0
    return 1
  elseif !col
    return 0
  endif
  let char = getline('.')[col - 1]
  return char =~# '\s' || char =~# '\H'
endfunction

function! s:is_emmet_expandable()
  return exists('g:loaded_emmet_vim') && &filetype=~? 'html' && emmet#isExpandable()
endfunction

if dein#tap('neocomplete.vim')
  imap <expr><TAB> neosnippet#expandable_or_jumpable()
        \ ? "\<Plug>(neosnippet_expand_or_jump)"
        \ : pumvisible()
        \ ? "\<C-n>"
        \ : <SID>is_emmet_expandable()
        \ ? "\<Plug>(emmet-expand-abbr)"
        \ : <SID>check_back_space()
        \ ? "\<TAB>"
        \ : neocomplete#start_manual_complete()
else

  imap <expr><TAB> neosnippet#expandable_or_jumpable()
        \ ? "\<Plug>(neosnippet_expand_or_jump)"
        \ : pumvisible()
        \ ? "\<C-n>"
        \ : <SID>is_emmet_expandable()
        \ ? "\<Plug>(emmet-expand-abbr)"
        \ : "\<TAB>"

endif

smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

augroup filetype_snipp
  autocmd!
  autocmd FileType neosnippet setlocal noexpandtab
augroup END
