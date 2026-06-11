vim9script

dein#add('preservim/tagbar', {'rev': 'b37b05ff1925b0b3931f031ebf88690aa0974375'})

g:tagbar_type_zsh = {
      \ 'ctagstype': 'zsh_hyphen',
      \ 'kinds': ['f:functions'],
      \ }

def Setup()
  g:tagbar_compact = 1
  nnoremap <leader>tt <Esc><cmd>TagbarToggle<CR><Esc>
enddef

autocmd User InitPost ++once Setup()
