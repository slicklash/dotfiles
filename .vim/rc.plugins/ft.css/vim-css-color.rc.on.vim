if InitStep() == 0
  call dein#add('ap/vim-css-color', { 'rev': '950e80352b325ff26d3b0faf95b29e301c200f7d', 'on_ft' : ['css','scss','sass','less','styl'] })
  finish
endif
