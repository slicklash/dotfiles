call dein#add('preservim/tagbar', { 'rev': 'b37b05ff1925b0b3931f031ebf88690aa0974375' })

let g:tagbar_type_zsh = {
    \ 'ctagstype' : 'zsh_hyphen',
    \ 'kinds'     : [
        \ 'f:functions',
    \ ]
\ }

function! s:setup() abort
  let g:tagbar_compact = 1
  nnoremap <leader>tt <Esc><cmd>TagbarToggle<CR><Esc>
endfunction

autocmd User InitPost ++once call s:setup()
