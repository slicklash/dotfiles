if InitStep() == 0
  call dein#add('tpope/vim-fugitive')
  finish
endif

function! FugitiveOpenFile() abort
  let path = expand('<cfile>')
  if empty(path)
    return
  endif
  let cwd = split(getcwd(), '/')[-1]
  let n = stridx(path, cwd)
  let path = strpart(path, n + len(cwd) + 1)
  wincmd k
  execute printf('noswapfile vsplit %s', path)
endfunction

autocmd FileType fugitive map E :call FugitiveOpenFile()<cr>
autocmd BufReadPost fugitive://* set bufhidden=delete

nnoremap <silent> <leader>gg :Git<cr>
nnoremap <silent> <leader>gb :Gblame<CR>
" nnoremap <silent> <leader>gk :Git push<cr>
" nnoremap <silent> <leader>gj :Git pull<cr>
" nnoremap <silent> <leader>gl :Glog -10<cr>
" nnoremap <silent> <leader>gd :Gdiff<CR>
" nnoremap <silent> <leader>gc :Gcommit<CR>
" nnoremap <silent> <leader>gw :Gwrite<CR>
" nnoremap <silent> <leader>gr :Gremove<CR>
