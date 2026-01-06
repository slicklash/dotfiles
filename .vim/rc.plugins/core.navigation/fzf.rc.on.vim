let missing = Missing('rg', 'bat', 'delta')
if !empty(missing)
  echo 'Error while processing ' . resolve(expand('<sfile>:p'))
  echo 'Error: missing '.missing
  cquit
endif

call dein#add('junegunn/fzf', { 'rev': '3c7cbc9d476025e0cf90e2303bce38935898df1f', 'build': './install --bin', 'merged': 0 })
call dein#add('junegunn/fzf.vim', { 'rev': 'ddc14a6a5471147e2a38e6b32a7268282f669b0a', 'depends': 'fzf' })

function! s:setup() abort
  let g:fzf_options = ['--style=minimal', '--layout=reverse', '--info=inline', '--preview-window=right:70%']
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
  let g:fzf_action = {
    \ 'ctrl-q': function('s:build_quickfix_list'),
    \ 'ctrl-f': function('s:git_fixup'),
    \ 'ctrl-s': function('s:git_autosquash'),
    \ 'ctrl-m': 'split',
    \ 'ctrl-l': 'vsplit',
    \ 'ctrl-n': 'tabedit' }

  nnoremap <Space>f <cmd>call _fzf()<CR>
  nnoremap <Space>F <cmd>call _fzf({'ft': '?'})<CR>
  nnoremap <Space>a <cmd>call _fzf({'dir': GetProjectDir()})<CR>
  nnoremap <Space>m <cmd>call SearchModules()<CR>
  nnoremap <Space>A <cmd>call _fzf({'dir': GetProjectDir(), 'ft': '?'})<CR>

  nnoremap <Space>g <cmd>call SearchGit({'source': 'git log'})<CR>
  nnoremap <Space>o <cmd>call SearchGit({'source': 'git log', 'preview_args': '--name-only'})<CR>

  nnoremap <Space>c <cmd>call _fzf({'dir': '~/.vim/', 'ignore':['.denite', '.cache', 'cache', 'bundle*', '.dein', 'tmp']})<CR>
  nnoremap <Space>z <cmd>call _fzf({'dir': '~/.zsh/'})<CR>
  nnoremap <Space>` <cmd>call _fzf({'dir': '~/'})<CR>

  nnoremap <Space>b <cmd>call fzf#vim#buffers('', fzf#vim#with_preview({'placeholder': "{1}", 'options': g:fzf_options}))<CR>

  nnoremap <Space>d <cmd>call _fzf({'dir': expand('%:p:h')})<CR>
  nnoremap <Space>h <cmd>Helptags<CR>
  nnoremap <Space>r <cmd>call fzf#vim#history(fzf#vim#with_preview({'options': g:fzf_options}))<CR>
  nnoremap <Space>; <cmd>History:<CR>

  nnoremap <Leader>fd <cmd>call _fzf({'grep': expand('<cword>')})<CR>
  nnoremap <Leader>fa <cmd>call _fzf({'grep': expand('<cword>'), 'dir': GetProjectDir()})<CR>
  nnoremap <Space>p <cmd>call _fzf({'grep': expand('%:t:r')})<CR>

  nnoremap <Space>/ <cmd>call SearchIn('')<CR>
  nnoremap <Space>? <cmd>call SearchIn('', v:none, {'ft': '?'})<CR>
  nnoremap <Space>\ <cmd>call SearchIn(GetProjectDir())<CR>
  nnoremap <Space>\| <cmd>call SearchIn(GetProjectDir(), v:none, {'ft': '?'})<CR>
endfunction

autocmd User InitPost ++once call s:setup()

function! _rg(ignores, ...)
  let rg_options = extend(['rg', '--hidden', '--no-ignore-vcs', '--column', '--line-number', '--no-heading', '--smart-case'], a:000)
  for item in a:ignores
    call extend(rg_options, ['--glob', "'!" . item . "'"])
  endfor
  return join(rg_options, ' ')
endfunction

function! _fzf(...) abort
  let params = get(a:000, 0, {})
  let dir = get(params, 'dir')
  let source = get(params, 'source', '')
  let grep = get(params, 'grep', '')
  let ft = get(params, 'ft')
  if empty(ft)
    let tmp = matchstr(grep, '--ft=.*')
    if !empty(tmp)
      let ft = substitute(tmp, '--ft=', '', '')
      let grep = substitute(grep, tmp, '', '')
    endif
  endif
  if empty(source)
    let ignore = get(params, 'ignore', [
          \ '.git',
          \ '__pycache__',
          \ '.venv',
          \ '.turbo',
          \ '.mypy_cache',
          \ '.pytest_cache',
          \ 'node_modules',
          \ 'target',
          \ 'dist',
          \ 'bin/main',
          \ 'bin/test',
          \ 'build/src',
          \ 'build/classes',
          \ 'build/generated',
          \ 'build/resources',
          \ 'htmlcov/',
          \ 'Library/',
          \ '.Trash/',
          \ ])
    let source = empty(grep) ? _rg(ignore, '--files') : _rg(ignore)
    if !empty(ft)
      if ft == '?'
        let ft = input('Type: ')
      endif
      let source .= ' -t '. ft
    endif
  endif

  let options = fzf#vim#with_preview({'source': source, 'options': g:fzf_options})
  if !empty(dir)
    let options.dir = dir
  endif
  if !empty(grep)
    call remove(options, 'source')
    call fzf#vim#grep(source . ' -- ' . grep, 1, options)
  else
    call fzf#run(fzf#wrap(options))
  endif
endfunction

function! SearchIn(dir, ...) abort
  let pattern = a:0 > 0 && a:1 != v:none ? a:1 : input('Pattern: ')
  let options = get(a:000, 1, {})
  if empty(pattern)
    return
  endif
  call _fzf(extend({'grep': pattern, 'dir': a:dir}, options))
endfunction

function! SearchModules() abort
  call _fzf({'dir': GetProjectDir() . '/node_modules'})
endfunction

function! SearchGit(...) abort
  let params = get(a:000, 0, {})
  let source = get(params, 'source', 'git log')

  let git_log_format = get(params, 'format', '%C(yellow)%h %C(bold blue)%>(12,trunc)%cr%Creset %C(red)%d%Creset %s %C(bold black)%an%Creset')
  let git_log_args = get(params, 'source_args', '--abbrev=7 --oneline --format="'.git_log_format.'"')
  if source == 'git log'
    let source = source . ' ' . git_log_args
  endif

  let git_show_args = get(params, 'preview_args', '')
  let git_show = 'hash=$(echo {} | grep -o "[a-f0-9]\{7,\}"); [ -n "$hash" ] && git show --color=always '.git_show_args.' $hash || echo "No valid commit selected"'

  let preview = get(params, 'preview', git_show)

  let fzf_options = copy(g:fzf_options)
  call add(fzf_options, '--preview='.preview)
  call add(fzf_options, '--preview-window=right:55%')
  call fzf#run(fzf#wrap({'source': source, 'options': fzf_options}))
endfunction

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
endfunction

function! s:git_fixup(lines)
  let hash = matchstr(a:lines[0], '[a-f0-9]\{7,\}')
  if (!empty(hash))
    let cmd = 'git commit --fixup=' . hash
    execute 'silent !'.cmd
    redraw!
    call EchoHi(cmd)
  endif
endfunction

function! s:git_autosquash(lines)
  let hash = matchstr(a:lines[0], '[a-f0-9]\{7,\}')
  if (!empty(hash))
    let cmd = 'zsh -i -c ''git rebase -i --autosquash --autostash ' . hash . ';exec zsh'''
    execute 'silent !tmux splitw -v "' .  cmd . '"'
  endif
endfunction
