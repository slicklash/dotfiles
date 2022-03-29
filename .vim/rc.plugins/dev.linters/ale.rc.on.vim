if InitStep() == 0
  call dein#add('w0rp/ale', { 'rev': '80dcd648d389965603246c2c5a4554e3e4aa184c' })
  finish
endif

scriptencoding utf-8

if has('unix')
    let g:ale_sign_error = '✗'
    let g:ale_sign_warning = '∆'
endif

highlight ALEWarning ctermbg=none
highlight ALEWarning ctermbg=88

let g:ale_sign_column_always = 1
let g:ale_lint_delay = 300
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_ignore_2_4_warnings = 1

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s'

let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'python': ['black', 'isort'],
\   'nim':  ['nimpretty'],
\}

" pip3 install vim-vint pylint
" npm i -g eslint jsonlint htmlhint stylelint typescript
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'html': ['htmlhint'],
\   'css': ['stylelint'],
\   'scss': ['stylelint'],
\   'sass': ['stylelint'],
\   'json': ['jsonlint'],
\   'vim': ['vint'],
\   'python': ['pylint'],
\   'nim': ['nimlsp', 'nimcheck'],
\}

let g:ale_pattern_options = {
\   '.*\.min\.js$': {'ale_enabled': 0},
\}

let g:ale_python_pylint_options = '--disable=missing-docstring,invalid-name --extension-pkg-whitelist=cv2'
let g:ale_python_flake8_options = '--ignore=E501,F403'
let g:ale_python_autopep8_options = '--max-line-lengthi 125'
let g:ale_python_black_options = '--skip-string-normalization'
let g:ale_nim_nimpretty_options = '--indent:2'



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
