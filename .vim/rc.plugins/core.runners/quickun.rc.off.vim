if InitStep() == 0
  call dein#add('thinca/vim-quickrun')
  let g:quickrun_config = {}
  let g:quickrun_config._ = {'runner' : 'vimproc'}
  finish
endif
