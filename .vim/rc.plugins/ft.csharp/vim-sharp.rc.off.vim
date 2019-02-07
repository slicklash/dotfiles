if InitStep() == 0
    call dein#add('OrangeT/vim-csharp', { 'on_ft': ['csharp', 'cs', 'cshtml'] })
    finish
endif
