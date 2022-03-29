if InitStep() == 0
  call dein#add('cakebaker/scss-syntax.vim', { 'rev': 'bda22a93d1dcfcb8ee13be1988560d9bb5bd0fef', 'on_ft': ['scss','sass'] })
  finish
endif
