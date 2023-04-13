if InitStep() == 0
  call dein#add('github/copilot.vim', { 'rev': 'b6e5624351ba735e25eb8864d7d22819aad00606' })
  finish
endif

let g:copilot_filetypes = { '*': v:false, 'python': v:true }
