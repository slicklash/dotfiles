if InitStep() == 0
  call dein#add('Quramy/tsuquyomi', { 'on_ft': ['typescript', 'javascript'] } )
  finish
endif

let g:tsuquyomi_javascript_support = 1
let g:tsuquyomi_disable_quickfix = 1

augroup filetype_typescript
  autocmd!
  autocmd FileType typescript,javascript call s:ft_typescript()
augroup END

if dein#tap('neocomplete.vim')
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif

  let g:neocomplete#force_omni_input_patterns.javascript = '[^. *\t]\.\w*\|\h\w*::'
  let g:neocomplete#sources.javascript = ['dictionary', 'syntax', 'omni', 'neosnippet', 'member']
endif

function! s:ft_typescript() abort

  nnoremap <buffer> <leader>gd :TsuDefinition<cr>
  nnoremap <buffer> <leader>gi :TsuImplementation<cr>
  nnoremap <buffer> <leader>b :TsuGoBack<cr>

  nnoremap <buffer> <leader>fr :TsuReferences<cr>

  nnoremap <buffer> <leader>rr :TsuRenameSymbol<cr>

  nnoremap <buffer> <leader>h :TsuSignatureHelp<cr>

  nnoremap <buffer> <silent><leader>i :call<SID>import()<cr>

  setlocal omnifunc=tsuquyomi#complete
  setlocal shiftwidth=2
  setlocal formatprg=prettier\ --stdin

  if &filetype =~? 'javascript'
    setlocal filetype=javascript.jsx
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
    TsuImport
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


let s:react_comp = {
      \ 'is_selectable' : 0,
      \ }

function! s:react_comp.func(candidates) abort

  let l:dir = a:candidates.action__path . '/'

  call inputsave()
  let l:name = input('Name: ')
  call inputrestore()
  normal :<ESC>

  let l:dir .= l:name . '/'

  if isdirectory(l:dir)
    echohl ErrorMsg | echo 'Directory already exists' | echohl None
    return
  endif

  call mkdir(l:dir)

  let l:F = { n, p -> ExpandSnippet('javascript/react.snip', n, p) }

  let l:files = [
        \   ['index.js', [printf("export {default} from './%s';", l:name)]],
        \   [l:name . '.js', l:F('rco', [l:name])],
        \   [l:name . '.scss', ['.container {', '}']],
        \ ]

  for [fileName, lines] in l:files
    call writefile(lines, l:dir . fileName)
  endfor

endfunction

call unite#custom#action('directory', 'new react component', s:react_comp)
