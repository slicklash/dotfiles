if InitStep() == 0
  call dein#add('github/copilot.vim', { 'rev': '1358e8e45ecedc53daf971924a0541ddf6224faf' })
  finish
endif

let g:copilot_filetypes = { '*': v:false, 'python': v:true, 'vim': v:true, 'nim': v:true }
