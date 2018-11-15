if exists('$TMUX')
    set clipboard=
else
    set clipboard=unnamed
endif

vnoremap <C-X> "+x
vnoremap <C-C> "+y
map <C-V>  "+gP
cmap <C-V> <C-R>+
noremap <C-Q> <C-V>
exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']


" copy/paste with system clipboard:
" vmap <Leader>y "+y
" vmap <Leader>d "+d
" nmap <Leader>p "+p
" nmap <Leader>P "+P
" vmap <Leader>p "+p
" vmap <Leader>P "+P
