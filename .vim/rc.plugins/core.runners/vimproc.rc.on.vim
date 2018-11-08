if InitStep() == 0
    call dein#add('Shougo/vimproc.vim', { 'build': dein#util#_is_windows() ? 'tools\\update-dll-mingw' : 'make -f make_unix.mak' })
    finish
endif

