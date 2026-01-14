" change leader key
let mapleader = ","
nnoremap <C-E> ,

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

" start/end of line
nnoremap H ^
nnoremap L g_

" open new tab
nnoremap <silent> <C-n> :tabnew<CR>

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
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" manage windows
nnoremap <silent> <leader>co <C-w>o
nnoremap <silent> <leader>cc <cmd>close<CR>
nnoremap <silent> <leader>cw <cmd>cclose<CR>
nnoremap <silent> <leader>ml <C-w>L
nnoremap <silent> <leader>mh <C-w>H
nnoremap <silent> <leader>mk <C-w>K
nnoremap <silent> <leader>mj <C-w>J

" resize windows
noremap <S-Left> <cmd>vertical resize -10<CR>
noremap <S-Right> <cmd>vertical resize +10<CR>
noremap <S-Down> <cmd>resize -10<CR>
noremap <S-Up> <cmd>resize +10<CR>

" don't exit visual mode while shifting blocks
vnoremap < <gv
vnoremap > >gv

" vimdiff
nnoremap <silent> gr <cmd>diffget REMOTE<CR>
nnoremap <silent> gl <cmd>diffget LOCAL<CR>
nnoremap <silent> <leader>do <cmd>windo diffthis<CR>
nnoremap <silent> <leader>dc <cmd>diffoff<CR>

" toggle problematic whitespace
nnoremap <silent> <leader>tl <cmd>call Toggle_list()<CR>
function! Toggle_list()
  set list!
  set list?
endfunction

" remove trailing whitespaces
nnoremap <silent> <leader>` <cmd>call Preserve("%s/\\s\\+$//e")<CR>

" surround with quotes
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

augroup special_windows
  autocmd!
  autocmd FileType qf,fugitive wincmd J
  autocmd FileType help,fugitive,git
        \ nnoremap <buffer> q <Cmd>close<CR>
augroup END
