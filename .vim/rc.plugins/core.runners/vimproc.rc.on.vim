if InitStep() == 0
  call dein#add('Shougo/vimproc.vim', { 'rev': 'f396529d7868b43d88978eb347bb203353991184', 'build': dein#util#_is_windows() ? 'tools\\update-dll-mingw' : 'make -f make_unix.mak' })
  finish
endif

