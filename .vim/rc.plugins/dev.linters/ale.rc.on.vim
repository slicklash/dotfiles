scriptencoding utf-8

call dein#add('dense-analysis/ale', { 'rev': '6d9962946172fda4f25f9f5773b601aa4b2bedaf' })

let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'

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
\   '.*\.env$': {'ale_enabled': 0},
\}

" pip3 install vim-vint pylint
" npm i -g eslint jsonlint htmlhint stylelint typescript

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'go': ['gofmt'],
\   'html': ['htmlhint'],
\   'css': ['stylelint'],
\   'scss': ['stylelint'],
\   'sass': ['stylelint'],
\   'json': ['jq'],
\   'vim': ['vint'],
\   'nim': ['nimlsp', 'nimcheck'],
\   'python': ['ruff', 'mypy'],
\}

let g:ale_fixers = {
\   'java': ['google_java_format'],
\   'javascript': ['eslint'],
\   'json': ['jq'],
\   'typescript': ['eslint'],
\   'python': ['ruff', 'isort'],
\   'nim':  ['nimpretty'],
\   'go': ['gofmt'],
\}

let g:ale_java_javac_executable = 'javac -cp ~/bin/java-lsp/lombok.jar'

let g:ale_python_pylint_options = '--disable=missing-docstring,invalid-name --ignore-long-lines --extension-pkg-whitelist=cv2'
let g:ale_python_mypy_options = '--strict --follow-imports silent'
let g:ale_python_ruff_options = '--preview --select E,Q,I,FURB'

let g:ale_nim_nimpretty_options = '--indent:2'

function! s:setup() abort
  nnoremap <silent> <Leader>x <cmd>call MyALEFix()<CR>
  nnoremap <silent> ]w <cmd>ALENextWrap<CR>
  nnoremap <silent> [w <cmd>ALEPreviousWrap<CR>

  highlight ALEWarning ctermbg=none
  highlight ALEWarning ctermbg=88
endfunction

autocmd User InitPost ++once call s:setup()

function! MyALEFix() abort
  ALEFix

  if &filetype =~? 'typescript\|javascript'
    let l:view = winsaveview()
    call OrganizeImports()
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    if l:counts.error == 0
      silent! undojoin | silent keepjumps %!prettier --stdin-filepath %
    endif
    call winrestview(l:view)
  endif
endfunction

function! OrganizeImports(...) abort
 call g:LspRequestCustom(
            \ 'typescriptlang',
            \ 'workspace/executeCommand',
            \ {
            \   'command': '_typescript.organizeImports',
            \   'arguments': [expand('%:p')]
            \ }
            \ )
endfunction

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
