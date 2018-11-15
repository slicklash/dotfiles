if InitStep() == 0
  call dein#add('Shougo/neosnippet')
  finish
endif

let g:neosnippet#data_directory='~/.vim/cache/snippets'
let g:neosnippet#snippets_directory='~/.vim/snippets,~/.vim/snippets/javascript'
let g:neosnippet#disable_runtime_snippets = { '_' : 1 }

function! s:check_back_space()
  let l:col = col('.') - 1
  if l:col == 0
    return 1
  elseif !l:col
    return 0
  endif
  let l:char = getline('.')[l:col - 1]
  return l:char =~ '\s' || l:char =~ '\H'
endfunction

function! s:is_emmet_expandable()
  return exists('g:loaded_emmet_vim') && &ft=~'html' && emmet#isExpandable()
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
