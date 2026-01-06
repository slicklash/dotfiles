" escape to normal mode
inoremap jj <ESC>l

" yank to end of line
nnoremap Y y$
" past last yank
nnoremap <leader>y "0P

" write & write all
nnoremap <leader>w <cmd>w!<CR>
nnoremap <leader>W <cmd>wa!<CR>

" splits
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>s <C-w>s<C-w>j

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

" manage windows
nnoremap <silent> <leader>co <C-W>o
nnoremap <silent> <leader>cc <cmd>close<CR>
nnoremap <silent> <leader>cw <cmd>cclose<CR>
nnoremap <silent> <leader>ml <C-W>L
nnoremap <silent> <leader>mh <C-W>H
nnoremap <silent> <leader>mk <C-W>K
nnoremap <silent> <leader>mj <C-W>J

" resize windows
nnoremap <silent> <F9>  <cmd>vertical resize -10<CR>
nnoremap <silent> <F10> <cmd>resize -10<CR>
nnoremap <silent> <F11> <cmd>resize +10<CR>
nnoremap <silent> <F12> <cmd>vertical resize +10<CR>

noremap <S-Left> <C-w><
noremap <S-Down> <C-w>-
noremap <S-Up> <C-w>+
nnoremap <C-Right> :vertical resize+10<CR>

" don't exit visual mode while shifting blocks
vnoremap < <gv
vnoremap > >gv

" toggle problematic whitespace
nnoremap <silent> <leader>tl <cmd>call Toggle_list()<CR>
function! Toggle_list()
  set list!
  set list?
endfunction

" remove trailing whitespaces
nnoremap <silent> <leader>` <cmd>call Preserve("%s/\\s\\+$//e")<CR>

" surround with quotes
" nnoremap <leader>" ciw"<C-r>""<Esc>
" vnoremap <leader>" c"<C-r>""<Esc>
nnoremap <leader>' ciw'<C-r>"'<Esc>
vnoremap <leader>' c'<C-r>"'<Esc>

" inoremap <expr><C-Space> <C-x><C-o>
inoremap <C-Space> <C-x><C-o>

if (has('win32') || has('nvim'))
  nnoremap <leader>ev <cmd>vsplit $MYVIMRC<CR>
else
  nnoremap <leader>ev <cmd>vsplit `=resolve(expand($MYVIMRC))`<CR>
endif

nnoremap <leader>ec <cmd>vsplit ~/.vim/colors/aloneinthedark.vim<CR>
nnoremap <leader>eg <cmd>vsplit ~/.config/ghostty/config<CR>

nnoremap <leader>cd <cmd>cd %:p:h<CR><cmd>pwd<CR>

" echo and copy file dir
nnoremap <leader>d <cmd>call EchoHi(getcwd())<CR>
nnoremap <silent> <leader>cD <cmd>let @+=getcwd()<CR><cmd>call EchoHi('Copied: ' . @+)<CR>

" echo and copy file path
nnoremap <silent> <leader>p <cmd>call EchoHi(substitute(expand('%:p'), getcwd(), '', ''))<CR>
nnoremap <silent> <leader>cp <cmd>let @+=expand('%:p')<CR><cmd>call EchoHi('Copied: ' . @+)<CR>

" copy filename to clipboard
nnoremap <silent> <leader>cf <cmd>let @+=expand('%')<CR><cmd>call EchoHi('Copied: ' . @+)<CR>
nnoremap <silent> <leader>ct <cmd>let @+=expand('%:t')<CR><cmd>call EchoHi('Copied: ' . @+)<CR>

" alternate keyword lookup
nnoremap <silent> <space>k <cmd>call LookupKeyword()<CR><cmd>redraw!<CR>

nnoremap <silent> XX <cmd>call DeleteFile()<cr>
vnoremap <silent> XX <cmd>call DeleteFiles()<cr>
