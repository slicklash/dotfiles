if InitStep() == 0
  call dein#add('groenewege/vim-less', { 'on_ft' : ['less'] })
  finish
endif
