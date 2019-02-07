if InitStep() == 0
  call dein#add('vim-python/python-syntax')
  finish
endif

let g:python_highlight_all = 1
