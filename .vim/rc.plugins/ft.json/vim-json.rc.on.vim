if !executable('jq')
  echo 'Error: missing jq'
  cquit
endif

function! s:setup() abort
  autocmd BufRead,BufNewFile .eslintrc set filetype=json
  autocmd FileType json setlocal formatprg=jq\ . | setlocal sw=2

  nnoremap <leader>J <cmd>set ft=json<BAR>%!jq '.'<cr>
endfunction

autocmd User InitPost ++once cal s:setup()
