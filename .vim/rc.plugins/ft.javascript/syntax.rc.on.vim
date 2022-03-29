if InitStep() == 0
  call dein#add('pangloss/vim-javascript', { 'rev': 'd6e137563c47fb59f26ed25d044c0c7532304f18', 'on_ft' : ['javascript', 'typescript'] })
  call dein#add('maxmellon/vim-jsx-pretty', { 'rev': '6989f1663cc03d7da72b5ef1c03f87e6ddb70b41', 'on_ft' : ['jsx', 'tsx'] })
  finish
endif
