vim9script

var know_imports = {
      \ 'UI': 'editor-ui-lib',
      \ 'UIx': ['{UI}', 'editor-ui-lib'],
      \ }

def FtJsTs()
  if &filetype !~? '\(javascript\|typescript\)'
    return
  endif

  setlocal sw=2 sts=2 ts=2 et

  setlocal tagfunc=lsp#lsp#TagFunc

  nnoremap <buffer> <silent><leader>i <ScriptCmd>Import()<CR>
  nnoremap <buffer> <silent><leader>tt <cmd>LspOutline toggle<CR>

  b:keyword_lookup_url = 'https://developer.mozilla.org/en-US/search?q=%s&topic=js'

  setlocal suffixesadd=.ts,.tsx,.js,.jsx

  if &filetype =~? 'javascript'
    if expand('%:e') =~? 'jsx'
      setlocal filetype=javascript.jsx
    endif
    setlocal formatprg=prettier\ --parser\ babel\ --single-quote\ --trailing-comma\ es5\ --tab-width\ 2
  elseif &filetype =~? 'typescript'
    if expand('%:e') =~? 'tsx'
      setlocal filetype=typescript.tsx
    endif
    setlocal formatexpr=
    setlocal formatprg=prettier\ --parser\ typescript\ --single-quote\ --trailing-comma\ es5\ --tab-width\ 2
    syntax keyword typescriptSpecMethod describe it context test expect nextgroup=typescriptFuncCallArg
  endif
enddef

def Import()
  var cw = expand('<cword>')

  if !has_key(know_imports, cw)
    execute 'JsFileImport'
    return
  endif

  var known = know_imports[cw]

  var last_view = winsaveview()
  var last_search = getreg('/')
  var l = line('.')
  var c = col('.')

  normal gg}

  var importline: string
  if type(known) == v:t_string
    importline = printf("import %s from '%s';", cw, known)
  else
    importline = printf("import %s from '%s';'", known[0], known[1])
  endif

  setline('.', importline)
  normal o

  winrestview(last_view)
  cursor(l + 1, c)
  setreg('/', last_search)
enddef

augroup filetype_js_ts
  autocmd!
  autocmd FileType * FtJsTs()
augroup END
