if InitStep() == 0
  call dein#add('elzr/vim-json', { 'rev': '3727f089410e23ae113be6222e8a08dd2613ecf2', 'filetypes' : ['json'] })
  finish
endif

let g:vim_json_syntax_conceal = 0

autocmd BufRead,BufNewFile .eslintrc set filetype=json
autocmd FileType json setlocal formatprg=jq\ .

nnoremap <leader>J :set ft=json<BAR>%!jq '.'<cr>
