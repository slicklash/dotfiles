if InitStep() == 0
  call dein#add('tsukkee/unite-tag')
  finish
elseif !dein#tap('unite.vim')
  finish
endif
