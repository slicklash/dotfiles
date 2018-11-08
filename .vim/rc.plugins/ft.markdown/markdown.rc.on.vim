if InitStep() == 0
  call dein#add('tpope/vim-markdown', { 'on_ft': ['markdown'] })
  finish
endif

let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'javascript', 'typescript']
