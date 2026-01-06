call dein#add('tpope/vim-fugitive', { 'rev': '61b51c09b7c9ce04e821f6cf76ea4f6f903e3cf4' })

function! s:setup() abort
  nnoremap <silent> <leader>gg <cmd>Git<cr>
  nnoremap <silent> <leader>gb <cmd>Gblame<CR>
endfunction

autocmd User InitPost ++once call s:setup()

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

autocmd User FugitiveIndex nnoremap <buffer> E <cmd>call FuView()<cr>
autocmd BufReadPost fugitive://* set bufhidden=delete
