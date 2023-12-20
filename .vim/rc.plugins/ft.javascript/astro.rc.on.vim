if InitStep() == 0
  call dein#add('wuelnerdotexe/vim-astro', { 'rev': '9b4674ecfe1dd84b5fb9b4de1653975de6e8e2e1' })
  finish
endif

let g:astro_typescript = 'enable'
