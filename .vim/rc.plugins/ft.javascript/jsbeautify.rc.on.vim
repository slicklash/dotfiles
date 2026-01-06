call dein#add('maksimr/vim-jsbeautify', { 'rev': 'e4586884c8e54218a92d66f2ebc3fefc46315057', 'on_ft' : ['javascript', 'typescript', 'vim', 'json', 'xml', 'html'] })

function! _js_beautify()
  if &filetype != 'javascript'
    set ft=javascript
    call dein#source('maksimr/vim-jsbeautify')
  endif
  call JsBeautify()
endfunction

function! s:setup() abort
  nnoremap <leader>fj <cmd>call _js_beautify()<cr>
endfunction

autocmd User InitPost ++once call s:setup()
