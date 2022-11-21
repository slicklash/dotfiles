if InitStep() == 0
  call dein#add('ap/vim-css-color', { 'rev': '1c4b78f5512980227ca747e76f1f6c904f2eb3dc', 'on_ft' : ['css','scss','sass','less','styl'] })
  finish
endif
