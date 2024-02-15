if InitStep() == 0
  call dein#add('ap/vim-css-color', { 'rev': 'faa65935660a4596414fe21d57e2110faeb9e869', 'on_ft' : ['css','scss','sass','less','styl'] })
  finish
endif
