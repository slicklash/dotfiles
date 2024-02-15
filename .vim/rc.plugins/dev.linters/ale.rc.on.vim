if InitStep() == 0
  call dein#add('dense-analysis/ale', { 'rev': '6fd9f3c54f80cec8be364594246daf9ac41cbe3e' })
  finish
endif

scriptencoding utf-8

if has('unix')
    let g:ale_sign_error = '✖'
    let g:ale_sign_warning = '⚠'
endif

highlight ALEWarning ctermbg=none
highlight ALEWarning ctermbg=88

let g:ale_sign_column_always = 1
let g:ale_lint_delay = 300
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_ignore_2_4_warnings = 1
let g:ale_python_auto_poetry = 1

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s'

let g:ale_pattern_options = {
\   '.*\.min\.js$': {'ale_enabled': 0},
\}

" pip3 install vim-vint pylint
" npm i -g eslint jsonlint htmlhint stylelint typescript
let g:ale_linters = {
\   'javascript': ['eslint', 'yoshi'],
\   'typescript': ['eslint', 'yoshi'],
\   'go': ['gofmt'],
\   'html': ['htmlhint'],
\   'css': ['stylelint'],
\   'scss': ['stylelint'],
\   'sass': ['stylelint'],
\   'json': ['jq'],
\   'vim': ['vint'],
\   'nim': ['nimlsp', 'nimcheck'],
\   'python': ['flake8', 'mypy'],
\}


let g:ale_fixers = {
\   'java': ['google_java_format'],
\   'javascript': ['eslint', 'yoshifix'],
\   'json': ['jq'],
\   'typescript': ['eslint', 'yoshifix'],
\   'python': ['black', 'isort'],
\   'nim':  ['nimpretty'],
\   'go': ['gofmt'],
\}

let g:ale_java_javac_executable = 'javac -cp ~/bin/java-lsp/lombok.jar'

let g:ale_python_pylint_options = '--disable=missing-docstring,invalid-name --ignore-long-lines --extension-pkg-whitelist=cv2'
let g:ale_python_flake8_options = '--ignore=E501,F403'
let g:ale_python_autopep8_options = '--max-line-lengthi 125'
let g:ale_python_black_options = '--skip-string-normalization'
let g:ale_python_mypy_options = '--strict --follow-imports silent'

let g:ale_nim_nimpretty_options = '--indent:2'

function! YoshiFind(buffer) abort
   let path = ale#path#FindNearestFile(a:buffer, 'node_modules/.bin/yoshi-flow-editor')
   if !empty(path)
     return path
   endif
   let path = ale#path#FindNearestFile(a:buffer, 'node_modules/.bin/yoshi-flow-bm')
   if !empty(path)
     return path
   endif
   let path = ale#path#FindNearestFile(a:buffer, 'node_modules/.bin/yoshi-library')
   if !empty(path)
     return path
   endif
   let path = ale#path#FindNearestFile(a:buffer, 'node_modules/.bin/yoshi')
   if !empty(path)
     return path
   endif
   " echoerr 'yoshi not found'
endfunction

let yoshi = {
\   'name': 'yoshi',
\   'output_stream': 'both',
\   'executable': function('YoshiFind'),
\   'command': '%e lint --format json %s',
\   'callback': function('ale#handlers#eslint#HandleJSON'),
\}

call ale#linter#Define('javascript', yoshi)
call ale#linter#Define('typescript', yoshi)

function! YoshiFix(buffer) abort
  return {
  \   'command': YoshiFind(a:buffer) . ' lint --fix %t',
  \   'read_temporary_file': 1
  \}
endfunction

execute ale#fix#registry#Add('yoshifix', 'YoshiFix', ['javascript', 'typescript'], 'yoshi')

function! s:is_local(linter) abort
   let path = ale#path#FindNearestFile(bufnr('%'), 'node_modules/.bin/' . a:linter)
   return !empty(path)
endfunction

if !has('gui_running') && empty('$TERMUX_VERSION')
  let s:missing_linters = uniq(sort(
        \ map(values(
        \ filter(copy(g:ale_linters), { k, v -> !executable(v[0]) && !s:is_local(v[0]) })),
        \ { i, v -> '  ' . v[0] })))
  if len(s:missing_linters)
    echoerr 'Missing linters'
    echo join(s:missing_linters, "\n")
  endif
endif

nnoremap <silent> <Leader>x :ALEFix<CR>
nnoremap <silent> ]w :ALENextWrap<CR>
nnoremap <silent> [w :ALEPreviousWrap<CR>
