vim9script
scriptencoding utf-8

dein#add('dense-analysis/ale', {'rev': '178fe113564d31cba304263765aeb21e7ed23a7e'})

g:ale_sign_error = '✖'
g:ale_sign_warning = '⚠'

g:ale_sign_column_always = 1
g:ale_lint_delay = 300
g:ale_lint_on_text_changed = 'never'
g:ale_lint_on_enter = 0
g:ale_ignore_2_4_warnings = 1
g:ale_python_auto_poetry = 1

g:ale_echo_msg_error_str = 'E'
g:ale_echo_msg_warning_str = 'W'
g:ale_echo_msg_format = '[%linter%] %s'

g:ale_pattern_options = {
      \ '.*\.min\.js$': {'ale_enabled': 0},
      \ '.*\.env$': {'ale_enabled': 0},
      \ }

# pip3 install vim-vint pylint
# npm i -g eslint jsonlint htmlhint stylelint typescript

g:ale_linters = {
      \ 'javascript': ['eslint'],
      \ 'typescript': ['eslint'],
      \ 'go': ['gofmt'],
      \ 'html': ['htmlhint'],
      \ 'css': ['stylelint'],
      \ 'scss': ['stylelint'],
      \ 'sass': ['stylelint'],
      \ 'json': ['jq'],
      \ 'vim': ['vint'],
      \ 'nim': ['nimlsp', 'nimcheck'],
      \ 'python': ['ruff', 'mypy'],
      \ }

g:ale_fixers = {
      \ 'java': ['google_java_format'],
      \ 'javascript': ['eslint'],
      \ 'json': ['jq'],
      \ 'typescript': ['eslint'],
      \ 'python': ['ruff', 'isort'],
      \ 'nim': ['nimpretty'],
      \ 'go': ['gofmt'],
      \ }

g:ale_java_javac_executable = 'javac -cp ~/bin/java-lsp/lombok.jar'

g:ale_python_pylint_options = '--disable=missing-docstring,invalid-name --ignore-long-lines --extension-pkg-whitelist=cv2'
g:ale_python_mypy_options = '--strict --follow-imports silent'
g:ale_python_ruff_options = '--preview --select E,Q,I,FURB --ignore E501'

g:ale_nim_nimpretty_options = '--indent:2'

def Setup()
  nnoremap <silent> <Leader>x <cmd>call MyALEFix()<CR>
  nnoremap <silent> ]w <cmd>ALENextWrap<CR>
  nnoremap <silent> [w <cmd>ALEPreviousWrap<CR>

  highlight ALEWarning ctermbg=none
  highlight ALEWarning ctermbg=88
enddef

autocmd User InitPost ++once Setup()

def g:MyALEFix()
  execute 'ALEFix'

  if &filetype =~? 'typescript\|javascript'
    var view = winsaveview()
    g:OrganizeImports()
    var counts = ale#statusline#Count(bufnr(''))

    if counts.error == 0
      silent! undojoin
      execute 'silent keepjumps %!prettier --stdin-filepath ' .. shellescape(expand('%:p'))
    endif
    winrestview(view)
  endif
enddef

def g:OrganizeImports(...rest: list<any>)
  g:LspRequestCustom(
        \ 'typescriptlang',
        \ 'workspace/executeCommand',
        \ {
        \ 'command': '_typescript.organizeImports',
        \ 'arguments': [expand('%:p')],
        \ })
enddef

def IsLocal(linter: string): bool
  var path = ale#path#FindNearestFile(bufnr('%'), 'node_modules/.bin/' .. linter)
  return !empty(path)
enddef

if !has('gui_running') && empty('$TERMUX_VERSION')
  var missing_linters = uniq(sort(
        \ map(values(
        \ filter(copy(g:ale_linters), (k, v) => !executable(v[0]) && !IsLocal(v[0]))),
        \ (i, v) => '  ' .. v[0])))
  if len(missing_linters) > 0
    echoerr 'Missing linters'
    echo join(missing_linters, "\n")
  endif
endif
