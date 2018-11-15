if InitStep() == 0
  call dein#add('davidhalter/jedi-vim', { 'on_ft': ['python'] })
  finish
endif

let g:jedi#use_tabs_not_buffers = 0
let g:jedi#use_splits_not_buffers = "right"
let g:jedi#force_py_version = 3
let g:jedi#popup_on_dot = 0
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#goto_definitions_command = "<leader>gd"
let g:jedi#goto_assignments_command = "<leader>ga"
let g:jedi#rename_command = "<leader>rn"
let g:jedi#usages_command = "<leader>fr"

augroup filtype_py_jedi
  autocmd!
  autocmd FileType python setlocal omnifunc=jedi#completions
augroup END
