vim9script

dein#add('preservim/tagbar', {'rev': '07cb8247487208124978daff8e13624667635457'})

g:tagbar_type_zsh = {
      \ 'ctagstype': 'zshhyphen',
      \ 'kinds': ['f:functions'],
      \ }

def Setup()
  g:tagbar_compact = 1
  nnoremap <leader>tt <Esc><cmd>TagbarToggle<CR><Esc>
enddef

autocmd User InitPost ++once Setup()
