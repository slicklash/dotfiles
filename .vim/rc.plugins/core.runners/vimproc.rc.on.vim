if InitStep() == 0
  call dein#add('Shougo/vimproc.vim', { 'rev': '63a4ce0768c7af434ac53d37bdc1e7ff7fd2bece', 'build': dein#util#_is_windows() ? 'tools\\update-dll-mingw' : 'make -f make_unix.mak' })
  finish
endif

