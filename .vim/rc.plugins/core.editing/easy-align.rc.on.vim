if InitStep() == 0
    call dein#add('junegunn/vim-easy-align')
    finish
endif

" let g:easy_align_ignore_groups = ['Comment', 'String']
let g:easy_align_ignore_groups = []

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
