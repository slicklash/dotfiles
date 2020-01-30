if InitStep() == 0
  finish
endif

augroup filetype_js_ts
  autocmd!
  autocmd FileType * call s:ft_js_ts()
augroup END

function! s:ft_js_ts() abort
  if &filetype !~? '\(javascript\|typescript\)'
    return
  endif

  nnoremap <buffer> K :call LanguageClient#textDocument_hover()<CR>
  nnoremap <buffer> <silent><leader>i :call<SID>import()<cr>

  setlocal shiftwidth=2
  let b:keyword_lookup_url='https://developer.mozilla.org/en-US/search?q=%s&topic=js'

  if &filetype =~? 'javascript'
    setlocal filetype=javascript.jsx
    setlocal formatprg=prettier\ --stdin\ --parser\ babel
  elseif &filetype =~? 'typescript'
    setlocal filetype=typescript.tsx
    setlocal formatexpr=
    setlocal formatprg=prettier\ --stdin\ --parser\ typescript\ --single-quote\ --trailing-comma\ es5
    " syntax clear typescriptParamImpl
    " syntax match  javaScriptTemplateDelim    "\${\|}" contained
    " syntax region javaScriptTemplateVar      start=+${+ end=+}+                        contains=javaScriptTemplateDelim keepend
    " syntax region javaScriptTemplateString   start=+`+  skip=+\\\(`\|$\)+  end=+`+     contains=javaScriptTemplateVar,javaScriptSpecial keepend
    " syn clear typescriptObjectLabel
    " syn clear typescriptObjectLiteral
    syntax keyword typescriptSpecMethod describe it context test expect nextgroup=typescriptFuncCallArg
    " syntax cluster props add=typescriptSpecMethod
     " HiLink typescriptDOMDocMethod Keyword
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
