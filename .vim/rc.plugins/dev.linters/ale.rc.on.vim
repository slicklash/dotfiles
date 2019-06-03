if InitStep() == 0
    call dein#add('w0rp/ale')
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
\   'typescript': ['tslint'],
\   'python': ['black', 'isort'],
\}

" pip3 install vim-vint pylint
" npm i -g eslint jsonlint htmlhint stylelint typescript
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['tsserver'],
\   'html': ['htmlhint'],
\   'css': ['stylelint'],
\   'scss': ['stylelint'],
\   'sass': ['stylelint'],
\   'json': ['jsonlint'],
\   'vim': ['vint'],
\   'python': ['pylint'],
\}

let g:ale_python_pylint_options = '--disable=missing-docstring,invalid-name --extension-pkg-whitelist=cv2'
let g:ale_python_flake8_options = '--ignore=E501,F403'
let g:ale_python_autopep8_options = '--max-line-lengthi 125'
let g:ale_python_black_options = '--skip-string-normalization'

function! s:is_local(linter) abort
   let l:path = ale#path#FindNearestFile(bufnr('%'), 'node_modules/.bin/' . a:linter)
   return !empty(l:path)
endfunction

if !has('gui_running')
  let s:missing_linters = uniq(sort(
        \ map(values(
        \ filter(copy(g:ale_linters), { k, v -> !executable(v[0]) && !s:is_local(v[0]) })),
        \ { i, v -> '  ' . v[0] })))
  if len(s:missing_linters)
    echoerr 'Missing linters'
    echo join(s:missing_linters, "\n")
  endif
endif

call ale#linter#Define('javascript', {
      \   'name': 'eslint-src',
      \   'output_stream': 'both',
      \   'executable_callback': 'ale#handlers#eslint#GetExecutable',
      \   'command_callback': 'GetCommand',
      \   'callback': 'HandleErrors',
      \})

function! GetCommand(buffer) abort
  let l:cmd=ale#handlers#eslint#GetCommand(a:buffer)
  let l:p=match(l:cmd, '--stdin')
  let l:cmd=strpart(l:cmd, 0, l:p)
  return l:cmd
endfunction

let s:col_end_patterns = [
      \   '\vParsing error: Unexpected token (.+) ?',
      \   '\v''(.+)'' is not defined.',
      \   '\v%(Unexpected|Redundant use of) [''`](.+)[''`]',
      \   '\vUnexpected (console) statement',
      \]

function! HandleErrors(buffer, lines) abort
  let l:pattern = '^\(.*\):\(\d\+\):\(\d\+\): \(.\+\) \[\(.\+\)\]$'
  let l:parsing_pattern = '^\(.*\):\(\d\+\):\(\d\+\): \(.\+\)$'
  let l:errors = []

  for l:match in ale#util#GetMatches(a:lines, [l:pattern, l:parsing_pattern])
    let l:text = l:match[4]

    let l:obj = {
          \   'filename': l:match[1],
          \   'lnum': l:match[2] + 0,
          \   'col': l:match[3] + 0,
          \   'text': l:text,
          \   'type': 'E',
          \}

    let l:split_code = split(l:match[5], '/')

    if get(l:split_code, 0, '') is# 'Warning'
      let l:obj.type = 'W'
    endif
    if !empty(get(l:split_code, 1))
      let l:obj.code = join(l:split_code[1:], '/')
    endif
    for l:col_match in ale#util#GetMatches(l:text, s:col_end_patterns)
      let l:obj.end_col = l:obj.col + len(l:col_match[1]) - 1
    endfor
    call add(l:errors, l:obj)
  endfor

  if !empty(l:errors)
    lopen
  endif

  return l:errors
endfunction

function! LintProject() abort
  try
    let l:src = ale#path#FindNearestDirectory(bufnr('%'), 'src')
    if empty(l:src)
      return
    endif
    let b:ale_javascript_eslint_options=l:src
    let b:ale_linters = {'javascript': ['eslint-src']}
    ALELint
  finally
    unlet! b:ale_javascript_eslint_options
    unlet! b:ale_linters
  endtry
endfunction

nnoremap <silent> <Leader>x :ALEFix<CR>
nnoremap <silent> <Leader>l :call LintProject()<CR>
nnoremap <silent> ]w :ALENextWrap<CR>
nnoremap <silent> [w :ALEPreviousWrap<CR>
