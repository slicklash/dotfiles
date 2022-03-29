if InitStep() == 0
  call dein#add('maksimr/vim-jsbeautify', { 'rev': 'e4586884c8e54218a92d66f2ebc3fefc46315057', 'on_ft' : ['javascript', 'typescript', 'vim', 'json', 'xml', 'html'] })
  finish
endif

function! _js_beautify()
  if &filetype != 'javascript'
    set ft=javascript
    call dein#source('maksimr/vim-jsbeautify')
  endif
  call JsBeautify()
endfunction

nnoremap <leader>fj :call _js_beautify()<cr>
