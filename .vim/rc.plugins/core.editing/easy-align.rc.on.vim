call dein#add('junegunn/vim-easy-align', { 'rev': '9815a55dbcd817784458df7a18acacc6f82b1241' })

function! s:setup() abort
  let g:easy_align_ignore_groups = []

  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)

  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
endfunction

autocmd User InitPost ++once call s:setup()
