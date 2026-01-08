call dein#add('preservim/tagbar', { 'rev': '7bfffca1f121afb7a9e38747500bf5270e006bb1', 'on_cmd' : 'TagbarToggle' })

function! s:setup() abort
  let g:tagbar_compact = 1
  nnoremap <leader>tt <Esc><cmd>TagbarToggle<CR><Esc>
endfunction

autocmd User InitPost ++once call s:setup()
