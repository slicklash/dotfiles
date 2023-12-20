if InitStep() == 0
  call dein#add('ap/vim-css-color', { 'rev': '6cc65734bc7105d9677ca54e2255fcbc953ba6bf', 'on_ft' : ['css','scss','sass','less','styl'] })
  finish
endif
