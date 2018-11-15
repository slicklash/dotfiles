if InitStep() == 0
  call dein#add('HerringtonDarkholme/yats.vim', { 'on_ft' : ['typescript', 'markdown'] } )
  finish
endif
