if InitStep() == 0
  call dein#add('pangloss/vim-javascript', { 'rev': 'b26c9edb3563e02f5c0b20580f7cf9743e95b157', 'on_ft' : ['javascript', 'typescript'] })
  call dein#add('maxmellon/vim-jsx-pretty', { 'rev': '6989f1663cc03d7da72b5ef1c03f87e6ddb70b41', 'on_ft' : ['jsx', 'tsx'] })
  finish
endif
