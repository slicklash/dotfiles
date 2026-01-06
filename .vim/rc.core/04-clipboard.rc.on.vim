if has('clipboard') && !exists('$TMUX')
  set clipboard=unnamedplus
endif

if exists('$TERMUX_VERSION')
  vnoremap <silent> <C-C> :w !termux-clipboard-set<CR><CR>
  nnoremap <silent> <C-V> :r !termux-clipboard-get<CR>
else
  vnoremap <silent> <C-X> "+x
  vnoremap <silent> <C-C> "+y
  nnoremap <silent> <C-V> "+p
  inoremap <silent> <C-V> <C-r>+
endif

cnoremap <C-V> <C-R>+
nnoremap <C-Q> <C-V>
vnoremap <C-Q> <C-V>

if exists('*paste#paste_cmd')
  execute 'inoremap <script> <C-V>' paste#paste_cmd['i']
  execute 'vnoremap <script> <C-V>' paste#paste_cmd['v']
endif
