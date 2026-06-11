vim9script

set hlsearch                                # highlight search items
set incsearch                               # find as you type
set ignorecase                              # case insensitive search
set smartcase                               # case sensitive search if uppercase letters are used
set matchpairs+=<:>                         # match <> pairs

# use very magic regexp be default
nnoremap / /\v
nnoremap s /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

# stop highlighting search results
nnoremap <silent> <leader>, :nohlsearch<CR>

# replace selection
vnoremap <C-r> "hy:%s#\V<C-r>=escape(@h,'#\')<CR>##gc<left><left><left>

# replace last yanked
nnoremap <C-y> :%s#\V<C-r>=escape(@0,'#\')<CR>##gc<left><left><left>
vnoremap <C-y> :s#\V<C-r>=escape(@0,'#\')<CR>##gc<left><left><left>

# replace last searched
if has('win32')
  nnoremap <C-/> :%s#<C-r>/##gc<left><left><left>
  vnoremap <C-/> :s#<C-r>/##gc<left><left><left>
else
  nnoremap <C-_> :%s#<C-r>/##gc<left><left><left>
  vnoremap <C-_> :s#<C-r>/##gc<left><left><left>
endif

# use rg
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
  # set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

# grep to quickfix
def g:Grep(pattern: string, ...rest: list<any>)
  var dir = len(rest) > 0 ? shellescape(rest[0]) : ''
  var pat = shellescape(pattern)
  @/ = pattern
  execute 'silent grep! ' .. pat .. ' ' .. dir
  copen | redraw!
enddef

def g:GrepInProject(...rest: list<any>)
  var dir = g:GetProjectDir()
  if empty(dir)
    g:EchoHi('project_dir is not defined', 'ErrorMsg')
    return
  endif
  g:Grep(len(rest) > 0 ? rest[0] : '', dir)
enddef

nnoremap <silent> <leader>fw <cmd>call Grep(expand('<cword>'))<CR>
vnoremap <silent> <C-f> "hy:call Grep(@h)<CR>
nnoremap <silent> <leader>fp <cmd>call GrepInProject(expand('<cword>'))<CR>
vnoremap <silent> <leader>fp "hy:call GrepInProject(@h)<CR>

command! -nargs=+ GR call Grep(<q-args>)
command! -nargs=+ GP call GrepInProject(<q-args>)

# replace in quickfix files
def g:Rep(search: string, target: string)
  execute 'cfdo %s#' .. search .. '#' .. target .. '#gec | update'
enddef

vnoremap <C-t> "hy:cfdo %s#<C-r>h##gec \| update<left><left><left><left><left><left><left><left><left><left><left><left><left>
nnoremap <leader>rf :cfdo %s#<C-r>/##gec \| update<left><left><left><left><left><left><left><left><left><left><left><left><left>
