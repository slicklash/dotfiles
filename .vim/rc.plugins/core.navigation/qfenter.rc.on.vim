if InitStep() == 0
    call dein#add('yssl/QFEnter')
    finish
endif

let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>']
let g:qfenter_keymap.vopen = ['E']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>']
let g:qfenter_keymap.topen = ['<C-t>']

function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
endfunction

autocmd FileType qf map <silent> <buffer> dd :call RemoveQFItem()<cr>
