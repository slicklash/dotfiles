if InitStep() == 0
  call dein#add('neovimhaskell/haskell-vim', { 'on_ft': [ 'haskell' ] })
  finish
endif
