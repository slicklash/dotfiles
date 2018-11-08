if InitStep() == 0
    call dein#add('yardnsm/vim-import-cost', { 'build': 'npm install' })
    finish
endif
