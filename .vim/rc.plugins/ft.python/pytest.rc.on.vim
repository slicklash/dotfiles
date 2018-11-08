if InitStep() == 0
    " call dein#add('alfredodeza/pytest.vim', { 'on_ft' : ['python'] })
    finish
endif

let g:test#python#pyunit#file_pattern='\v.*.py'
let g:test#python#pyunit#executable='python3 -m unittest'
let g:test#filename_modifier = ':p'


let test#strategy = {
  \ 'nearest': 'vimproc',
  \ 'file':    'basic',
  \ 'suite':   'basic',
\}

nnoremap <leader>tr :TestNearest<CR>
nnoremap <leader>tf :TestFile<CR>
nnoremap <leader>tc :!coverage run % && coverage html && chromium-browser htmlcov/index.html<cr>

" syntax case ignore
" syntax match ok /\s\(ok\|pass\(ed\|\>\)\)/
" syntax match fail /fail\(s\|ed\|ures!\|ures\|ure\|:\|\>\)/
" syntax match errors /^error\|\.\serror/
" syntax match assert /assertionerror:/
" syntax match pyendpass /\s(\d\+\s\(tests\|test\)\spassed)/
" syntax match pyendfail /\d\+\s\(failed\(,\|\>\)\|error\)/
"
" highlight ok ctermfg=DarkGreen guifg=DarkGreen guibg=White
" highlight fail ctermfg=DarkRed guifg=DarkRed guibg=White
" highlight errors ctermfg=DarkRed guifg=DarkRed guibg=White
" highlight assert ctermfg=DarkRed guifg=DarkRed guibg=White
"
" highlight pyendpass ctermfg=DarkGreen guifg=DarkGreen guibg=White
" highlight pyendfail ctermfg=DarkRed guifg=DarkRed guibg=White
