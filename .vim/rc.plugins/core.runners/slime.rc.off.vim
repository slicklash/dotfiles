if InitStep() == 0
  call dein#add('jpalardy/vim-slime')
  finish
endif

let g:slime_target = 'tmux'
let g:slime_no_mappings = 1
let g:slime_python_ipython = 1

