set hlsearch                                " highlight search items
set incsearch                               " find as you type
set ignorecase                              " case insensitive search
set smartcase                               " case sensitive search if uppercase letters are used
set matchpairs+=<:>                         " match <> pairs
set iskeyword+=-

" use very magic regexp be default
nnoremap / /\v
nnoremap s /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

" stop highlighting search results
nnoremap <silent> <leader>, <cmd>nohlsearch<CR>

" replace selection
vnoremap <C-r> "hy:%s#\V<C-r>=escape(@h,'#\')<CR>##gc<left><left><left>

" replace last yanked
nnoremap <C-y> :%s#\V<C-r>=escape(@0,'#\')<CR>##gc<left><left><left>
vnoremap <C-y> :s#\V<C-r>=escape(@0,'#\')<CR>##gc<left><left><left>

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
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
  " set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" grep to quickfix
function! Grep(pattern, ...) abort
  let l:dir = a:0 > 0 ? shellescape(a:1) : ''
  let l:pat = shellescape(a:pattern)
  let @/ = a:pattern
  execute 'silent grep! ' . l:pat . ' ' . l:dir
  copen | redraw!
endfunction

function! GrepInProject(...) abort
  let dir = GetProjectDir()
  if empty(dir)
    return EchoHi('project_dir is not defined', 'ErrorMsg')
  endif
  call Grep(a:0 > 0 ? a:1 : '', dir)
endfunction

nnoremap <silent> <leader>fw <cmd>call Grep(expand('<cword>'))<CR>
vnoremap <silent> <C-f> "hy:<cmd>call Grep(@h)<CR>
nnoremap <silent> <leader>fp <cmd>call GrepInProject(expand('<cword>'))<CR>
vnoremap <silent> <leader>fp "hy:<cmd>call GrepInProject(@h)<CR>

command! -nargs=+ GR call Grep(<q-args>)
command! -nargs=+ GP call GrepInProject(<q-args>)

" replace in quickfix files
function! Rep(search, target) abort
  execute 'cfdo %s#' . a:search . '#' . a:target . '#gec | update'
endfunction

vnoremap <C-t> "hy:cfdo %s#<C-r>h##gec \| update<left><left><left><left><left><left><left><left><left><left><left><left><left>
nnoremap <leader>rf :cfdo %s#<C-r>/##gec \| update<left><left><left><left><left><left><left><left><left><left><left><left><left>
