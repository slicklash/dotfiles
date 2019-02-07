" escape to normal mode
inoremap jj <ESC>l

" yank to end of line
nnoremap Y y$

" write & write all
nnoremap <leader>w :w!<cr>
nnoremap <leader>W :wa!<cr>

" splits
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>s <C-w>s

" change cursor position in insert mode
inoremap <C-h> <left>
inoremap <C-l> <right>

" start/end of line
nnoremap H ^
nnoremap L g_

" open new tab
nnoremap <silent> <C-N> :tabnew<CR>

" vertical auto center
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz
nnoremap <silent> <C-o> <C-o>zz
nnoremap <silent> <C-i> <C-i>zz

" navigate command history
cnoremap <C-j> <down>
cnoremap <C-k> <up>

" navigate windows
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
nnoremap <C-Tab> <C-W>w
nnoremap <S-C-Tab> <C-W>p

" manage windows
noremap <silent> <leader>co <C-W>o
noremap <silent> <leader>cc :close<CR>
noremap <silent> <leader>cw :cclose<CR>
noremap <silent> <leader>ml <C-W>L
noremap <silent> <leader>mh <C-W>H
noremap <silent> <leader>mk <C-W>K
noremap <silent> <leader>mj <C-W>J
noremap <silent> <leader>mt <C-W>

" resize windows
noremap <F9> :vertical resize -10<CR>
noremap <F10> :resize -10<CR>
noremap <F11> :resize +10<CR>
noremap <F12> :vertical resize +10<CR>
noremap <S-Left> <C-w><
noremap <S-Down> <C-w>-
noremap <S-Up> <C-w>+
nnoremap <C-Right> :vertical resize+10<CR>

" don't exit visual mode while shifting blocks
vnoremap < <gv
vnoremap > >gv

" toggle problematic whitespace
nnoremap <silent> <leader>tl :call Toggle_list()<CR>
function! Toggle_list()
    set list! list?
endfunction

" remove trailing whitespaces
nnoremap <silent> <leader>` :call Preserve("%s/\\s\\+$//e")<CR>

" surround with quotes
" nnoremap <leader>" ciw"<C-r>""<Esc>
" vnoremap <leader>" c"<C-r>""<Esc>
nnoremap <leader>' ciw'<C-r>"'<Esc>
vnoremap <leader>' c'<C-r>"'<Esc>

inoremap <expr><C-Space> <C-x><C-o>

if (IsWindows() || has('nvim'))
    nnoremap <leader>ev :vsplit $MYVIMRC<CR>
else
    nnoremap <leader>ev :vsplit `=resolve(expand($MYVIMRC))`<CR>
endif

noremap <leader>ec :vsplit ~/.vim/colors/aloneinthedark.vim<CR>

nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" echo and copy file dir
nnoremap <leader>d :call EchoHi(getcwd())<CR>
nnoremap <silent> <leader>cD :let @+=getcwd()<CR>:call EchoHi('Copied: ' . @+)<CR>

" echo and copy file path
nnoremap <silent> <leader>p :call EchoHi(substitute(expand('%:p'), getcwd(), '', ''))<CR>
nnoremap <silent> <leader>cp :let @+=expand('%:p')<CR>:call EchoHi('Copied: ' . @+)<CR>

" copy filename to clipboard
nnoremap <silent> <leader>cf :let @+=expand('%')<CR>:call EchoHi('Copied: ' . @+)<CR>
nnoremap <silent> <leader>ct :let @+=expand('%:t')<CR>:call EchoHi('Copied: ' . @+)<CR>

" alternate keyword lookup
nnoremap <silent> <space>k :call LookupKeyword()<CR>
