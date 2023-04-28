if InitStep() == 0
  call dein#add('tpope/vim-fugitive', { 'rev': 'e6651a79facf5cc2b7c554fdc19eb8a9fe89602c' })
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

function! FuView()
  let cwd = split(getcwd(), '/')
  let curline = strpart(getline('.'), 2)
  for i in range(len(cwd) - 1)
    let prefix = join(slice(cwd, i), '/')
    if stridx(curline, prefix) == 0
      break
    endif
  endfor
  let path = '/' . join(slice(cwd, 0, i), '/') . '/' . curline
  echo path
  execute 'silent !xdg-open ' . path . '> /dev/null 2>&1 &'
  redraw!
endfunction

autocmd User FugitiveIndex nnoremap <buffer> E :call FuView()<cr>
" autocmd FileType fugitive map E :call FugitiveOpenFile()<cr>
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
