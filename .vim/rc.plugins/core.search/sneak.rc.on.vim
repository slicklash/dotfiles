if InitStep() == 0
  call dein#add('justinmk/vim-sneak', { 'rev': '29ec9167d4a609f74c130b46265aa17eb2736e6a' })
  let g:sneak#streak = 1
  finish
endif

