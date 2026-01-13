if has('clipboard') && !exists('$TMUX')
  set clipboard=unnamedplus
endif

if exists('$TERMUX_VERSION')
  vnoremap <silent> <C-c> :w !termux-clipboard-set<CR><CR>
  nnoremap <silent> <C-v> :r !termux-clipboard-get<CR>
else
  vnoremap <silent> <C-x> "+x
  vnoremap <silent> <C-c> "+y
  nnoremap <silent> <C-v> "+p
  inoremap <silent> <C-v> <C-r>+
endif

cnoremap <C-v> <C-R>+
nnoremap <C-q> <C-V>
vnoremap <C-q> <C-V>

if exists('*paste#paste_cmd')
  execute 'inoremap <script> <C-V>' paste#paste_cmd['i']
  execute 'vnoremap <script> <C-V>' paste#paste_cmd['v']
endif
