if InitStep() == 0
  if !has('python3')
    echo 'Error while processing ' . resolve(expand('<sfile>:p'))
    echo 'Error: missing +python3'
    cquit
  endif
  try
    python3 import pynvim
  catch
    echo 'Error while processing ' . resolve(expand('<sfile>:p'))
    echo 'Error: missing python3 package [pynvim]'
    cquit
  endtry
  call dein#add('Shougo/deoplete.nvim', { 'rev': '82db30626e411e99b0274b8d6c99bce561cb0394' })
  if !has('nvim')
    call dein#add('roxma/nvim-yarp', { 'rev': 'bb5f5e038bfe119d3b777845a76b0b919b35ebc8' })
    call dein#add('roxma/vim-hug-neovim-rpc', { 'rev': '93ae38792bc197c3bdffa2716ae493c67a5e7957' })
  endif
  finish
endif

let g:deoplete#enable_at_startup = 1

call deoplete#custom#var('file', 'enable_buffer_path', v:true)
call deoplete#custom#option('auto_refresh_delay', 300)
call deoplete#custom#option('max_list', 25)

" let g:deoplete#enable_debug = 1
" let g:deoplete#enable_profile = 1
" call deoplete#enable_logging('DEBUG', '/home/slicklash/tmp/deoplete.log')

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return deoplete#close_popup() . "\<CR>"
endfunction
