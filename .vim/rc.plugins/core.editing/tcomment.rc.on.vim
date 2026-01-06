call dein#add('tomtom/tcomment_vim', { 'rev': '48ab639a461d9b8344f7fee06cb69b4374863b13' })

function! s:setup() abort
  noremap <leader>u <cmd>TComment<CR>
  noremap <leader>k <cmd>TComment<CR>
endfunction

autocmd User InitPost ++once call s:setup()

