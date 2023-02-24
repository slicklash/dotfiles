if InitStep() == 0
  call dein#add('Shougo/vimproc.vim', { 'rev': 'bf06f3f9bb1b60542fccde1ed7499798d1154db6', 'build': dein#util#_is_windows() ? 'tools\\update-dll-mingw' : 'make -f make_unix.mak' })
  finish
endif

