vim9script

dein#add('Shougo/neosnippet', {'rev': 'efb2a615df2e6df9364087686dacca223fcfa16a'})

def Setup()
  g:neosnippet#data_directory = g:vim_cache_dir .. '/snippets'
  g:neosnippet#snippets_directory = '~/.vim/snippets,~/.vim/snippets/java,~/.vim/snippets/javascript,~/.vim/snippets/python,~/.vim/snippets/vim,~/.vim/snippets/nim,~/.vim/snippets/robo1'
  g:neosnippet#disable_runtime_snippets = {'_': 1}

  imap <expr><TAB> neosnippet#expandable_or_jumpable()
        \ ? "\<Plug>(neosnippet_expand_or_jump)"
        \ : pumvisible()
        \ ? "\<C-n>"
        \ : "\<TAB>"

  smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
enddef

autocmd User InitPost ++once Setup()

augroup ft_neosnippet
  autocmd!
  autocmd FileType neosnippet setlocal noexpandtab
augroup END
