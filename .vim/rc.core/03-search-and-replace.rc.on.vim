set hlsearch                                " highlight search items
set incsearch                               " find as you type
set ignorecase                              " case insensitive search
set smartcase                               " case sensitive search if uppercase letters are used
set matchpairs+=<:>                         " match <> pairs

" use very magic regexp be default
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

" stop highlighting search results
nnoremap <silent> <leader>, :silent noh<CR>

" replace selection
vnoremap <C-r> "hy:%s#<C-r>h##gc<left><left><left>

" replace last yanked
nnoremap <C-y> :%s#<C-r>0##gc<left><left><left>
vnoremap <C-y> :s#<C-r>0##gc<left><left><left>

" replace last searched
if has('win32')
  nnoremap <C-/> :%s#<C-r>/##gc<left><left><left>
  vnoremap <C-/> :s#<C-r>/##gc<left><left><left>
else
  nnoremap <C-_> :%s#<C-r>/##gc<left><left><left>
  vnoremap <C-_> :s#<C-r>/##gc<left><left><left>
endif

" use rg
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" grep to quickfix
function! Grep(cword, ...) abort
  let dir = a:0 > 0 ? '"' . a:1 . '"' : ''
  let @/ = a:cword
  execute 'silent! grep! "' . @/ . '" ' . dir . ' | copen | redraw! '
endfunction

function! GrepInProject(...) abort
  let dir = GetProjectDir()
  if empty(dir)
    return EchoHi('project_dir is not defined', 'ErrorMsg')
  endif
  call Grep(a:0 > 0 ? a:1 : '', dir)
endfunction

nnoremap <silent> <leader>fw :call Grep(expand('<cword>'))<cr>
vnoremap <C-f> "hy:call Grep(@h)<cr>
nnoremap <silent> <leader>fp :call GrepInProject(expand('<cword>'))<cr>
vnoremap <silent> <leader>fp "hy:call GrepInProject(@h)<cr>
command! -nargs=+ GR call Grep(<q-args>)
command! -nargs=+ GP call GrepInProject(<q-args>)

" replace in quickfix files
function! Rep(search, target) abort
  execute 'cfdo %s#' . a:search . '#' . a:target . '#gec | update'
endfunction
vnoremap <C-h> "hy:cfdo %s#<C-r>h##gec \| update<left><left><left><left><left><left><left><left><left><left><left><left><left>
nnoremap <leader>rf :cfdo %s#<C-r>/##gec \| update<left><left><left><left><left><left><left><left><left><left><left><left><left>
