if InitStep() == 0
  call dein#add('ludovicchabant/vim-gutentags')
  call dein#add('kristijanhusak/vim-js-file-import')
  finish
endif

let g:gutentags_cache_dir = _cache_dir('gutentags')
let g:gutentags_file_list_command = 'rg --files'
let g:gutentags_generate_on_new = 0
let g:gutentags_project_root_finder = 'GutenTagsProjectRootFinder'
let g:gutentags_define_advanced_commands = 1
let g:gutentags_init_user_func = 'GutenTagsInit'

function! GutenTagsProjectRootFinder(path) abort
  if &filetype =~ 'script'
    let file = ale#path#FindNearestFile(bufnr('%'), 'package.json')
    if !empty(file)
      return fnamemodify(file, ':p:h')
    endif
  endif
  let g:gutentags_project_root_finder = ''
  let path = gutentags#get_project_root(a:path)
  let g:gutentags_project_root_finder = 'GutenTagsProjectRootFinder'
  return path
endfunction

function! GutenTagsInit(path) abort
  if a:path =~ '\(fugitive\|.git/index\)'
    return 0
  endif
  return 1
endfunction

