if InitStep() == 0
  finish
endif

augroup filetype_js_ts
  autocmd!
  autocmd FileType * call s:ft_js_ts()
augroup END

autocmd BufRead,BufNewFile .eslintrc set filetype=json

function! s:ft_js_ts() abort
  if &filetype !~? '\(javascript\|typescript\)'
    return
  endif

  nnoremap <buffer> K :call LanguageClient#textDocument_hover()<CR>
  nnoremap <buffer> <silent><leader>i :call<SID>import()<cr>

  setlocal shiftwidth=2

  if &filetype =~? 'javascript'
    setlocal filetype=javascript.jsx
    setlocal formatprg=prettier\ --stdin\ --parser\ babylon
  elseif &filetype =~? 'typescript'
    setlocal filetype=typescript.tsx
    setlocal formatexpr=
    setlocal formatprg=prettier\ --stdin\ --parser\ typescript
  endif

endfunction

let s:know_imports = {
      \  'UI': 'editor-ui-lib',
      \  'UIx': ['{UI}', 'editor-ui-lib']
      \}

function! s:import() abort

  let l:cw = expand('<cword>')
  let l:known = get(s:know_imports, l:cw, v:none)

  if type(l:known) == v:t_none
    JsFileImport
    return
  endif

  let l:last_view = winsaveview()
  let l:last_search = getreg('/')
  let l:l = line('.')
  let l:c = col('.')

  normal gg}

  if type(l:known) == v:t_string
    let l:import = printf("import %s from '%s';", l:cw, l:known)
  else
    let l:import = printf("import %s from '%s';'", l:known[0], l:known[1])
  endif

  call setline('.', l:import)
  normal o

  call winrestview(l:last_view)
  call cursor(l:l + 1, l:c)
  call setreg('/', l:last_search)

endfunction
