if InitStep() == 0
    call dein#add('tsukkee/unite-tag')
elseif !dein#tap('unite.vim')
    finish
endif
