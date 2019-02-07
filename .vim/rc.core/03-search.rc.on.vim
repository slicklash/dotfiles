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

if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

packadd cfilter

" search to quickfix
function! Grep(cword) abort
  let @/ = a:cword
  execute 'silent! grep! "' . @/ . '" | copen | redraw! '
endfunction
nnoremap <silent> <leader>fw :call Grep(expand('<cword>'))<cr>
vnoremap <C-f> "hy:call Grep(@h)<cr>
command! -nargs=+ G call Grep(<q-args>)

" replace in quickfix files
function! Rep(search, target) abort
  execute 'cfdo %s#' . a:search . '#' . a:target . '#gec | update'
endfunction
vnoremap <C-h> "hy:cfdo %s#<C-r>h##gec \| update<left><left><left><left><left><left><left><left><left><left><left><left><left>
nnoremap <leader>rf :cfdo %s#<C-r>/##gec \| update<left><left><left><left><left><left><left><left><left><left><left><left><left>

command! UpdateQF call setqflist(map(getqflist(), 'extend(v:val, {"text":get(getbufline(v:val.bufnr, v:val.lnum),0)})'))

function! SearchIn(dir, ...) abort
  let l:pattern = a:0 > 0 ? a:1 : ''
  call denite#start([{ 'name': 'grep','args': [a:dir, '', l:pattern]}], {
        \ 'buffer_name': 'grep',
        \ 'direction': 'botright',
        \ })
endfunction

" vimfiler actions

let s:action_search = { 'is_selectable' : 0 }
function! s:action_search.func(candidates) abort
  let l:dir = a:candidates.action__path . '/'
  call SearchIn(l:dir)
endfunction

let s:action_search_last = { 'is_selectable' : 0 }
function! s:action_search_last.func(candidates) abort
  let l:dir = a:candidates.action__path . '/'
  let l:pattern = substitute(@/, '^\\v', '', '')
  let l:pattern = substitute(l:pattern, '^\\<\(.\+\)\\>$', '\1', '')
  call SearchIn(l:dir, l:pattern)
endfunction

let s:action_search_yank = { 'is_selectable' : 0 }
function! s:action_search_yank.func(candidates) abort
  let l:dir = a:candidates.action__path . '/'
  call SearchIn(l:dir, @0)
endfunction

if dein#tap('unite.vim')
  call unite#custom#action('directory', 'search', s:action_search)
  call unite#custom#action('directory', 'search_last', s:action_search_last)
  call unite#custom#action('directory', 'search_yank', s:action_search_yank)
endif
