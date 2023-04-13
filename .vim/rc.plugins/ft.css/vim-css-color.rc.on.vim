if InitStep() == 0
  call dein#add('ap/vim-css-color', { 'rev': '5687a7978bc80263cd03d0a667c2f56890cfb940', 'on_ft' : ['css','scss','sass','less','styl'] })
  finish
endif
