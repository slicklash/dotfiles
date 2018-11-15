if InitStep() == 0
  call dein#add('leafgarland/typescript-vim', { 'on_ft' : ['typescript', 'markdown'] } )
  finish
endif
