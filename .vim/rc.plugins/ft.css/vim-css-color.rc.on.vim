if InitStep() == 0
  call dein#add('ap/vim-css-color', { 'on_ft' : ['css','scss','sass','less','styl'] })
  finish
endif
