if InitStep() == 0
  call dein#add('neovimhaskell/haskell-vim', { 'on_ft': [ 'haskell' ] })
  finish
endif

" TODO:
" http://seanhess.github.io/2015/08/05/practical-haskell-editors.html
" ghc-mod
" hoogle
" hdevtools
" hlint
" pointfree
" textobj-indent
" lushtags
" repl.vim
" haskell.vim
" lhaskell.vim
" vim-haskellFold
" enomsg/vim-haskellConcealPlus
" eagletmt/ghcmod-vim
" bitc/vim-hdevtools
" eagletmt/neco-ghc
" Twinside/vim-hoogle
