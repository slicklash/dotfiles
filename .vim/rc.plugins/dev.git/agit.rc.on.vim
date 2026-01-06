call dein#add('cohama/agit.vim', { 'rev': '8b168d347bc746f772ac99e461099ca20ff12582' })

function! s:setup() abort
  nnoremap <silent> <leader>gh <cmd>Agit<CR>
endfunction

autocmd User InitPost ++once call s:setup()
