if InitStep() == 0
  call dein#add('Shougo/vimproc.vim', { 'rev': '3ba46c01109bc590c6740c1133f53584751924b2', 'build': dein#util#_is_windows() ? 'tools\\update-dll-mingw' : 'make -f make_unix.mak' })
  finish
endif

