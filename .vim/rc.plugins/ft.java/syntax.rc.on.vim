call dein#add('uiiaoo/java-syntax.vim', { 'rev': 'eb7b01237d0752f98a521f51c8daca760ddf082e', 'on_ft': ['java'] })

augroup filtype_java
  autocmd!
  autocmd FileType java  call s:ft_java()
augroup END

function! s:ft_java() abort
  let b:keyword_lookup_url='https://docs.oracle.com/search/?q=%s'
endfunction
