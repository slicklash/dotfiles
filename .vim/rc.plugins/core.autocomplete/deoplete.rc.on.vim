if InitStep() == 0
  if !has('python3')
    echo 'Error while processing ' . resolve(expand('<sfile>:p'))
    echo 'Error: missing +python3'
    cquit
  endif
  try
    python3 import neovim
  catch
    echo 'Error while processing ' . resolve(expand('<sfile>:p'))
    echo 'Error: missing python3 package [neovim]'
    cquit
  endtry
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
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
