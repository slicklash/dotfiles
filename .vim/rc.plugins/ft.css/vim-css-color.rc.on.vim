if InitStep() == 0
  call dein#add('ap/vim-css-color', { 'rev': '8bf943681f92c81a8cca19762a1ccec8bc29098a', 'on_ft' : ['css','scss','sass','less','styl'] })
  finish
endif
