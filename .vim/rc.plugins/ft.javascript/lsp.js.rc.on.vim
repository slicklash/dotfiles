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
  let b:project_dir='/home/slicklash/code/app-market/communities'

  if &filetype =~? 'javascript'
    setlocal suffixesadd=.ts,.tsx,.js,.jsx
    setlocal filetype=javascript.jsx
    setlocal formatprg=prettier\ --parser\ babel\ --single-quote\ --trailing-comma\ es5
  elseif &filetype =~? 'typescript'
    setlocal suffixesadd=.ts,.tsx,.js,.jsx
    setlocal filetype=typescript.tsx
    setlocal formatexpr=
    setlocal formatprg=prettier\ --parser\ typescript\ --single-quote\ --trailing-comma\ es5
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

  let cw = expand('<cword>')
  let known = get(s:know_imports, cw, v:none)

  if type(known) == v:t_none
    JsFileImport
    return
  endif

  let last_view = winsaveview()
  let last_search = getreg('/')
  let l = line('.')
  let c = col('.')

  normal gg}

  if type(known) == v:t_string
    let import = printf("import %s from '%s';", cw, known)
  else
    let import = printf("import %s from '%s';'", known[0], known[1])
  endif

  call setline('.', import)
  normal o

  call winrestview(last_view)
  call cursor(l + 1, c)
  call setreg('/', last_search)

endfunction
