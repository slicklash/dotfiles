if InitStep() == 0
  call dein#local("~/code", {}, ['unite-gulp'])
  finish
endif

nnoremap <silent> <Space>t :Unite -silent -buffer-name=gulp gulp<CR>
nnoremap <silent> <Space>l :call unite#sources#gulp#repeat()<CR>
nnoremap <silent> <Space>T :Unite -silent -buffer-name=gulp gulp:refresh<CR>
