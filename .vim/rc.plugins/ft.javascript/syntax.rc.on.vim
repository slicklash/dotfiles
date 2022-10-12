if InitStep() == 0
  call dein#add('pangloss/vim-javascript', { 'rev': 'c470ce1399a544fe587eab950f571c83cccfbbdc', 'on_ft' : ['javascript', 'typescript'] })
  call dein#add('maxmellon/vim-jsx-pretty', { 'rev': '6989f1663cc03d7da72b5ef1c03f87e6ddb70b41', 'on_ft' : ['jsx', 'tsx'] })
  finish
endif
